import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;
import '../generated/protocol.dart' as protocol;

class ChatEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  // 1. DOBAVLJANJE ISTORIJE
  Future<List<protocol.Message>> getPastMessages(
    Session session,
    int channelId,
  ) async {
    print('🚌 Lasta 493: Učitavam istoriju za kanal: $channelId');
    return await protocol.Message.db.find(
      session,
      where: (t) => t.channelId.equals(channelId),
      orderBy: (t) => t.timestamp,
      orderDescending: true,
      limit: 50,
      // Ovo omogućava da message.sender?.userName radi na klijentu
      include: protocol.Message.include(sender: auth.UserInfo.include()),
    );
  }

  // 2. SLANJE PORUKE
  Future<void> sendMessage(Session session, protocol.Message message) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return;

    final userInfo = await auth.Users.findUserByIdentifier(
      session,
      authInfo.userIdentifier,
    );
    if (userInfo == null || userInfo.id == null) return;

    // Postavljamo server-side podatke (bezbednije nego da šalje klijent)
    message.senderId = userInfo.id!;
    message.timestamp = DateTime.now();
    message.sender = userInfo; // Da bi klijent odmah imao ime u listi

    try {
      // Čuvanje u bazu
      final savedMessage = await protocol.Message.db.insertRow(
        session,
        message,
      );

      // Dodajemo sender info da klijent odmah ima ime
      savedMessage.sender = userInfo;

      // Slanje svim korisnicima koji slušaju kanal
      session.messages.postMessage(
        'channel_${message.channelId}',
        savedMessage,
      );
    } catch (e) {
      print('❌ Greška na liniji 493 (sendMessage): $e');
    }
  }

  @override
  Future<void> streamOpened(StreamingSession session) async {
    final authInfo = await session.authenticated;
    if (authInfo != null) {
      // Slušamo poruke i prosleđujemo ih klijentu
      session.messages.addListener('channel_global', (message) {
        sendStreamMessage(session, message);
      });
      print('🟢 Korisnik ${authInfo.userIdentifier} se priključio vožnji.');
    }
    // Primer: Pretpostavljamo da korisnik može biti član više kanala
    final userInfo = await auth.Users.findUserByIdentifier(
      session,
      authInfo!.userIdentifier,
    );
    if (userInfo != null && userInfo.id != null) {
      final memberships = await protocol.ChannelMember.db.find(
        session,
        where: (t) => t.userId.equals(userInfo.id!),
      );
      for (final membership in memberships) {
        final channelId = membership.channelId;
        session.messages.addListener('channel_$channelId', (message) {
          sendStreamMessage(session, message);
        });
      }
    }
  }

  @override
  Future<void> streamClosed(StreamingSession session) async {
    print('🔴 Korisnik je napustio liniju.');
  }
}
