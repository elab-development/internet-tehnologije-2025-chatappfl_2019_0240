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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i2;
import 'package:chatapp_client/src/protocol/protocol.dart' as _i3;

abstract class FcmToken implements _i1.SerializableModel {
  FcmToken._({
    this.id,
    required this.userId,
    this.user,
    required this.token,
    required this.deviceType,
  });

  factory FcmToken({
    int? id,
    required int userId,
    _i2.UserInfo? user,
    required String token,
    required String deviceType,
  }) = _FcmTokenImpl;

  factory FcmToken.fromJson(Map<String, dynamic> jsonSerialization) {
    return FcmToken(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      user: jsonSerialization['user'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.UserInfo>(jsonSerialization['user']),
      token: jsonSerialization['token'] as String,
      deviceType: jsonSerialization['deviceType'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  _i2.UserInfo? user;

  String token;

  String deviceType;

  /// Returns a shallow copy of this [FcmToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FcmToken copyWith({
    int? id,
    int? userId,
    _i2.UserInfo? user,
    String? token,
    String? deviceType,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FcmToken',
      if (id != null) 'id': id,
      'userId': userId,
      if (user != null) 'user': user?.toJson(),
      'token': token,
      'deviceType': deviceType,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FcmTokenImpl extends FcmToken {
  _FcmTokenImpl({
    int? id,
    required int userId,
    _i2.UserInfo? user,
    required String token,
    required String deviceType,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         token: token,
         deviceType: deviceType,
       );

  /// Returns a shallow copy of this [FcmToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FcmToken copyWith({
    Object? id = _Undefined,
    int? userId,
    Object? user = _Undefined,
    String? token,
    String? deviceType,
  }) {
    return FcmToken(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i2.UserInfo? ? user : this.user?.copyWith(),
      token: token ?? this.token,
      deviceType: deviceType ?? this.deviceType,
    );
  }
}
