// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'common.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Macros _$MacrosFromJson(Map<String, dynamic> json) {
  return _Macros.fromJson(json);
}

/// @nodoc
mixin _$Macros {
  double get proteinG => throw _privateConstructorUsedError;
  double get carbsG => throw _privateConstructorUsedError;
  double get fatG => throw _privateConstructorUsedError;

  /// Serializes this Macros to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Macros
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MacrosCopyWith<Macros> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MacrosCopyWith<$Res> {
  factory $MacrosCopyWith(Macros value, $Res Function(Macros) then) =
      _$MacrosCopyWithImpl<$Res, Macros>;
  @useResult
  $Res call({double proteinG, double carbsG, double fatG});
}

/// @nodoc
class _$MacrosCopyWithImpl<$Res, $Val extends Macros>
    implements $MacrosCopyWith<$Res> {
  _$MacrosCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Macros
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? proteinG = null,
    Object? carbsG = null,
    Object? fatG = null,
  }) {
    return _then(_value.copyWith(
      proteinG: null == proteinG
          ? _value.proteinG
          : proteinG // ignore: cast_nullable_to_non_nullable
              as double,
      carbsG: null == carbsG
          ? _value.carbsG
          : carbsG // ignore: cast_nullable_to_non_nullable
              as double,
      fatG: null == fatG
          ? _value.fatG
          : fatG // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MacrosImplCopyWith<$Res> implements $MacrosCopyWith<$Res> {
  factory _$$MacrosImplCopyWith(
          _$MacrosImpl value, $Res Function(_$MacrosImpl) then) =
      __$$MacrosImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double proteinG, double carbsG, double fatG});
}

/// @nodoc
class __$$MacrosImplCopyWithImpl<$Res>
    extends _$MacrosCopyWithImpl<$Res, _$MacrosImpl>
    implements _$$MacrosImplCopyWith<$Res> {
  __$$MacrosImplCopyWithImpl(
      _$MacrosImpl _value, $Res Function(_$MacrosImpl) _then)
      : super(_value, _then);

  /// Create a copy of Macros
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? proteinG = null,
    Object? carbsG = null,
    Object? fatG = null,
  }) {
    return _then(_$MacrosImpl(
      proteinG: null == proteinG
          ? _value.proteinG
          : proteinG // ignore: cast_nullable_to_non_nullable
              as double,
      carbsG: null == carbsG
          ? _value.carbsG
          : carbsG // ignore: cast_nullable_to_non_nullable
              as double,
      fatG: null == fatG
          ? _value.fatG
          : fatG // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MacrosImpl implements _Macros {
  const _$MacrosImpl(
      {required this.proteinG, required this.carbsG, required this.fatG});

  factory _$MacrosImpl.fromJson(Map<String, dynamic> json) =>
      _$$MacrosImplFromJson(json);

  @override
  final double proteinG;
  @override
  final double carbsG;
  @override
  final double fatG;

  @override
  String toString() {
    return 'Macros(proteinG: $proteinG, carbsG: $carbsG, fatG: $fatG)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MacrosImpl &&
            (identical(other.proteinG, proteinG) ||
                other.proteinG == proteinG) &&
            (identical(other.carbsG, carbsG) || other.carbsG == carbsG) &&
            (identical(other.fatG, fatG) || other.fatG == fatG));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, proteinG, carbsG, fatG);

  /// Create a copy of Macros
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MacrosImplCopyWith<_$MacrosImpl> get copyWith =>
      __$$MacrosImplCopyWithImpl<_$MacrosImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MacrosImplToJson(
      this,
    );
  }
}

abstract class _Macros implements Macros {
  const factory _Macros(
      {required final double proteinG,
      required final double carbsG,
      required final double fatG}) = _$MacrosImpl;

  factory _Macros.fromJson(Map<String, dynamic> json) = _$MacrosImpl.fromJson;

  @override
  double get proteinG;
  @override
  double get carbsG;
  @override
  double get fatG;

  /// Create a copy of Macros
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MacrosImplCopyWith<_$MacrosImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserRef _$UserRefFromJson(Map<String, dynamic> json) {
  return _UserRef.fromJson(json);
}

/// @nodoc
mixin _$UserRef {
  String get id => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;

  /// Serializes this UserRef to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserRef
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserRefCopyWith<UserRef> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserRefCopyWith<$Res> {
  factory $UserRefCopyWith(UserRef value, $Res Function(UserRef) then) =
      _$UserRefCopyWithImpl<$Res, UserRef>;
  @useResult
  $Res call({String id, String displayName, String? avatarUrl});
}

/// @nodoc
class _$UserRefCopyWithImpl<$Res, $Val extends UserRef>
    implements $UserRefCopyWith<$Res> {
  _$UserRefCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserRef
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? avatarUrl = freezed,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserRefImplCopyWith<$Res> implements $UserRefCopyWith<$Res> {
  factory _$$UserRefImplCopyWith(
          _$UserRefImpl value, $Res Function(_$UserRefImpl) then) =
      __$$UserRefImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String displayName, String? avatarUrl});
}

/// @nodoc
class __$$UserRefImplCopyWithImpl<$Res>
    extends _$UserRefCopyWithImpl<$Res, _$UserRefImpl>
    implements _$$UserRefImplCopyWith<$Res> {
  __$$UserRefImplCopyWithImpl(
      _$UserRefImpl _value, $Res Function(_$UserRefImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserRef
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? avatarUrl = freezed,
  }) {
    return _then(_$UserRefImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserRefImpl implements _UserRef {
  const _$UserRefImpl(
      {required this.id, required this.displayName, this.avatarUrl});

  factory _$UserRefImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserRefImplFromJson(json);

  @override
  final String id;
  @override
  final String displayName;
  @override
  final String? avatarUrl;

  @override
  String toString() {
    return 'UserRef(id: $id, displayName: $displayName, avatarUrl: $avatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserRefImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, displayName, avatarUrl);

  /// Create a copy of UserRef
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserRefImplCopyWith<_$UserRefImpl> get copyWith =>
      __$$UserRefImplCopyWithImpl<_$UserRefImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserRefImplToJson(
      this,
    );
  }
}

abstract class _UserRef implements UserRef {
  const factory _UserRef(
      {required final String id,
      required final String displayName,
      final String? avatarUrl}) = _$UserRefImpl;

  factory _UserRef.fromJson(Map<String, dynamic> json) = _$UserRefImpl.fromJson;

  @override
  String get id;
  @override
  String get displayName;
  @override
  String? get avatarUrl;

  /// Create a copy of UserRef
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserRefImplCopyWith<_$UserRefImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
