// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GuestSession _$GuestSessionFromJson(Map<String, dynamic> json) {
  return _GuestSession.fromJson(json);
}

/// @nodoc
mixin _$GuestSession {
  String get userId => throw _privateConstructorUsedError;
  String get sessionToken => throw _privateConstructorUsedError;
  bool get isNewUser => throw _privateConstructorUsedError;

  /// Serializes this GuestSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GuestSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GuestSessionCopyWith<GuestSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GuestSessionCopyWith<$Res> {
  factory $GuestSessionCopyWith(
          GuestSession value, $Res Function(GuestSession) then) =
      _$GuestSessionCopyWithImpl<$Res, GuestSession>;
  @useResult
  $Res call({String userId, String sessionToken, bool isNewUser});
}

/// @nodoc
class _$GuestSessionCopyWithImpl<$Res, $Val extends GuestSession>
    implements $GuestSessionCopyWith<$Res> {
  _$GuestSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GuestSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? sessionToken = null,
    Object? isNewUser = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionToken: null == sessionToken
          ? _value.sessionToken
          : sessionToken // ignore: cast_nullable_to_non_nullable
              as String,
      isNewUser: null == isNewUser
          ? _value.isNewUser
          : isNewUser // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GuestSessionImplCopyWith<$Res>
    implements $GuestSessionCopyWith<$Res> {
  factory _$$GuestSessionImplCopyWith(
          _$GuestSessionImpl value, $Res Function(_$GuestSessionImpl) then) =
      __$$GuestSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userId, String sessionToken, bool isNewUser});
}

/// @nodoc
class __$$GuestSessionImplCopyWithImpl<$Res>
    extends _$GuestSessionCopyWithImpl<$Res, _$GuestSessionImpl>
    implements _$$GuestSessionImplCopyWith<$Res> {
  __$$GuestSessionImplCopyWithImpl(
      _$GuestSessionImpl _value, $Res Function(_$GuestSessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of GuestSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? sessionToken = null,
    Object? isNewUser = null,
  }) {
    return _then(_$GuestSessionImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionToken: null == sessionToken
          ? _value.sessionToken
          : sessionToken // ignore: cast_nullable_to_non_nullable
              as String,
      isNewUser: null == isNewUser
          ? _value.isNewUser
          : isNewUser // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GuestSessionImpl implements _GuestSession {
  const _$GuestSessionImpl(
      {required this.userId,
      required this.sessionToken,
      required this.isNewUser});

  factory _$GuestSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$GuestSessionImplFromJson(json);

  @override
  final String userId;
  @override
  final String sessionToken;
  @override
  final bool isNewUser;

  @override
  String toString() {
    return 'GuestSession(userId: $userId, sessionToken: $sessionToken, isNewUser: $isNewUser)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GuestSessionImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.sessionToken, sessionToken) ||
                other.sessionToken == sessionToken) &&
            (identical(other.isNewUser, isNewUser) ||
                other.isNewUser == isNewUser));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, sessionToken, isNewUser);

  /// Create a copy of GuestSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GuestSessionImplCopyWith<_$GuestSessionImpl> get copyWith =>
      __$$GuestSessionImplCopyWithImpl<_$GuestSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GuestSessionImplToJson(
      this,
    );
  }
}

abstract class _GuestSession implements GuestSession {
  const factory _GuestSession(
      {required final String userId,
      required final String sessionToken,
      required final bool isNewUser}) = _$GuestSessionImpl;

  factory _GuestSession.fromJson(Map<String, dynamic> json) =
      _$GuestSessionImpl.fromJson;

  @override
  String get userId;
  @override
  String get sessionToken;
  @override
  bool get isNewUser;

  /// Create a copy of GuestSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GuestSessionImplCopyWith<_$GuestSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
