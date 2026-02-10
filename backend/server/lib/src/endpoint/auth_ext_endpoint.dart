import 'package:serverpod/serverpod.dart';

extension AuthenticationInfoUserId on AuthenticationInfo {
  int get userId {
    final id = int.tryParse(userIdentifier, radix: 10);
    if (id == null) throw FormatException('Nevažeći ID: $userIdentifier');
    return id;
  }
}
