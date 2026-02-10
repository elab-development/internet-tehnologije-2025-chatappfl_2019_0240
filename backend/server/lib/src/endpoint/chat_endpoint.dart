import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import '../generated/protocol.dart' as protocol;

class ChatEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Future<void> streamOpened(StreamingSession session) async {
    var authInfo = await session.authenticated;
    if (authInfo != null) {
      // 1. Dodajemo u online listu (kao što si već imao)
      // Koristimo Users.findUserByIdentifier da izbegnemo UUID bag
      var user = await Users.findUserByIdentifier(
        session,
        authInfo.userIdentifier,
      );
      if (user != null) _onlineUsers.add(user.id!);

      // 2. KLJUČNI DEO: Slušaj poruke i šalji ih nazad na telefon
      // Koristimo 'global' ili specifične kanale. Za početak, najsigurnije je slušati sve
      // a klijent će filtrirati, ili se pretplatiti na sobu pri ulasku.
      session.messages.addListener('channel_global', (message) {
        sendStreamMessage(session, message);
      });

      // Ako želiš da slušaš baš određenu sobu:
      // session.messages.addListener('channel-${nekiId}', (msg) => sendStreamMessage(session, msg));
    }
  }

  Future<void> sendMessage(Session session, protocol.Message message) async {
    var authInfo = await session.authenticated;
    if (authInfo == null) return;

    var userInfo = await Users.findUserByIdentifier(
      session,
      authInfo.userIdentifier!,
    );
    if (userInfo == null || userInfo.id == null) return;

    // 1. Osiguravamo validnost podataka
    message.senderId = userInfo.id!;
    message.timestamp = DateTime.now();

    try {
      // 2. Snimanje u bazu (da ostane trajno)
      await protocol.Message.db.insertRow(session, message);

      // 3. DINAMIČKI BROADCAST (Prave sobe / 1-na-1)
      // Umesto 'chat-493', koristimo ID kanala iz baze.
      // Svi klijenti koji su u toj sobi slušaće 'channel-${message.channelId}'
      var serverChannelName = 'channel-${message.channelId}';
      await session.messages.postMessage(serverChannelName, message);

      print('Poruka prosleđena u sobu: $serverChannelName');

      // 4. OVDE IDE OKIDAČ ZA NOTIFIKACIJE
      // TODO: NAĐI SVE ČLANOVE KANALA, PROVERI NJIHOVE FCM TOKENE I POŠALJI PUSH NOTIFIKACIJU
    } catch (e) {
      print('Greška u 493 backendu: $e');
    }
  }

  static final Set<int> _onlineUsers = {};

  @override
  Future<void> streamClosed(StreamingSession session) async {
    var auth = await session.authenticated;
    if (auth != null) {
      _onlineUsers.remove(auth.userId!);
      print('Korisnik ${auth.userId} je sada OFFLINE.');
    }
  }

  // Helper metoda koju ćemo zvati iz drugog endpointa
  static bool isUserOnline(int userId) => _onlineUsers.contains(userId);
}
