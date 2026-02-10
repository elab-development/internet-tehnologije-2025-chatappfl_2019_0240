/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i2;
import 'package:chatapp_server/src/generated/protocol.dart' as _i3;

abstract class UserPublicProfile
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  UserPublicProfile._({
    required this.userInfo,
    required this.isOnline,
  });

  factory UserPublicProfile({
    required _i2.UserInfo userInfo,
    required bool isOnline,
  }) = _UserPublicProfileImpl;

  factory UserPublicProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserPublicProfile(
      userInfo: _i3.Protocol().deserialize<_i2.UserInfo>(
        jsonSerialization['userInfo'],
      ),
      isOnline: jsonSerialization['isOnline'] as bool,
    );
  }

  _i2.UserInfo userInfo;

  bool isOnline;

  /// Returns a shallow copy of this [UserPublicProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserPublicProfile copyWith({
    _i2.UserInfo? userInfo,
    bool? isOnline,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserPublicProfile',
      'userInfo': userInfo.toJson(),
      'isOnline': isOnline,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserPublicProfile',
      'userInfo': userInfo.toJsonForProtocol(),
      'isOnline': isOnline,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _UserPublicProfileImpl extends UserPublicProfile {
  _UserPublicProfileImpl({
    required _i2.UserInfo userInfo,
    required bool isOnline,
  }) : super._(
         userInfo: userInfo,
         isOnline: isOnline,
       );

  /// Returns a shallow copy of this [UserPublicProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserPublicProfile copyWith({
    _i2.UserInfo? userInfo,
    bool? isOnline,
  }) {
    return UserPublicProfile(
      userInfo: userInfo ?? this.userInfo.copyWith(),
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
