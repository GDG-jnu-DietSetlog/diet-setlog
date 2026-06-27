// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friends.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Friend _$FriendFromJson(Map<String, dynamic> json) {
  return _Friend.fromJson(json);
}

/// @nodoc
mixin _$Friend {
  String get id => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  int get mutualFriendCount => throw _privateConstructorUsedError;
  bool get certifiedToday => throw _privateConstructorUsedError;

  /// Serializes this Friend to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Friend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendCopyWith<Friend> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendCopyWith<$Res> {
  factory $FriendCopyWith(Friend value, $Res Function(Friend) then) =
      _$FriendCopyWithImpl<$Res, Friend>;
  @useResult
  $Res call(
      {String id,
      String displayName,
      String? avatarUrl,
      int mutualFriendCount,
      bool certifiedToday});
}

/// @nodoc
class _$FriendCopyWithImpl<$Res, $Val extends Friend>
    implements $FriendCopyWith<$Res> {
  _$FriendCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Friend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? avatarUrl = freezed,
    Object? mutualFriendCount = null,
    Object? certifiedToday = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      mutualFriendCount: null == mutualFriendCount
          ? _value.mutualFriendCount
          : mutualFriendCount // ignore: cast_nullable_to_non_nullable
              as int,
      certifiedToday: null == certifiedToday
          ? _value.certifiedToday
          : certifiedToday // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FriendImplCopyWith<$Res> implements $FriendCopyWith<$Res> {
  factory _$$FriendImplCopyWith(
          _$FriendImpl value, $Res Function(_$FriendImpl) then) =
      __$$FriendImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String displayName,
      String? avatarUrl,
      int mutualFriendCount,
      bool certifiedToday});
}

/// @nodoc
class __$$FriendImplCopyWithImpl<$Res>
    extends _$FriendCopyWithImpl<$Res, _$FriendImpl>
    implements _$$FriendImplCopyWith<$Res> {
  __$$FriendImplCopyWithImpl(
      _$FriendImpl _value, $Res Function(_$FriendImpl) _then)
      : super(_value, _then);

  /// Create a copy of Friend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? avatarUrl = freezed,
    Object? mutualFriendCount = null,
    Object? certifiedToday = null,
  }) {
    return _then(_$FriendImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      mutualFriendCount: null == mutualFriendCount
          ? _value.mutualFriendCount
          : mutualFriendCount // ignore: cast_nullable_to_non_nullable
              as int,
      certifiedToday: null == certifiedToday
          ? _value.certifiedToday
          : certifiedToday // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendImpl implements _Friend {
  const _$FriendImpl(
      {required this.id,
      required this.displayName,
      this.avatarUrl,
      required this.mutualFriendCount,
      required this.certifiedToday});

  factory _$FriendImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendImplFromJson(json);

  @override
  final String id;
  @override
  final String displayName;
  @override
  final String? avatarUrl;
  @override
  final int mutualFriendCount;
  @override
  final bool certifiedToday;

  @override
  String toString() {
    return 'Friend(id: $id, displayName: $displayName, avatarUrl: $avatarUrl, mutualFriendCount: $mutualFriendCount, certifiedToday: $certifiedToday)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.mutualFriendCount, mutualFriendCount) ||
                other.mutualFriendCount == mutualFriendCount) &&
            (identical(other.certifiedToday, certifiedToday) ||
                other.certifiedToday == certifiedToday));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, displayName, avatarUrl,
      mutualFriendCount, certifiedToday);

  /// Create a copy of Friend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendImplCopyWith<_$FriendImpl> get copyWith =>
      __$$FriendImplCopyWithImpl<_$FriendImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendImplToJson(
      this,
    );
  }
}

abstract class _Friend implements Friend {
  const factory _Friend(
      {required final String id,
      required final String displayName,
      final String? avatarUrl,
      required final int mutualFriendCount,
      required final bool certifiedToday}) = _$FriendImpl;

  factory _Friend.fromJson(Map<String, dynamic> json) = _$FriendImpl.fromJson;

  @override
  String get id;
  @override
  String get displayName;
  @override
  String? get avatarUrl;
  @override
  int get mutualFriendCount;
  @override
  bool get certifiedToday;

  /// Create a copy of Friend
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendImplCopyWith<_$FriendImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FriendsResponse _$FriendsResponseFromJson(Map<String, dynamic> json) {
  return _FriendsResponse.fromJson(json);
}

/// @nodoc
mixin _$FriendsResponse {
  List<Friend> get friends => throw _privateConstructorUsedError;
  String? get nextCursor => throw _privateConstructorUsedError;

  /// Serializes this FriendsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FriendsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendsResponseCopyWith<FriendsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendsResponseCopyWith<$Res> {
  factory $FriendsResponseCopyWith(
          FriendsResponse value, $Res Function(FriendsResponse) then) =
      _$FriendsResponseCopyWithImpl<$Res, FriendsResponse>;
  @useResult
  $Res call({List<Friend> friends, String? nextCursor});
}

/// @nodoc
class _$FriendsResponseCopyWithImpl<$Res, $Val extends FriendsResponse>
    implements $FriendsResponseCopyWith<$Res> {
  _$FriendsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? friends = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_value.copyWith(
      friends: null == friends
          ? _value.friends
          : friends // ignore: cast_nullable_to_non_nullable
              as List<Friend>,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FriendsResponseImplCopyWith<$Res>
    implements $FriendsResponseCopyWith<$Res> {
  factory _$$FriendsResponseImplCopyWith(_$FriendsResponseImpl value,
          $Res Function(_$FriendsResponseImpl) then) =
      __$$FriendsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Friend> friends, String? nextCursor});
}

/// @nodoc
class __$$FriendsResponseImplCopyWithImpl<$Res>
    extends _$FriendsResponseCopyWithImpl<$Res, _$FriendsResponseImpl>
    implements _$$FriendsResponseImplCopyWith<$Res> {
  __$$FriendsResponseImplCopyWithImpl(
      _$FriendsResponseImpl _value, $Res Function(_$FriendsResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of FriendsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? friends = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_$FriendsResponseImpl(
      friends: null == friends
          ? _value._friends
          : friends // ignore: cast_nullable_to_non_nullable
              as List<Friend>,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendsResponseImpl implements _FriendsResponse {
  const _$FriendsResponseImpl(
      {final List<Friend> friends = const <Friend>[], this.nextCursor})
      : _friends = friends;

  factory _$FriendsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendsResponseImplFromJson(json);

  final List<Friend> _friends;
  @override
  @JsonKey()
  List<Friend> get friends {
    if (_friends is EqualUnmodifiableListView) return _friends;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_friends);
  }

  @override
  final String? nextCursor;

  @override
  String toString() {
    return 'FriendsResponse(friends: $friends, nextCursor: $nextCursor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendsResponseImpl &&
            const DeepCollectionEquality().equals(other._friends, _friends) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_friends), nextCursor);

  /// Create a copy of FriendsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendsResponseImplCopyWith<_$FriendsResponseImpl> get copyWith =>
      __$$FriendsResponseImplCopyWithImpl<_$FriendsResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendsResponseImplToJson(
      this,
    );
  }
}

abstract class _FriendsResponse implements FriendsResponse {
  const factory _FriendsResponse(
      {final List<Friend> friends,
      final String? nextCursor}) = _$FriendsResponseImpl;

  factory _FriendsResponse.fromJson(Map<String, dynamic> json) =
      _$FriendsResponseImpl.fromJson;

  @override
  List<Friend> get friends;
  @override
  String? get nextCursor;

  /// Create a copy of FriendsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendsResponseImplCopyWith<_$FriendsResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SearchUser _$SearchUserFromJson(Map<String, dynamic> json) {
  return _SearchUser.fromJson(json);
}

/// @nodoc
mixin _$SearchUser {
  String get id => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  int get followerCount => throw _privateConstructorUsedError;
  int get postCount => throw _privateConstructorUsedError;
  int get mutualFriendCount => throw _privateConstructorUsedError;
  bool get selected => throw _privateConstructorUsedError;

  /// Serializes this SearchUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchUserCopyWith<SearchUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchUserCopyWith<$Res> {
  factory $SearchUserCopyWith(
          SearchUser value, $Res Function(SearchUser) then) =
      _$SearchUserCopyWithImpl<$Res, SearchUser>;
  @useResult
  $Res call(
      {String id,
      String displayName,
      String? avatarUrl,
      int followerCount,
      int postCount,
      int mutualFriendCount,
      bool selected});
}

/// @nodoc
class _$SearchUserCopyWithImpl<$Res, $Val extends SearchUser>
    implements $SearchUserCopyWith<$Res> {
  _$SearchUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? avatarUrl = freezed,
    Object? followerCount = null,
    Object? postCount = null,
    Object? mutualFriendCount = null,
    Object? selected = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      followerCount: null == followerCount
          ? _value.followerCount
          : followerCount // ignore: cast_nullable_to_non_nullable
              as int,
      postCount: null == postCount
          ? _value.postCount
          : postCount // ignore: cast_nullable_to_non_nullable
              as int,
      mutualFriendCount: null == mutualFriendCount
          ? _value.mutualFriendCount
          : mutualFriendCount // ignore: cast_nullable_to_non_nullable
              as int,
      selected: null == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchUserImplCopyWith<$Res>
    implements $SearchUserCopyWith<$Res> {
  factory _$$SearchUserImplCopyWith(
          _$SearchUserImpl value, $Res Function(_$SearchUserImpl) then) =
      __$$SearchUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String displayName,
      String? avatarUrl,
      int followerCount,
      int postCount,
      int mutualFriendCount,
      bool selected});
}

/// @nodoc
class __$$SearchUserImplCopyWithImpl<$Res>
    extends _$SearchUserCopyWithImpl<$Res, _$SearchUserImpl>
    implements _$$SearchUserImplCopyWith<$Res> {
  __$$SearchUserImplCopyWithImpl(
      _$SearchUserImpl _value, $Res Function(_$SearchUserImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? avatarUrl = freezed,
    Object? followerCount = null,
    Object? postCount = null,
    Object? mutualFriendCount = null,
    Object? selected = null,
  }) {
    return _then(_$SearchUserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      followerCount: null == followerCount
          ? _value.followerCount
          : followerCount // ignore: cast_nullable_to_non_nullable
              as int,
      postCount: null == postCount
          ? _value.postCount
          : postCount // ignore: cast_nullable_to_non_nullable
              as int,
      mutualFriendCount: null == mutualFriendCount
          ? _value.mutualFriendCount
          : mutualFriendCount // ignore: cast_nullable_to_non_nullable
              as int,
      selected: null == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchUserImpl implements _SearchUser {
  const _$SearchUserImpl(
      {required this.id,
      required this.displayName,
      this.avatarUrl,
      required this.followerCount,
      required this.postCount,
      required this.mutualFriendCount,
      required this.selected});

  factory _$SearchUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchUserImplFromJson(json);

  @override
  final String id;
  @override
  final String displayName;
  @override
  final String? avatarUrl;
  @override
  final int followerCount;
  @override
  final int postCount;
  @override
  final int mutualFriendCount;
  @override
  final bool selected;

  @override
  String toString() {
    return 'SearchUser(id: $id, displayName: $displayName, avatarUrl: $avatarUrl, followerCount: $followerCount, postCount: $postCount, mutualFriendCount: $mutualFriendCount, selected: $selected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.followerCount, followerCount) ||
                other.followerCount == followerCount) &&
            (identical(other.postCount, postCount) ||
                other.postCount == postCount) &&
            (identical(other.mutualFriendCount, mutualFriendCount) ||
                other.mutualFriendCount == mutualFriendCount) &&
            (identical(other.selected, selected) ||
                other.selected == selected));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, displayName, avatarUrl,
      followerCount, postCount, mutualFriendCount, selected);

  /// Create a copy of SearchUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchUserImplCopyWith<_$SearchUserImpl> get copyWith =>
      __$$SearchUserImplCopyWithImpl<_$SearchUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchUserImplToJson(
      this,
    );
  }
}

abstract class _SearchUser implements SearchUser {
  const factory _SearchUser(
      {required final String id,
      required final String displayName,
      final String? avatarUrl,
      required final int followerCount,
      required final int postCount,
      required final int mutualFriendCount,
      required final bool selected}) = _$SearchUserImpl;

  factory _SearchUser.fromJson(Map<String, dynamic> json) =
      _$SearchUserImpl.fromJson;

  @override
  String get id;
  @override
  String get displayName;
  @override
  String? get avatarUrl;
  @override
  int get followerCount;
  @override
  int get postCount;
  @override
  int get mutualFriendCount;
  @override
  bool get selected;

  /// Create a copy of SearchUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchUserImplCopyWith<_$SearchUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FriendSearchResponse _$FriendSearchResponseFromJson(Map<String, dynamic> json) {
  return _FriendSearchResponse.fromJson(json);
}

/// @nodoc
mixin _$FriendSearchResponse {
  List<SearchUser> get users => throw _privateConstructorUsedError;
  String? get nextCursor => throw _privateConstructorUsedError;

  /// Serializes this FriendSearchResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FriendSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendSearchResponseCopyWith<FriendSearchResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendSearchResponseCopyWith<$Res> {
  factory $FriendSearchResponseCopyWith(FriendSearchResponse value,
          $Res Function(FriendSearchResponse) then) =
      _$FriendSearchResponseCopyWithImpl<$Res, FriendSearchResponse>;
  @useResult
  $Res call({List<SearchUser> users, String? nextCursor});
}

/// @nodoc
class _$FriendSearchResponseCopyWithImpl<$Res,
        $Val extends FriendSearchResponse>
    implements $FriendSearchResponseCopyWith<$Res> {
  _$FriendSearchResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_value.copyWith(
      users: null == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<SearchUser>,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FriendSearchResponseImplCopyWith<$Res>
    implements $FriendSearchResponseCopyWith<$Res> {
  factory _$$FriendSearchResponseImplCopyWith(_$FriendSearchResponseImpl value,
          $Res Function(_$FriendSearchResponseImpl) then) =
      __$$FriendSearchResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<SearchUser> users, String? nextCursor});
}

/// @nodoc
class __$$FriendSearchResponseImplCopyWithImpl<$Res>
    extends _$FriendSearchResponseCopyWithImpl<$Res, _$FriendSearchResponseImpl>
    implements _$$FriendSearchResponseImplCopyWith<$Res> {
  __$$FriendSearchResponseImplCopyWithImpl(_$FriendSearchResponseImpl _value,
      $Res Function(_$FriendSearchResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of FriendSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_$FriendSearchResponseImpl(
      users: null == users
          ? _value._users
          : users // ignore: cast_nullable_to_non_nullable
              as List<SearchUser>,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendSearchResponseImpl implements _FriendSearchResponse {
  const _$FriendSearchResponseImpl(
      {final List<SearchUser> users = const <SearchUser>[], this.nextCursor})
      : _users = users;

  factory _$FriendSearchResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendSearchResponseImplFromJson(json);

  final List<SearchUser> _users;
  @override
  @JsonKey()
  List<SearchUser> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  @override
  final String? nextCursor;

  @override
  String toString() {
    return 'FriendSearchResponse(users: $users, nextCursor: $nextCursor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendSearchResponseImpl &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_users), nextCursor);

  /// Create a copy of FriendSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendSearchResponseImplCopyWith<_$FriendSearchResponseImpl>
      get copyWith =>
          __$$FriendSearchResponseImplCopyWithImpl<_$FriendSearchResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendSearchResponseImplToJson(
      this,
    );
  }
}

abstract class _FriendSearchResponse implements FriendSearchResponse {
  const factory _FriendSearchResponse(
      {final List<SearchUser> users,
      final String? nextCursor}) = _$FriendSearchResponseImpl;

  factory _FriendSearchResponse.fromJson(Map<String, dynamic> json) =
      _$FriendSearchResponseImpl.fromJson;

  @override
  List<SearchUser> get users;
  @override
  String? get nextCursor;

  /// Create a copy of FriendSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendSearchResponseImplCopyWith<_$FriendSearchResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

FollowResult _$FollowResultFromJson(Map<String, dynamic> json) {
  return _FollowResult.fromJson(json);
}

/// @nodoc
mixin _$FollowResult {
  String get friendUserId => throw _privateConstructorUsedError;
  bool get selected => throw _privateConstructorUsedError;

  /// Serializes this FollowResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FollowResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FollowResultCopyWith<FollowResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FollowResultCopyWith<$Res> {
  factory $FollowResultCopyWith(
          FollowResult value, $Res Function(FollowResult) then) =
      _$FollowResultCopyWithImpl<$Res, FollowResult>;
  @useResult
  $Res call({String friendUserId, bool selected});
}

/// @nodoc
class _$FollowResultCopyWithImpl<$Res, $Val extends FollowResult>
    implements $FollowResultCopyWith<$Res> {
  _$FollowResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FollowResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? friendUserId = null,
    Object? selected = null,
  }) {
    return _then(_value.copyWith(
      friendUserId: null == friendUserId
          ? _value.friendUserId
          : friendUserId // ignore: cast_nullable_to_non_nullable
              as String,
      selected: null == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FollowResultImplCopyWith<$Res>
    implements $FollowResultCopyWith<$Res> {
  factory _$$FollowResultImplCopyWith(
          _$FollowResultImpl value, $Res Function(_$FollowResultImpl) then) =
      __$$FollowResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String friendUserId, bool selected});
}

/// @nodoc
class __$$FollowResultImplCopyWithImpl<$Res>
    extends _$FollowResultCopyWithImpl<$Res, _$FollowResultImpl>
    implements _$$FollowResultImplCopyWith<$Res> {
  __$$FollowResultImplCopyWithImpl(
      _$FollowResultImpl _value, $Res Function(_$FollowResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of FollowResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? friendUserId = null,
    Object? selected = null,
  }) {
    return _then(_$FollowResultImpl(
      friendUserId: null == friendUserId
          ? _value.friendUserId
          : friendUserId // ignore: cast_nullable_to_non_nullable
              as String,
      selected: null == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FollowResultImpl implements _FollowResult {
  const _$FollowResultImpl(
      {required this.friendUserId, required this.selected});

  factory _$FollowResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$FollowResultImplFromJson(json);

  @override
  final String friendUserId;
  @override
  final bool selected;

  @override
  String toString() {
    return 'FollowResult(friendUserId: $friendUserId, selected: $selected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FollowResultImpl &&
            (identical(other.friendUserId, friendUserId) ||
                other.friendUserId == friendUserId) &&
            (identical(other.selected, selected) ||
                other.selected == selected));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, friendUserId, selected);

  /// Create a copy of FollowResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FollowResultImplCopyWith<_$FollowResultImpl> get copyWith =>
      __$$FollowResultImplCopyWithImpl<_$FollowResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FollowResultImplToJson(
      this,
    );
  }
}

abstract class _FollowResult implements FollowResult {
  const factory _FollowResult(
      {required final String friendUserId,
      required final bool selected}) = _$FollowResultImpl;

  factory _FollowResult.fromJson(Map<String, dynamic> json) =
      _$FollowResultImpl.fromJson;

  @override
  String get friendUserId;
  @override
  bool get selected;

  /// Create a copy of FollowResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FollowResultImplCopyWith<_$FollowResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
