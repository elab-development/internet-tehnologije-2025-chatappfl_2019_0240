import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart' as auth;
// Obavezno uvozimo Users klasu za sigurno traženje po UUID-u
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import '../generated/protocol.dart' as protocol;

class UserEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<auth.UserInfo?> getMe(Session session) async {
    var authInfo = await session.authenticated;
    if (authInfo == null) return null;

    // 1. Prvo tražimo UserInfo profil preko UUID-a (userIdentifier u sesiji)
    var user = await auth.Users.findUserByIdentifier(
      session,
      authInfo.userIdentifier,
    );

    // 2. Ako ga nema, moramo ga napraviti koristeći tvoj email iz EmailAuth tabele
    if (user == null) {
      // Ovde koristimo 'email' jer tvoja tabela nema 'userIdentifier'
      var emailAuth = await auth.EmailAuth.db.findFirstRow(
        session,
        where: (t) => t.email.equals(authInfo.userIdentifier),
      );

      // Ako ne nađe po UUID-u, probaćemo da izvučemo bilo koji email povezan sa sesijom
      String userEmail = emailAuth?.email ?? authInfo.userIdentifier;
      String userName = userEmail.contains('@')
          ? userEmail.split('@')[0]
          : "Putnik";

      user = auth.UserInfo(
        userIdentifier: authInfo.userIdentifier,
        userName: userName,
        email: userEmail,
        created: DateTime.now(),
        scopeNames: [],
        blocked: false,
      );

      // Ubacujemo ga u bazu - sada će SELECT konačno vratiti više od 0 rows
      user = await auth.UserInfo.db.insertRow(session, user);
      print("USPEH: Kreiran profil za $userEmail");
    }

    return user;
  }

  Future<List<auth.UserInfo>> getAllAvailableUsers(Session session) async {
    var authInfo = await session.authenticated;
    if (authInfo == null) return [];

    // Prvo nađemo tebe da izvučemo tvoj pravi int ID iz baze
    var currentUser = await auth.Users.findUserByIdentifier(
      session,
      authInfo.userIdentifier,
    );

    var currentUserId = currentUser?.id;

    return await auth.UserInfo.db.find(
      session,
      where: (t) => currentUserId != null
          ? t.id.notEquals(currentUserId)
          : Constant.bool(true),
      orderBy: (t) => t.userName,
    );
  }

  Future<List<auth.UserInfo>> searchUsers(Session session, String query) async {
    var authInfo = await session.authenticated;
    if (authInfo == null) return [];

    var currentUser = await auth.Users.findUserByIdentifier(
      session,
      authInfo.userIdentifier,
    );

    var currentUserId = currentUser?.id;

    return await auth.UserInfo.db.find(
      session,
      where: (t) =>
          (t.userName.ilike('%$query%')) &
          (currentUserId != null
              ? t.id.notEquals(currentUserId)
              : Constant.bool(true)),
      orderBy: (t) => t.userName,
    );
  }

  Future<protocol.UserPublicProfile?> getUserPublicProfile(
    Session session,
    int userId,
  ) async {
    // Ovde je safe jer dobijamo int kao parametar
    var userInfo = await auth.UserInfo.db.findById(session, userId);
    if (userInfo == null) return null;

    return protocol.UserPublicProfile(
      userInfo: userInfo,
      isOnline: false,
    );
  }
}
