/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'channel.dart' as _i2;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i3;
import 'package:chatapp_server/src/generated/protocol.dart' as _i4;

abstract class ChannelViewState
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = ChannelViewStateTable();

  static const db = ChannelViewStateRepository._();

  @override
  int? id;

  int channelId;

  _i2.Channel? channel;

  int userId;

  _i3.UserInfo? user;

  int? lastReadMessageId;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChannelViewState',
      if (id != null) 'id': id,
      'channelId': channelId,
      if (channel != null) 'channel': channel?.toJsonForProtocol(),
      'userId': userId,
      if (user != null) 'user': user?.toJsonForProtocol(),
      if (lastReadMessageId != null) 'lastReadMessageId': lastReadMessageId,
    };
  }

  static ChannelViewStateInclude include({
    _i2.ChannelInclude? channel,
    _i3.UserInfoInclude? user,
  }) {
    return ChannelViewStateInclude._(
      channel: channel,
      user: user,
    );
  }

  static ChannelViewStateIncludeList includeList({
    _i1.WhereExpressionBuilder<ChannelViewStateTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChannelViewStateTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChannelViewStateTable>? orderByList,
    ChannelViewStateInclude? include,
  }) {
    return ChannelViewStateIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChannelViewState.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ChannelViewState.t),
      include: include,
    );
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

class ChannelViewStateUpdateTable
    extends _i1.UpdateTable<ChannelViewStateTable> {
  ChannelViewStateUpdateTable(super.table);

  _i1.ColumnValue<int, int> channelId(int value) => _i1.ColumnValue(
    table.channelId,
    value,
  );

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<int, int> lastReadMessageId(int? value) => _i1.ColumnValue(
    table.lastReadMessageId,
    value,
  );
}

class ChannelViewStateTable extends _i1.Table<int?> {
  ChannelViewStateTable({super.tableRelation})
    : super(tableName: 'channel_view_state') {
    updateTable = ChannelViewStateUpdateTable(this);
    channelId = _i1.ColumnInt(
      'channelId',
      this,
    );
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    lastReadMessageId = _i1.ColumnInt(
      'lastReadMessageId',
      this,
    );
  }

  late final ChannelViewStateUpdateTable updateTable;

  late final _i1.ColumnInt channelId;

  _i2.ChannelTable? _channel;

  late final _i1.ColumnInt userId;

  _i3.UserInfoTable? _user;

  late final _i1.ColumnInt lastReadMessageId;

  _i2.ChannelTable get channel {
    if (_channel != null) return _channel!;
    _channel = _i1.createRelationTable(
      relationFieldName: 'channel',
      field: ChannelViewState.t.channelId,
      foreignField: _i2.Channel.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ChannelTable(tableRelation: foreignTableRelation),
    );
    return _channel!;
  }

  _i3.UserInfoTable get user {
    if (_user != null) return _user!;
    _user = _i1.createRelationTable(
      relationFieldName: 'user',
      field: ChannelViewState.t.userId,
      foreignField: _i3.UserInfo.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.UserInfoTable(tableRelation: foreignTableRelation),
    );
    return _user!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    channelId,
    userId,
    lastReadMessageId,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'channel') {
      return channel;
    }
    if (relationField == 'user') {
      return user;
    }
    return null;
  }
}

class ChannelViewStateInclude extends _i1.IncludeObject {
  ChannelViewStateInclude._({
    _i2.ChannelInclude? channel,
    _i3.UserInfoInclude? user,
  }) {
    _channel = channel;
    _user = user;
  }

  _i2.ChannelInclude? _channel;

  _i3.UserInfoInclude? _user;

  @override
  Map<String, _i1.Include?> get includes => {
    'channel': _channel,
    'user': _user,
  };

  @override
  _i1.Table<int?> get table => ChannelViewState.t;
}

class ChannelViewStateIncludeList extends _i1.IncludeList {
  ChannelViewStateIncludeList._({
    _i1.WhereExpressionBuilder<ChannelViewStateTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ChannelViewState.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ChannelViewState.t;
}

class ChannelViewStateRepository {
  const ChannelViewStateRepository._();

  final attachRow = const ChannelViewStateAttachRowRepository._();

  /// Returns a list of [ChannelViewState]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<ChannelViewState>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChannelViewStateTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChannelViewStateTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChannelViewStateTable>? orderByList,
    _i1.Transaction? transaction,
    ChannelViewStateInclude? include,
  }) async {
    return session.db.find<ChannelViewState>(
      where: where?.call(ChannelViewState.t),
      orderBy: orderBy?.call(ChannelViewState.t),
      orderByList: orderByList?.call(ChannelViewState.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [ChannelViewState] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<ChannelViewState?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChannelViewStateTable>? where,
    int? offset,
    _i1.OrderByBuilder<ChannelViewStateTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChannelViewStateTable>? orderByList,
    _i1.Transaction? transaction,
    ChannelViewStateInclude? include,
  }) async {
    return session.db.findFirstRow<ChannelViewState>(
      where: where?.call(ChannelViewState.t),
      orderBy: orderBy?.call(ChannelViewState.t),
      orderByList: orderByList?.call(ChannelViewState.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [ChannelViewState] by its [id] or null if no such row exists.
  Future<ChannelViewState?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ChannelViewStateInclude? include,
  }) async {
    return session.db.findById<ChannelViewState>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [ChannelViewState]s in the list and returns the inserted rows.
  ///
  /// The returned [ChannelViewState]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ChannelViewState>> insert(
    _i1.Session session,
    List<ChannelViewState> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ChannelViewState>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ChannelViewState] and returns the inserted row.
  ///
  /// The returned [ChannelViewState] will have its `id` field set.
  Future<ChannelViewState> insertRow(
    _i1.Session session,
    ChannelViewState row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ChannelViewState>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ChannelViewState]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ChannelViewState>> update(
    _i1.Session session,
    List<ChannelViewState> rows, {
    _i1.ColumnSelections<ChannelViewStateTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ChannelViewState>(
      rows,
      columns: columns?.call(ChannelViewState.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChannelViewState]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ChannelViewState> updateRow(
    _i1.Session session,
    ChannelViewState row, {
    _i1.ColumnSelections<ChannelViewStateTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ChannelViewState>(
      row,
      columns: columns?.call(ChannelViewState.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChannelViewState] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ChannelViewState?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ChannelViewStateUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ChannelViewState>(
      id,
      columnValues: columnValues(ChannelViewState.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ChannelViewState]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ChannelViewState>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ChannelViewStateUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ChannelViewStateTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChannelViewStateTable>? orderBy,
    _i1.OrderByListBuilder<ChannelViewStateTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ChannelViewState>(
      columnValues: columnValues(ChannelViewState.t.updateTable),
      where: where(ChannelViewState.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChannelViewState.t),
      orderByList: orderByList?.call(ChannelViewState.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ChannelViewState]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ChannelViewState>> delete(
    _i1.Session session,
    List<ChannelViewState> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ChannelViewState>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ChannelViewState].
  Future<ChannelViewState> deleteRow(
    _i1.Session session,
    ChannelViewState row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ChannelViewState>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ChannelViewState>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ChannelViewStateTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ChannelViewState>(
      where: where(ChannelViewState.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChannelViewStateTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ChannelViewState>(
      where: where?.call(ChannelViewState.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ChannelViewStateAttachRowRepository {
  const ChannelViewStateAttachRowRepository._();

  /// Creates a relation between the given [ChannelViewState] and [Channel]
  /// by setting the [ChannelViewState]'s foreign key `channelId` to refer to the [Channel].
  Future<void> channel(
    _i1.Session session,
    ChannelViewState channelViewState,
    _i2.Channel channel, {
    _i1.Transaction? transaction,
  }) async {
    if (channelViewState.id == null) {
      throw ArgumentError.notNull('channelViewState.id');
    }
    if (channel.id == null) {
      throw ArgumentError.notNull('channel.id');
    }

    var $channelViewState = channelViewState.copyWith(channelId: channel.id);
    await session.db.updateRow<ChannelViewState>(
      $channelViewState,
      columns: [ChannelViewState.t.channelId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [ChannelViewState] and [UserInfo]
  /// by setting the [ChannelViewState]'s foreign key `userId` to refer to the [UserInfo].
  Future<void> user(
    _i1.Session session,
    ChannelViewState channelViewState,
    _i3.UserInfo user, {
    _i1.Transaction? transaction,
  }) async {
    if (channelViewState.id == null) {
      throw ArgumentError.notNull('channelViewState.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $channelViewState = channelViewState.copyWith(userId: user.id);
    await session.db.updateRow<ChannelViewState>(
      $channelViewState,
      columns: [ChannelViewState.t.userId],
      transaction: transaction,
    );
  }
}
