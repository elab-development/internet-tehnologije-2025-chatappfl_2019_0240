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
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i2;
import 'package:chatapp_server/src/generated/protocol.dart' as _i3;

abstract class FcmToken
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  FcmToken._({
    this.id,
    required this.userId,
    this.user,
    required this.token,
    required this.deviceType,
    required this.createdAt,
    this.pushedAt,
    required this.pushService,
  });

  factory FcmToken({
    int? id,
    required int userId,
    _i2.UserInfo? user,
    required String token,
    required String deviceType,
    required DateTime createdAt,
    DateTime? pushedAt,
    required String pushService,
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
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      pushedAt: jsonSerialization['pushedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['pushedAt']),
      pushService: jsonSerialization['pushService'] as String,
    );
  }

  static final t = FcmTokenTable();

  static const db = FcmTokenRepository._();

  @override
  int? id;

  int userId;

  _i2.UserInfo? user;

  String token;

  String deviceType;

  DateTime createdAt;

  DateTime? pushedAt;

  String pushService;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [FcmToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FcmToken copyWith({
    int? id,
    int? userId,
    _i2.UserInfo? user,
    String? token,
    String? deviceType,
    DateTime? createdAt,
    DateTime? pushedAt,
    String? pushService,
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
      'createdAt': createdAt.toJson(),
      if (pushedAt != null) 'pushedAt': pushedAt?.toJson(),
      'pushService': pushService,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FcmToken',
      if (id != null) 'id': id,
      'userId': userId,
      if (user != null) 'user': user?.toJsonForProtocol(),
      'token': token,
      'deviceType': deviceType,
      'createdAt': createdAt.toJson(),
      if (pushedAt != null) 'pushedAt': pushedAt?.toJson(),
      'pushService': pushService,
    };
  }

  static FcmTokenInclude include({_i2.UserInfoInclude? user}) {
    return FcmTokenInclude._(user: user);
  }

  static FcmTokenIncludeList includeList({
    _i1.WhereExpressionBuilder<FcmTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FcmTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FcmTokenTable>? orderByList,
    FcmTokenInclude? include,
  }) {
    return FcmTokenIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FcmToken.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(FcmToken.t),
      include: include,
    );
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
    required DateTime createdAt,
    DateTime? pushedAt,
    required String pushService,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         token: token,
         deviceType: deviceType,
         createdAt: createdAt,
         pushedAt: pushedAt,
         pushService: pushService,
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
    DateTime? createdAt,
    Object? pushedAt = _Undefined,
    String? pushService,
  }) {
    return FcmToken(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i2.UserInfo? ? user : this.user?.copyWith(),
      token: token ?? this.token,
      deviceType: deviceType ?? this.deviceType,
      createdAt: createdAt ?? this.createdAt,
      pushedAt: pushedAt is DateTime? ? pushedAt : this.pushedAt,
      pushService: pushService ?? this.pushService,
    );
  }
}

class FcmTokenUpdateTable extends _i1.UpdateTable<FcmTokenTable> {
  FcmTokenUpdateTable(super.table);

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> token(String value) => _i1.ColumnValue(
    table.token,
    value,
  );

  _i1.ColumnValue<String, String> deviceType(String value) => _i1.ColumnValue(
    table.deviceType,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> pushedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.pushedAt,
        value,
      );

  _i1.ColumnValue<String, String> pushService(String value) => _i1.ColumnValue(
    table.pushService,
    value,
  );
}

class FcmTokenTable extends _i1.Table<int?> {
  FcmTokenTable({super.tableRelation}) : super(tableName: 'fcm_token') {
    updateTable = FcmTokenUpdateTable(this);
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    token = _i1.ColumnString(
      'token',
      this,
    );
    deviceType = _i1.ColumnString(
      'deviceType',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    pushedAt = _i1.ColumnDateTime(
      'pushedAt',
      this,
    );
    pushService = _i1.ColumnString(
      'pushService',
      this,
    );
  }

  late final FcmTokenUpdateTable updateTable;

  late final _i1.ColumnInt userId;

  _i2.UserInfoTable? _user;

  late final _i1.ColumnString token;

  late final _i1.ColumnString deviceType;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime pushedAt;

  late final _i1.ColumnString pushService;

  _i2.UserInfoTable get user {
    if (_user != null) return _user!;
    _user = _i1.createRelationTable(
      relationFieldName: 'user',
      field: FcmToken.t.userId,
      foreignField: _i2.UserInfo.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserInfoTable(tableRelation: foreignTableRelation),
    );
    return _user!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    token,
    deviceType,
    createdAt,
    pushedAt,
    pushService,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'user') {
      return user;
    }
    return null;
  }
}

class FcmTokenInclude extends _i1.IncludeObject {
  FcmTokenInclude._({_i2.UserInfoInclude? user}) {
    _user = user;
  }

  _i2.UserInfoInclude? _user;

  @override
  Map<String, _i1.Include?> get includes => {'user': _user};

  @override
  _i1.Table<int?> get table => FcmToken.t;
}

class FcmTokenIncludeList extends _i1.IncludeList {
  FcmTokenIncludeList._({
    _i1.WhereExpressionBuilder<FcmTokenTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FcmToken.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => FcmToken.t;
}

class FcmTokenRepository {
  const FcmTokenRepository._();

  final attachRow = const FcmTokenAttachRowRepository._();

  /// Returns a list of [FcmToken]s matching the given query parameters.
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
  Future<List<FcmToken>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FcmTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FcmTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FcmTokenTable>? orderByList,
    _i1.Transaction? transaction,
    FcmTokenInclude? include,
  }) async {
    return session.db.find<FcmToken>(
      where: where?.call(FcmToken.t),
      orderBy: orderBy?.call(FcmToken.t),
      orderByList: orderByList?.call(FcmToken.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [FcmToken] matching the given query parameters.
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
  Future<FcmToken?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FcmTokenTable>? where,
    int? offset,
    _i1.OrderByBuilder<FcmTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FcmTokenTable>? orderByList,
    _i1.Transaction? transaction,
    FcmTokenInclude? include,
  }) async {
    return session.db.findFirstRow<FcmToken>(
      where: where?.call(FcmToken.t),
      orderBy: orderBy?.call(FcmToken.t),
      orderByList: orderByList?.call(FcmToken.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [FcmToken] by its [id] or null if no such row exists.
  Future<FcmToken?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    FcmTokenInclude? include,
  }) async {
    return session.db.findById<FcmToken>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [FcmToken]s in the list and returns the inserted rows.
  ///
  /// The returned [FcmToken]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<FcmToken>> insert(
    _i1.Session session,
    List<FcmToken> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<FcmToken>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [FcmToken] and returns the inserted row.
  ///
  /// The returned [FcmToken] will have its `id` field set.
  Future<FcmToken> insertRow(
    _i1.Session session,
    FcmToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<FcmToken>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [FcmToken]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<FcmToken>> update(
    _i1.Session session,
    List<FcmToken> rows, {
    _i1.ColumnSelections<FcmTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<FcmToken>(
      rows,
      columns: columns?.call(FcmToken.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FcmToken]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FcmToken> updateRow(
    _i1.Session session,
    FcmToken row, {
    _i1.ColumnSelections<FcmTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<FcmToken>(
      row,
      columns: columns?.call(FcmToken.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FcmToken] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FcmToken?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<FcmTokenUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<FcmToken>(
      id,
      columnValues: columnValues(FcmToken.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FcmToken]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<FcmToken>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<FcmTokenUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<FcmTokenTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FcmTokenTable>? orderBy,
    _i1.OrderByListBuilder<FcmTokenTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<FcmToken>(
      columnValues: columnValues(FcmToken.t.updateTable),
      where: where(FcmToken.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FcmToken.t),
      orderByList: orderByList?.call(FcmToken.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [FcmToken]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<FcmToken>> delete(
    _i1.Session session,
    List<FcmToken> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<FcmToken>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [FcmToken].
  Future<FcmToken> deleteRow(
    _i1.Session session,
    FcmToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FcmToken>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<FcmToken>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<FcmTokenTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<FcmToken>(
      where: where(FcmToken.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FcmTokenTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<FcmToken>(
      where: where?.call(FcmToken.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class FcmTokenAttachRowRepository {
  const FcmTokenAttachRowRepository._();

  /// Creates a relation between the given [FcmToken] and [UserInfo]
  /// by setting the [FcmToken]'s foreign key `userId` to refer to the [UserInfo].
  Future<void> user(
    _i1.Session session,
    FcmToken fcmToken,
    _i2.UserInfo user, {
    _i1.Transaction? transaction,
  }) async {
    if (fcmToken.id == null) {
      throw ArgumentError.notNull('fcmToken.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $fcmToken = fcmToken.copyWith(userId: user.id);
    await session.db.updateRow<FcmToken>(
      $fcmToken,
      columns: [FcmToken.t.userId],
      transaction: transaction,
    );
  }
}
