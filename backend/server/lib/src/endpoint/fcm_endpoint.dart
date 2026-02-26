import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;
import 'package:googleapis_auth/auth_io.dart' as ga;
import '../generated/protocol.dart' as protocol;

class FcmEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  // ─── KLIJENT POZIVA OVO: sačuvaj token uređaja ───────────────────────────

  Future<void> saveToken(
    Session session,
    String token,
    String deviceType, // 'android' | 'ios' | 'web'
  ) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return;

    final user = await auth.Users.findUserByIdentifier(
      session,
      authInfo.userIdentifier,
    );
    if (user == null || user.id == null) return;

    // Pokušaj update ako već postoji isti (userId + token)
    final existing = await protocol.FcmToken.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(user.id!) & t.token.equals(token),
    );

    if (existing != null) {
      // Osveži deviceType / pushService ako se promijenio
      existing.deviceType = deviceType;
      existing.pushService = 'fcm';
      existing.createdAt = DateTime.now().toUtc();
      await protocol.FcmToken.db.updateRow(session, existing);
    } else {
      final newEntry = protocol.FcmToken(
        userId: user.id!,
        token: token,
        deviceType: deviceType,
        pushService: 'fcm',
        createdAt: DateTime.now().toUtc(),
      );
      await protocol.FcmToken.db.insertRow(session, newEntry);
    }

    print('📲 FCM token sačuvan za korisnika ${user.id} ($deviceType)');
  }

  // ─── KLIJENT POZIVA OVO: obriši token pri odjavi ─────────────────────────

  Future<void> deleteToken(Session session, String token) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return;

    final user = await auth.Users.findUserByIdentifier(
      session,
      authInfo.userIdentifier,
    );
    if (user == null || user.id == null) return;

    final existing = await protocol.FcmToken.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(user.id!) & t.token.equals(token),
    );

    if (existing != null) {
      await protocol.FcmToken.db.deleteRow(session, existing);
      print('🗑️ FCM token obrisan za korisnika ${user.id}');
    }
  }
}

// ─── SERVER INTERNI: šalje FCM push svim članovima kanala, osim pošiljaoca ─

Future<void> pushToChannelMembers(
  Session session,
  int channelId,
  int senderUserId,
  String channelName,
  String messagePreview,
  String senderName,
) async {
  // 1. Dohvati sve članove kanala (isključi pošiljaoca)
  final memberships = await protocol.ChannelMember.db.find(
    session,
    where: (t) => t.channelId.equals(channelId),
  );

  final recipientUserIds = memberships
      .map((m) => m.userId)
      .whereType<int>()
      .where((id) => id != senderUserId) // isključi pošiljaoca
      .toSet()
      .toList();

  if (recipientUserIds.isEmpty) return;

  // 2. Dohvati FCM tokene tih korisnika
  final fcmTokenRows = await protocol.FcmToken.db.find(
    session,
    where: (t) => t.userId.inSet(recipientUserIds.toSet()),
  );

  final tokens = fcmTokenRows.map((r) => r.token).toList();
  if (tokens.isEmpty) return;

  // 3. Pošalji FCM push notifikaciju (v1 API)
  await _sendFcmV1Batch(
    session: session,
    tokens: tokens,
    title: channelName,
    body: '$senderName: $messagePreview',
    data: {
      'channelId': '$channelId',
      'type': 'new_message',
    },
  );
}

// ─── FCM HTTP v1 API: OAuth2 service account slanje ─────────────────────

Future<void> _sendFcmV1Batch({
  required Session session,
  required List<String> tokens,
  required String title,
  required String body,
  required Map<String, String> data,
}) async {
  final serviceAccountJson = session.passwords['fcmServiceAccountJson'];
  if (serviceAccountJson == null || serviceAccountJson.isEmpty) {
    print('⚠️ FCM v1: fcmServiceAccountJson nije podešen u passwords.yaml!');
    return;
  }
  final Map<String, dynamic> saMap = jsonDecode(serviceAccountJson);
  final projectId = saMap['project_id'] as String?;
  if (projectId == null) {
    print('⚠️ FCM v1: project_id nije pronađen u service account JSON!');
    return;
  }
  final accountCredentials = ga.ServiceAccountCredentials.fromJson(
    serviceAccountJson,
  );
  const scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
  final authClient = await ga.clientViaServiceAccount(
    accountCredentials,
    scopes,
  );
  try {
    final url = Uri.parse(
      'https://fcm.googleapis.com/v1/projects/$projectId/messages:send',
    );
    for (final token in tokens) {
      final payload = {
        'message': {
          'token': token,
          'notification': {
            'title': title,
            'body': body,
          },
          'data': data,
          'android': {
            'priority': 'HIGH',
            'notification': {'sound': 'default'},
          },
          'apns': {
            'headers': {'apns-priority': '10'},
            'payload': {
              'aps': {'sound': 'default'},
            },
          },
        },
      };
      final resp = await authClient.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(payload),
      );
      if (resp.statusCode == 200) {
        // success for this token
      } else {
        print(
          '❌ FCM v1 error for token $token: \n${resp.statusCode} ${resp.body}',
        );
        // Cleanup: brisanje tokena ako je NOT_FOUND/INVALID_ARGUMENT
        final bodyMap = (resp.body.isNotEmpty)
            ? jsonDecode(resp.body) as Map<String, dynamic>
            : {};
        final err = bodyMap['error'] as Map<String, dynamic>?;
        final status = err?['status'] as String?;
        if (status == 'NOT_FOUND' ||
            status == 'INVALID_ARGUMENT' ||
            status == 'PERMISSION_DENIED') {
          final rows = await protocol.FcmToken.db.find(
            session,
            where: (t) => t.token.equals(token),
          );
          for (final r in rows) {
            await protocol.FcmToken.db.deleteRow(session, r);
          }
        }
      }
    }
  } finally {
    authClient.close();
  }
}

