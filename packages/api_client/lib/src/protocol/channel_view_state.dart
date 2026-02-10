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
import 'channel.dart' as _i2;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i3;
import 'package:chatapp_client/src/protocol/protocol.dart' as _i4;

abstract class ChannelViewState implements _i1.SerializableModel {
  ChannelViewState._({
    this.id,
    required this.channelId,
    this.channel,
    required this.userId,
    this.user,
    this.lastReadMessageId,
  });

  factory ChannelViewState({
    int? id,
    required int channelId,
    _i2.Channel? channel,
    required int userId,
    _i3.UserInfo? user,
    int? lastReadMessageId,
  }) = _ChannelViewStateImpl;

  factory ChannelViewState.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChannelViewState(
      id: jsonSerialization['id'] as int?,
      channelId: jsonSerialization['channelId'] as int,
      channel: jsonSerialization['channel'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.Channel>(
              jsonSerialization['channel'],
            ),
      userId: jsonSerialization['userId'] as int,
      user: jsonSerialization['user'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.UserInfo>(jsonSerialization['user']),
      lastReadMessageId: jsonSerialization['lastReadMessageId'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int channelId;

  _i2.Channel? channel;

  int userId;

  _i3.UserInfo? user;

  int? lastReadMessageId;

  /// Returns a shallow copy of this [ChannelViewState]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChannelViewState copyWith({
    int? id,
    int? channelId,
    _i2.Channel? channel,
    int? userId,
    _i3.UserInfo? user,
    int? lastReadMessageId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChannelViewState',
      if (id != null) 'id': id,
      'channelId': channelId,
      if (channel != null) 'channel': channel?.toJson(),
      'userId': userId,
      if (user != null) 'user': user?.toJson(),
      if (lastReadMessageId != null) 'lastReadMessageId': lastReadMessageId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChannelViewStateImpl extends ChannelViewState {
  _ChannelViewStateImpl({
    int? id,
    required int channelId,
    _i2.Channel? channel,
    required int userId,
    _i3.UserInfo? user,
    int? lastReadMessageId,
  }) : super._(
         id: id,
         channelId: channelId,
         channel: channel,
         userId: userId,
         user: user,
         lastReadMessageId: lastReadMessageId,
       );

  /// Returns a shallow copy of this [ChannelViewState]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChannelViewState copyWith({
    Object? id = _Undefined,
    int? channelId,
    Object? channel = _Undefined,
    int? userId,
    Object? user = _Undefined,
    Object? lastReadMessageId = _Undefined,
  }) {
    return ChannelViewState(
      id: id is int? ? id : this.id,
      channelId: channelId ?? this.channelId,
      channel: channel is _i2.Channel? ? channel : this.channel?.copyWith(),
      userId: userId ?? this.userId,
      user: user is _i3.UserInfo? ? user : this.user?.copyWith(),
      lastReadMessageId: lastReadMessageId is int?
          ? lastReadMessageId
          : this.lastReadMessageId,
    );
  }
}
