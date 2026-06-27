// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return _Profile.fromJson(json);
}

/// @nodoc
mixin _$Profile {
  String get displayName => throw _privateConstructorUsedError;
  Gender get gender => throw _privateConstructorUsedError;
  int get birthYear => throw _privateConstructorUsedError;
  double get heightCm => throw _privateConstructorUsedError;
  double get currentWeightKg => throw _privateConstructorUsedError;
  double get targetWeightKg => throw _privateConstructorUsedError;
  String get targetDate => throw _privateConstructorUsedError;

  /// Serializes this Profile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileCopyWith<Profile> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileCopyWith<$Res> {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) then) =
      _$ProfileCopyWithImpl<$Res, Profile>;
  @useResult
  $Res call(
      {String displayName,
      Gender gender,
      int birthYear,
      double heightCm,
      double currentWeightKg,
      double targetWeightKg,
      String targetDate});
}

/// @nodoc
class _$ProfileCopyWithImpl<$Res, $Val extends Profile>
    implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayName = null,
    Object? gender = null,
    Object? birthYear = null,
    Object? heightCm = null,
    Object? currentWeightKg = null,
    Object? targetWeightKg = null,
    Object? targetDate = null,
  }) {
    return _then(_value.copyWith(
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as Gender,
      birthYear: null == birthYear
          ? _value.birthYear
          : birthYear // ignore: cast_nullable_to_non_nullable
              as int,
      heightCm: null == heightCm
          ? _value.heightCm
          : heightCm // ignore: cast_nullable_to_non_nullable
              as double,
      currentWeightKg: null == currentWeightKg
          ? _value.currentWeightKg
          : currentWeightKg // ignore: cast_nullable_to_non_nullable
              as double,
      targetWeightKg: null == targetWeightKg
          ? _value.targetWeightKg
          : targetWeightKg // ignore: cast_nullable_to_non_nullable
              as double,
      targetDate: null == targetDate
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileImplCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$$ProfileImplCopyWith(
          _$ProfileImpl value, $Res Function(_$ProfileImpl) then) =
      __$$ProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String displayName,
      Gender gender,
      int birthYear,
      double heightCm,
      double currentWeightKg,
      double targetWeightKg,
      String targetDate});
}

/// @nodoc
class __$$ProfileImplCopyWithImpl<$Res>
    extends _$ProfileCopyWithImpl<$Res, _$ProfileImpl>
    implements _$$ProfileImplCopyWith<$Res> {
  __$$ProfileImplCopyWithImpl(
      _$ProfileImpl _value, $Res Function(_$ProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayName = null,
    Object? gender = null,
    Object? birthYear = null,
    Object? heightCm = null,
    Object? currentWeightKg = null,
    Object? targetWeightKg = null,
    Object? targetDate = null,
  }) {
    return _then(_$ProfileImpl(
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as Gender,
      birthYear: null == birthYear
          ? _value.birthYear
          : birthYear // ignore: cast_nullable_to_non_nullable
              as int,
      heightCm: null == heightCm
          ? _value.heightCm
          : heightCm // ignore: cast_nullable_to_non_nullable
              as double,
      currentWeightKg: null == currentWeightKg
          ? _value.currentWeightKg
          : currentWeightKg // ignore: cast_nullable_to_non_nullable
              as double,
      targetWeightKg: null == targetWeightKg
          ? _value.targetWeightKg
          : targetWeightKg // ignore: cast_nullable_to_non_nullable
              as double,
      targetDate: null == targetDate
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileImpl implements _Profile {
  const _$ProfileImpl(
      {required this.displayName,
      required this.gender,
      required this.birthYear,
      required this.heightCm,
      required this.currentWeightKg,
      required this.targetWeightKg,
      required this.targetDate});

  factory _$ProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileImplFromJson(json);

  @override
  final String displayName;
  @override
  final Gender gender;
  @override
  final int birthYear;
  @override
  final double heightCm;
  @override
  final double currentWeightKg;
  @override
  final double targetWeightKg;
  @override
  final String targetDate;

  @override
  String toString() {
    return 'Profile(displayName: $displayName, gender: $gender, birthYear: $birthYear, heightCm: $heightCm, currentWeightKg: $currentWeightKg, targetWeightKg: $targetWeightKg, targetDate: $targetDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileImpl &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.birthYear, birthYear) ||
                other.birthYear == birthYear) &&
            (identical(other.heightCm, heightCm) ||
                other.heightCm == heightCm) &&
            (identical(other.currentWeightKg, currentWeightKg) ||
                other.currentWeightKg == currentWeightKg) &&
            (identical(other.targetWeightKg, targetWeightKg) ||
                other.targetWeightKg == targetWeightKg) &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, displayName, gender, birthYear,
      heightCm, currentWeightKg, targetWeightKg, targetDate);

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileImplCopyWith<_$ProfileImpl> get copyWith =>
      __$$ProfileImplCopyWithImpl<_$ProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileImplToJson(
      this,
    );
  }
}

abstract class _Profile implements Profile {
  const factory _Profile(
      {required final String displayName,
      required final Gender gender,
      required final int birthYear,
      required final double heightCm,
      required final double currentWeightKg,
      required final double targetWeightKg,
      required final String targetDate}) = _$ProfileImpl;

  factory _Profile.fromJson(Map<String, dynamic> json) = _$ProfileImpl.fromJson;

  @override
  String get displayName;
  @override
  Gender get gender;
  @override
  int get birthYear;
  @override
  double get heightCm;
  @override
  double get currentWeightKg;
  @override
  double get targetWeightKg;
  @override
  String get targetDate;

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileImplCopyWith<_$ProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProfileResponse _$ProfileResponseFromJson(Map<String, dynamic> json) {
  return _ProfileResponse.fromJson(json);
}

/// @nodoc
mixin _$ProfileResponse {
  Profile? get profile => throw _privateConstructorUsedError;
  int get dailyCalorieTarget => throw _privateConstructorUsedError;
  double get weeklyWeightDelta => throw _privateConstructorUsedError;

  /// Serializes this ProfileResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileResponseCopyWith<ProfileResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileResponseCopyWith<$Res> {
  factory $ProfileResponseCopyWith(
          ProfileResponse value, $Res Function(ProfileResponse) then) =
      _$ProfileResponseCopyWithImpl<$Res, ProfileResponse>;
  @useResult
  $Res call(
      {Profile? profile, int dailyCalorieTarget, double weeklyWeightDelta});

  $ProfileCopyWith<$Res>? get profile;
}

/// @nodoc
class _$ProfileResponseCopyWithImpl<$Res, $Val extends ProfileResponse>
    implements $ProfileResponseCopyWith<$Res> {
  _$ProfileResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profile = freezed,
    Object? dailyCalorieTarget = null,
    Object? weeklyWeightDelta = null,
  }) {
    return _then(_value.copyWith(
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile?,
      dailyCalorieTarget: null == dailyCalorieTarget
          ? _value.dailyCalorieTarget
          : dailyCalorieTarget // ignore: cast_nullable_to_non_nullable
              as int,
      weeklyWeightDelta: null == weeklyWeightDelta
          ? _value.weeklyWeightDelta
          : weeklyWeightDelta // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  /// Create a copy of ProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfileCopyWith<$Res>? get profile {
    if (_value.profile == null) {
      return null;
    }

    return $ProfileCopyWith<$Res>(_value.profile!, (value) {
      return _then(_value.copyWith(profile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProfileResponseImplCopyWith<$Res>
    implements $ProfileResponseCopyWith<$Res> {
  factory _$$ProfileResponseImplCopyWith(_$ProfileResponseImpl value,
          $Res Function(_$ProfileResponseImpl) then) =
      __$$ProfileResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Profile? profile, int dailyCalorieTarget, double weeklyWeightDelta});

  @override
  $ProfileCopyWith<$Res>? get profile;
}

/// @nodoc
class __$$ProfileResponseImplCopyWithImpl<$Res>
    extends _$ProfileResponseCopyWithImpl<$Res, _$ProfileResponseImpl>
    implements _$$ProfileResponseImplCopyWith<$Res> {
  __$$ProfileResponseImplCopyWithImpl(
      _$ProfileResponseImpl _value, $Res Function(_$ProfileResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profile = freezed,
    Object? dailyCalorieTarget = null,
    Object? weeklyWeightDelta = null,
  }) {
    return _then(_$ProfileResponseImpl(
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile?,
      dailyCalorieTarget: null == dailyCalorieTarget
          ? _value.dailyCalorieTarget
          : dailyCalorieTarget // ignore: cast_nullable_to_non_nullable
              as int,
      weeklyWeightDelta: null == weeklyWeightDelta
          ? _value.weeklyWeightDelta
          : weeklyWeightDelta // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileResponseImpl implements _ProfileResponse {
  const _$ProfileResponseImpl(
      {this.profile,
      required this.dailyCalorieTarget,
      required this.weeklyWeightDelta});

  factory _$ProfileResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileResponseImplFromJson(json);

  @override
  final Profile? profile;
  @override
  final int dailyCalorieTarget;
  @override
  final double weeklyWeightDelta;

  @override
  String toString() {
    return 'ProfileResponse(profile: $profile, dailyCalorieTarget: $dailyCalorieTarget, weeklyWeightDelta: $weeklyWeightDelta)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileResponseImpl &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.dailyCalorieTarget, dailyCalorieTarget) ||
                other.dailyCalorieTarget == dailyCalorieTarget) &&
            (identical(other.weeklyWeightDelta, weeklyWeightDelta) ||
                other.weeklyWeightDelta == weeklyWeightDelta));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, profile, dailyCalorieTarget, weeklyWeightDelta);

  /// Create a copy of ProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileResponseImplCopyWith<_$ProfileResponseImpl> get copyWith =>
      __$$ProfileResponseImplCopyWithImpl<_$ProfileResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileResponseImplToJson(
      this,
    );
  }
}

abstract class _ProfileResponse implements ProfileResponse {
  const factory _ProfileResponse(
      {final Profile? profile,
      required final int dailyCalorieTarget,
      required final double weeklyWeightDelta}) = _$ProfileResponseImpl;

  factory _ProfileResponse.fromJson(Map<String, dynamic> json) =
      _$ProfileResponseImpl.fromJson;

  @override
  Profile? get profile;
  @override
  int get dailyCalorieTarget;
  @override
  double get weeklyWeightDelta;

  /// Create a copy of ProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileResponseImplCopyWith<_$ProfileResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProfileUpsertRequest _$ProfileUpsertRequestFromJson(Map<String, dynamic> json) {
  return _ProfileUpsertRequest.fromJson(json);
}

/// @nodoc
mixin _$ProfileUpsertRequest {
  String get displayName => throw _privateConstructorUsedError;
  Gender get gender => throw _privateConstructorUsedError;
  int get birthYear => throw _privateConstructorUsedError;
  double get heightCm => throw _privateConstructorUsedError;
  double get currentWeightKg => throw _privateConstructorUsedError;
  double get targetWeightKg => throw _privateConstructorUsedError;
  String get targetDate => throw _privateConstructorUsedError;

  /// Serializes this ProfileUpsertRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProfileUpsertRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileUpsertRequestCopyWith<ProfileUpsertRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileUpsertRequestCopyWith<$Res> {
  factory $ProfileUpsertRequestCopyWith(ProfileUpsertRequest value,
          $Res Function(ProfileUpsertRequest) then) =
      _$ProfileUpsertRequestCopyWithImpl<$Res, ProfileUpsertRequest>;
  @useResult
  $Res call(
      {String displayName,
      Gender gender,
      int birthYear,
      double heightCm,
      double currentWeightKg,
      double targetWeightKg,
      String targetDate});
}

/// @nodoc
class _$ProfileUpsertRequestCopyWithImpl<$Res,
        $Val extends ProfileUpsertRequest>
    implements $ProfileUpsertRequestCopyWith<$Res> {
  _$ProfileUpsertRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileUpsertRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayName = null,
    Object? gender = null,
    Object? birthYear = null,
    Object? heightCm = null,
    Object? currentWeightKg = null,
    Object? targetWeightKg = null,
    Object? targetDate = null,
  }) {
    return _then(_value.copyWith(
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as Gender,
      birthYear: null == birthYear
          ? _value.birthYear
          : birthYear // ignore: cast_nullable_to_non_nullable
              as int,
      heightCm: null == heightCm
          ? _value.heightCm
          : heightCm // ignore: cast_nullable_to_non_nullable
              as double,
      currentWeightKg: null == currentWeightKg
          ? _value.currentWeightKg
          : currentWeightKg // ignore: cast_nullable_to_non_nullable
              as double,
      targetWeightKg: null == targetWeightKg
          ? _value.targetWeightKg
          : targetWeightKg // ignore: cast_nullable_to_non_nullable
              as double,
      targetDate: null == targetDate
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileUpsertRequestImplCopyWith<$Res>
    implements $ProfileUpsertRequestCopyWith<$Res> {
  factory _$$ProfileUpsertRequestImplCopyWith(_$ProfileUpsertRequestImpl value,
          $Res Function(_$ProfileUpsertRequestImpl) then) =
      __$$ProfileUpsertRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String displayName,
      Gender gender,
      int birthYear,
      double heightCm,
      double currentWeightKg,
      double targetWeightKg,
      String targetDate});
}

/// @nodoc
class __$$ProfileUpsertRequestImplCopyWithImpl<$Res>
    extends _$ProfileUpsertRequestCopyWithImpl<$Res, _$ProfileUpsertRequestImpl>
    implements _$$ProfileUpsertRequestImplCopyWith<$Res> {
  __$$ProfileUpsertRequestImplCopyWithImpl(_$ProfileUpsertRequestImpl _value,
      $Res Function(_$ProfileUpsertRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileUpsertRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayName = null,
    Object? gender = null,
    Object? birthYear = null,
    Object? heightCm = null,
    Object? currentWeightKg = null,
    Object? targetWeightKg = null,
    Object? targetDate = null,
  }) {
    return _then(_$ProfileUpsertRequestImpl(
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as Gender,
      birthYear: null == birthYear
          ? _value.birthYear
          : birthYear // ignore: cast_nullable_to_non_nullable
              as int,
      heightCm: null == heightCm
          ? _value.heightCm
          : heightCm // ignore: cast_nullable_to_non_nullable
              as double,
      currentWeightKg: null == currentWeightKg
          ? _value.currentWeightKg
          : currentWeightKg // ignore: cast_nullable_to_non_nullable
              as double,
      targetWeightKg: null == targetWeightKg
          ? _value.targetWeightKg
          : targetWeightKg // ignore: cast_nullable_to_non_nullable
              as double,
      targetDate: null == targetDate
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileUpsertRequestImpl implements _ProfileUpsertRequest {
  const _$ProfileUpsertRequestImpl(
      {required this.displayName,
      required this.gender,
      required this.birthYear,
      required this.heightCm,
      required this.currentWeightKg,
      required this.targetWeightKg,
      required this.targetDate});

  factory _$ProfileUpsertRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileUpsertRequestImplFromJson(json);

  @override
  final String displayName;
  @override
  final Gender gender;
  @override
  final int birthYear;
  @override
  final double heightCm;
  @override
  final double currentWeightKg;
  @override
  final double targetWeightKg;
  @override
  final String targetDate;

  @override
  String toString() {
    return 'ProfileUpsertRequest(displayName: $displayName, gender: $gender, birthYear: $birthYear, heightCm: $heightCm, currentWeightKg: $currentWeightKg, targetWeightKg: $targetWeightKg, targetDate: $targetDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileUpsertRequestImpl &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.birthYear, birthYear) ||
                other.birthYear == birthYear) &&
            (identical(other.heightCm, heightCm) ||
                other.heightCm == heightCm) &&
            (identical(other.currentWeightKg, currentWeightKg) ||
                other.currentWeightKg == currentWeightKg) &&
            (identical(other.targetWeightKg, targetWeightKg) ||
                other.targetWeightKg == targetWeightKg) &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, displayName, gender, birthYear,
      heightCm, currentWeightKg, targetWeightKg, targetDate);

  /// Create a copy of ProfileUpsertRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileUpsertRequestImplCopyWith<_$ProfileUpsertRequestImpl>
      get copyWith =>
          __$$ProfileUpsertRequestImplCopyWithImpl<_$ProfileUpsertRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileUpsertRequestImplToJson(
      this,
    );
  }
}

abstract class _ProfileUpsertRequest implements ProfileUpsertRequest {
  const factory _ProfileUpsertRequest(
      {required final String displayName,
      required final Gender gender,
      required final int birthYear,
      required final double heightCm,
      required final double currentWeightKg,
      required final double targetWeightKg,
      required final String targetDate}) = _$ProfileUpsertRequestImpl;

  factory _ProfileUpsertRequest.fromJson(Map<String, dynamic> json) =
      _$ProfileUpsertRequestImpl.fromJson;

  @override
  String get displayName;
  @override
  Gender get gender;
  @override
  int get birthYear;
  @override
  double get heightCm;
  @override
  double get currentWeightKg;
  @override
  double get targetWeightKg;
  @override
  String get targetDate;

  /// Create a copy of ProfileUpsertRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileUpsertRequestImplCopyWith<_$ProfileUpsertRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
