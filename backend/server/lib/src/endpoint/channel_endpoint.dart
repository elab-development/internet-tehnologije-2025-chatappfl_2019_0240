import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart' as auth;
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import '../generated/protocol.dart' as protocol;

class ChannelEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// 1. Kreiranje sobe i dodeljivanje Admin uloge kreatoru
  Future<protocol.Channel> createChannel(
    Session session,
    String name,
    String type,
  ) async {
    var authInfo = await session.authenticated;
    if (authInfo == null) throw Exception('Niste autentifikovani');

    // SIGURAN NAČIN: Umesto .userId, tražimo usera preko identifier-a
    var user = await Users.findUserByIdentifier(
      session,
      authInfo.userIdentifier,
    );
    if (user == null || user.id == null)
      throw Exception('Korisnik nije pronađen');

    // Kreiramo kanal
    var channel = protocol.Channel(name: name, type: type);
    channel = await protocol.Channel.db.insertRow(session, channel);

    // Kreatora odmah ubacujemo kao ADMINA koristeći siguran int ID
    var membership = protocol.ChannelMember(
      userId: user.id!,
      channelId: channel.id!,
      role: 'admin',
      joinedAt: DateTime.now(),
    );
    await protocol.ChannelMember.db.insertRow(session, membership);

    return channel;
  }

  /// 2. Menjanje naziva sobe (Samo za Admina)
  Future<bool> renameChannel(
    Session session,
    int channelId,
    String newName,
  ) async {
    if (await _isAdmin(session, channelId)) {
      var channel = await protocol.Channel.db.findById(session, channelId);
      if (channel != null) {
        channel.name = newName;
        await protocol.Channel.db.updateRow(session, channel);
        return true;
      }
    }
    return false;
  }

  /// 3. Dodavanje korisnika u sobu (Samo za Admina)
  Future<bool> addUserToChannel(
    Session session,
    int channelId,
    int invitedUserId,
  ) async {
    if (await _isAdmin(session, channelId)) {
      var membership = protocol.ChannelMember(
        userId: invitedUserId,
        channelId: channelId,
        role: 'member',
        joinedAt: DateTime.now(),
      );
      await protocol.ChannelMember.db.insertRow(session, membership);
      return true;
    }
    return false;
  }

  /// 4. Uklanjanje korisnika ili samostalno napuštanje
  Future<bool> removeUserFromChannel(
    Session session,
    int channelId,
    int userIdToRemove,
  ) async {
    var authInfo = await session.authenticated;
    if (authInfo == null) return false;

    // Uzimamo siguran ID trenutnog korisnika
    var user = await Users.findUserByIdentifier(
      session,
      authInfo.userIdentifier,
    );
    if (user == null) return false;

    bool isAdmin = await _isAdmin(session, channelId);
    bool isSelf = user.id == userIdToRemove;

    if (isAdmin || isSelf) {
      var memberRecord = await protocol.ChannelMember.db.findFirstRow(
        session,
        where: (t) =>
            t.channelId.equals(channelId) & t.userId.equals(userIdToRemove),
      );
      if (memberRecord != null) {
        await protocol.ChannelMember.db.deleteRow(session, memberRecord);
        return true;
      }
    }
    return false;
  }

  /// 5. Dobavljanje svih kanala u kojima je korisnik član
  Future<List<protocol.Channel>> getChannels(Session session) async {
    var authInfo = await session.authenticated;
    if (authInfo == null) return [];

    var user = await Users.findUserByIdentifier(
      session,
      authInfo.userIdentifier,
    );
    if (user == null || user.id == null) return [];

    var memberships = await protocol.ChannelMember.db.find(
      session,
      where: (t) => t.userId.equals(user.id!),
    );

    var channelIds = memberships.map((m) => m.channelId).toSet();
    if (channelIds.isEmpty) return [];

    return await protocol.Channel.db.find(
      session,
      where: (t) => t.id.inSet(channelIds),
      orderBy: (t) => t.name,
    );
  }

  /// JEDNA JEDINA Helper metoda: Proverava da li je trenutni korisnik Admin
  Future<bool> _isAdmin(Session session, int channelId) async {
    var authInfo = await session.authenticated;
    if (authInfo == null) return false;

    var user = await Users.findUserByIdentifier(
      session,
      authInfo.userIdentifier,
    );
    if (user == null) return false;

    var membership = await protocol.ChannelMember.db.findFirstRow(
      session,
      where: (t) => t.channelId.equals(channelId) & t.userId.equals(user.id!),
    );

    return membership?.role == 'admin';
  }
}
