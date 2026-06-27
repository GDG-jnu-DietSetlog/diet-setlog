// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DailySummary _$DailySummaryFromJson(Map<String, dynamic> json) {
  return _DailySummary.fromJson(json);
}

/// @nodoc
mixin _$DailySummary {
  String get date => throw _privateConstructorUsedError;
  int get calorieTarget => throw _privateConstructorUsedError;
  int get totalCalories => throw _privateConstructorUsedError;
  Macros get macros => throw _privateConstructorUsedError;
  int get remainingCalories => throw _privateConstructorUsedError;
  double get progressRatio => throw _privateConstructorUsedError;

  /// Serializes this DailySummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailySummaryCopyWith<DailySummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailySummaryCopyWith<$Res> {
  factory $DailySummaryCopyWith(
          DailySummary value, $Res Function(DailySummary) then) =
      _$DailySummaryCopyWithImpl<$Res, DailySummary>;
  @useResult
  $Res call(
      {String date,
      int calorieTarget,
      int totalCalories,
      Macros macros,
      int remainingCalories,
      double progressRatio});

  $MacrosCopyWith<$Res> get macros;
}

/// @nodoc
class _$DailySummaryCopyWithImpl<$Res, $Val extends DailySummary>
    implements $DailySummaryCopyWith<$Res> {
  _$DailySummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? calorieTarget = null,
    Object? totalCalories = null,
    Object? macros = null,
    Object? remainingCalories = null,
    Object? progressRatio = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      calorieTarget: null == calorieTarget
          ? _value.calorieTarget
          : calorieTarget // ignore: cast_nullable_to_non_nullable
              as int,
      totalCalories: null == totalCalories
          ? _value.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as int,
      macros: null == macros
          ? _value.macros
          : macros // ignore: cast_nullable_to_non_nullable
              as Macros,
      remainingCalories: null == remainingCalories
          ? _value.remainingCalories
          : remainingCalories // ignore: cast_nullable_to_non_nullable
              as int,
      progressRatio: null == progressRatio
          ? _value.progressRatio
          : progressRatio // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  /// Create a copy of DailySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MacrosCopyWith<$Res> get macros {
    return $MacrosCopyWith<$Res>(_value.macros, (value) {
      return _then(_value.copyWith(macros: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DailySummaryImplCopyWith<$Res>
    implements $DailySummaryCopyWith<$Res> {
  factory _$$DailySummaryImplCopyWith(
          _$DailySummaryImpl value, $Res Function(_$DailySummaryImpl) then) =
      __$$DailySummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String date,
      int calorieTarget,
      int totalCalories,
      Macros macros,
      int remainingCalories,
      double progressRatio});

  @override
  $MacrosCopyWith<$Res> get macros;
}

/// @nodoc
class __$$DailySummaryImplCopyWithImpl<$Res>
    extends _$DailySummaryCopyWithImpl<$Res, _$DailySummaryImpl>
    implements _$$DailySummaryImplCopyWith<$Res> {
  __$$DailySummaryImplCopyWithImpl(
      _$DailySummaryImpl _value, $Res Function(_$DailySummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? calorieTarget = null,
    Object? totalCalories = null,
    Object? macros = null,
    Object? remainingCalories = null,
    Object? progressRatio = null,
  }) {
    return _then(_$DailySummaryImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      calorieTarget: null == calorieTarget
          ? _value.calorieTarget
          : calorieTarget // ignore: cast_nullable_to_non_nullable
              as int,
      totalCalories: null == totalCalories
          ? _value.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as int,
      macros: null == macros
          ? _value.macros
          : macros // ignore: cast_nullable_to_non_nullable
              as Macros,
      remainingCalories: null == remainingCalories
          ? _value.remainingCalories
          : remainingCalories // ignore: cast_nullable_to_non_nullable
              as int,
      progressRatio: null == progressRatio
          ? _value.progressRatio
          : progressRatio // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailySummaryImpl implements _DailySummary {
  const _$DailySummaryImpl(
      {required this.date,
      required this.calorieTarget,
      required this.totalCalories,
      required this.macros,
      required this.remainingCalories,
      this.progressRatio = 0});

  factory _$DailySummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailySummaryImplFromJson(json);

  @override
  final String date;
  @override
  final int calorieTarget;
  @override
  final int totalCalories;
  @override
  final Macros macros;
  @override
  final int remainingCalories;
  @override
  @JsonKey()
  final double progressRatio;

  @override
  String toString() {
    return 'DailySummary(date: $date, calorieTarget: $calorieTarget, totalCalories: $totalCalories, macros: $macros, remainingCalories: $remainingCalories, progressRatio: $progressRatio)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailySummaryImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.calorieTarget, calorieTarget) ||
                other.calorieTarget == calorieTarget) &&
            (identical(other.totalCalories, totalCalories) ||
                other.totalCalories == totalCalories) &&
            (identical(other.macros, macros) || other.macros == macros) &&
            (identical(other.remainingCalories, remainingCalories) ||
                other.remainingCalories == remainingCalories) &&
            (identical(other.progressRatio, progressRatio) ||
                other.progressRatio == progressRatio));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, calorieTarget,
      totalCalories, macros, remainingCalories, progressRatio);

  /// Create a copy of DailySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailySummaryImplCopyWith<_$DailySummaryImpl> get copyWith =>
      __$$DailySummaryImplCopyWithImpl<_$DailySummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailySummaryImplToJson(
      this,
    );
  }
}

abstract class _DailySummary implements DailySummary {
  const factory _DailySummary(
      {required final String date,
      required final int calorieTarget,
      required final int totalCalories,
      required final Macros macros,
      required final int remainingCalories,
      final double progressRatio}) = _$DailySummaryImpl;

  factory _DailySummary.fromJson(Map<String, dynamic> json) =
      _$DailySummaryImpl.fromJson;

  @override
  String get date;
  @override
  int get calorieTarget;
  @override
  int get totalCalories;
  @override
  Macros get macros;
  @override
  int get remainingCalories;
  @override
  double get progressRatio;

  /// Create a copy of DailySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailySummaryImplCopyWith<_$DailySummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CertifiedFriend _$CertifiedFriendFromJson(Map<String, dynamic> json) {
  return _CertifiedFriend.fromJson(json);
}

/// @nodoc
mixin _$CertifiedFriend {
  String get id => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  DateTime get certifiedAt => throw _privateConstructorUsedError;

  /// Serializes this CertifiedFriend to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CertifiedFriend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CertifiedFriendCopyWith<CertifiedFriend> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CertifiedFriendCopyWith<$Res> {
  factory $CertifiedFriendCopyWith(
          CertifiedFriend value, $Res Function(CertifiedFriend) then) =
      _$CertifiedFriendCopyWithImpl<$Res, CertifiedFriend>;
  @useResult
  $Res call(
      {String id, String displayName, String? avatarUrl, DateTime certifiedAt});
}

/// @nodoc
class _$CertifiedFriendCopyWithImpl<$Res, $Val extends CertifiedFriend>
    implements $CertifiedFriendCopyWith<$Res> {
  _$CertifiedFriendCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CertifiedFriend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? avatarUrl = freezed,
    Object? certifiedAt = null,
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
      certifiedAt: null == certifiedAt
          ? _value.certifiedAt
          : certifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CertifiedFriendImplCopyWith<$Res>
    implements $CertifiedFriendCopyWith<$Res> {
  factory _$$CertifiedFriendImplCopyWith(_$CertifiedFriendImpl value,
          $Res Function(_$CertifiedFriendImpl) then) =
      __$$CertifiedFriendImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String displayName, String? avatarUrl, DateTime certifiedAt});
}

/// @nodoc
class __$$CertifiedFriendImplCopyWithImpl<$Res>
    extends _$CertifiedFriendCopyWithImpl<$Res, _$CertifiedFriendImpl>
    implements _$$CertifiedFriendImplCopyWith<$Res> {
  __$$CertifiedFriendImplCopyWithImpl(
      _$CertifiedFriendImpl _value, $Res Function(_$CertifiedFriendImpl) _then)
      : super(_value, _then);

  /// Create a copy of CertifiedFriend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? avatarUrl = freezed,
    Object? certifiedAt = null,
  }) {
    return _then(_$CertifiedFriendImpl(
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
      certifiedAt: null == certifiedAt
          ? _value.certifiedAt
          : certifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CertifiedFriendImpl implements _CertifiedFriend {
  const _$CertifiedFriendImpl(
      {required this.id,
      required this.displayName,
      this.avatarUrl,
      required this.certifiedAt});

  factory _$CertifiedFriendImpl.fromJson(Map<String, dynamic> json) =>
      _$$CertifiedFriendImplFromJson(json);

  @override
  final String id;
  @override
  final String displayName;
  @override
  final String? avatarUrl;
  @override
  final DateTime certifiedAt;

  @override
  String toString() {
    return 'CertifiedFriend(id: $id, displayName: $displayName, avatarUrl: $avatarUrl, certifiedAt: $certifiedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CertifiedFriendImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.certifiedAt, certifiedAt) ||
                other.certifiedAt == certifiedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, displayName, avatarUrl, certifiedAt);

  /// Create a copy of CertifiedFriend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CertifiedFriendImplCopyWith<_$CertifiedFriendImpl> get copyWith =>
      __$$CertifiedFriendImplCopyWithImpl<_$CertifiedFriendImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CertifiedFriendImplToJson(
      this,
    );
  }
}

abstract class _CertifiedFriend implements CertifiedFriend {
  const factory _CertifiedFriend(
      {required final String id,
      required final String displayName,
      final String? avatarUrl,
      required final DateTime certifiedAt}) = _$CertifiedFriendImpl;

  factory _CertifiedFriend.fromJson(Map<String, dynamic> json) =
      _$CertifiedFriendImpl.fromJson;

  @override
  String get id;
  @override
  String get displayName;
  @override
  String? get avatarUrl;
  @override
  DateTime get certifiedAt;

  /// Create a copy of CertifiedFriend
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CertifiedFriendImplCopyWith<_$CertifiedFriendImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HomeResponse _$HomeResponseFromJson(Map<String, dynamic> json) {
  return _HomeResponse.fromJson(json);
}

/// @nodoc
mixin _$HomeResponse {
  UserRef get currentUser => throw _privateConstructorUsedError;
  DailySummary get todaySummary => throw _privateConstructorUsedError;
  List<CertifiedFriend> get friendsCertifiedToday =>
      throw _privateConstructorUsedError;
  List<FoodRecordCard> get recentRecords => throw _privateConstructorUsedError;

  /// Serializes this HomeResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HomeResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeResponseCopyWith<HomeResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeResponseCopyWith<$Res> {
  factory $HomeResponseCopyWith(
          HomeResponse value, $Res Function(HomeResponse) then) =
      _$HomeResponseCopyWithImpl<$Res, HomeResponse>;
  @useResult
  $Res call(
      {UserRef currentUser,
      DailySummary todaySummary,
      List<CertifiedFriend> friendsCertifiedToday,
      List<FoodRecordCard> recentRecords});

  $UserRefCopyWith<$Res> get currentUser;
  $DailySummaryCopyWith<$Res> get todaySummary;
}

/// @nodoc
class _$HomeResponseCopyWithImpl<$Res, $Val extends HomeResponse>
    implements $HomeResponseCopyWith<$Res> {
  _$HomeResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentUser = null,
    Object? todaySummary = null,
    Object? friendsCertifiedToday = null,
    Object? recentRecords = null,
  }) {
    return _then(_value.copyWith(
      currentUser: null == currentUser
          ? _value.currentUser
          : currentUser // ignore: cast_nullable_to_non_nullable
              as UserRef,
      todaySummary: null == todaySummary
          ? _value.todaySummary
          : todaySummary // ignore: cast_nullable_to_non_nullable
              as DailySummary,
      friendsCertifiedToday: null == friendsCertifiedToday
          ? _value.friendsCertifiedToday
          : friendsCertifiedToday // ignore: cast_nullable_to_non_nullable
              as List<CertifiedFriend>,
      recentRecords: null == recentRecords
          ? _value.recentRecords
          : recentRecords // ignore: cast_nullable_to_non_nullable
              as List<FoodRecordCard>,
    ) as $Val);
  }

  /// Create a copy of HomeResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserRefCopyWith<$Res> get currentUser {
    return $UserRefCopyWith<$Res>(_value.currentUser, (value) {
      return _then(_value.copyWith(currentUser: value) as $Val);
    });
  }

  /// Create a copy of HomeResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DailySummaryCopyWith<$Res> get todaySummary {
    return $DailySummaryCopyWith<$Res>(_value.todaySummary, (value) {
      return _then(_value.copyWith(todaySummary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HomeResponseImplCopyWith<$Res>
    implements $HomeResponseCopyWith<$Res> {
  factory _$$HomeResponseImplCopyWith(
          _$HomeResponseImpl value, $Res Function(_$HomeResponseImpl) then) =
      __$$HomeResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {UserRef currentUser,
      DailySummary todaySummary,
      List<CertifiedFriend> friendsCertifiedToday,
      List<FoodRecordCard> recentRecords});

  @override
  $UserRefCopyWith<$Res> get currentUser;
  @override
  $DailySummaryCopyWith<$Res> get todaySummary;
}

/// @nodoc
class __$$HomeResponseImplCopyWithImpl<$Res>
    extends _$HomeResponseCopyWithImpl<$Res, _$HomeResponseImpl>
    implements _$$HomeResponseImplCopyWith<$Res> {
  __$$HomeResponseImplCopyWithImpl(
      _$HomeResponseImpl _value, $Res Function(_$HomeResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of HomeResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentUser = null,
    Object? todaySummary = null,
    Object? friendsCertifiedToday = null,
    Object? recentRecords = null,
  }) {
    return _then(_$HomeResponseImpl(
      currentUser: null == currentUser
          ? _value.currentUser
          : currentUser // ignore: cast_nullable_to_non_nullable
              as UserRef,
      todaySummary: null == todaySummary
          ? _value.todaySummary
          : todaySummary // ignore: cast_nullable_to_non_nullable
              as DailySummary,
      friendsCertifiedToday: null == friendsCertifiedToday
          ? _value._friendsCertifiedToday
          : friendsCertifiedToday // ignore: cast_nullable_to_non_nullable
              as List<CertifiedFriend>,
      recentRecords: null == recentRecords
          ? _value._recentRecords
          : recentRecords // ignore: cast_nullable_to_non_nullable
              as List<FoodRecordCard>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HomeResponseImpl implements _HomeResponse {
  const _$HomeResponseImpl(
      {required this.currentUser,
      required this.todaySummary,
      final List<CertifiedFriend> friendsCertifiedToday =
          const <CertifiedFriend>[],
      final List<FoodRecordCard> recentRecords = const <FoodRecordCard>[]})
      : _friendsCertifiedToday = friendsCertifiedToday,
        _recentRecords = recentRecords;

  factory _$HomeResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$HomeResponseImplFromJson(json);

  @override
  final UserRef currentUser;
  @override
  final DailySummary todaySummary;
  final List<CertifiedFriend> _friendsCertifiedToday;
  @override
  @JsonKey()
  List<CertifiedFriend> get friendsCertifiedToday {
    if (_friendsCertifiedToday is EqualUnmodifiableListView)
      return _friendsCertifiedToday;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_friendsCertifiedToday);
  }

  final List<FoodRecordCard> _recentRecords;
  @override
  @JsonKey()
  List<FoodRecordCard> get recentRecords {
    if (_recentRecords is EqualUnmodifiableListView) return _recentRecords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentRecords);
  }

  @override
  String toString() {
    return 'HomeResponse(currentUser: $currentUser, todaySummary: $todaySummary, friendsCertifiedToday: $friendsCertifiedToday, recentRecords: $recentRecords)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeResponseImpl &&
            (identical(other.currentUser, currentUser) ||
                other.currentUser == currentUser) &&
            (identical(other.todaySummary, todaySummary) ||
                other.todaySummary == todaySummary) &&
            const DeepCollectionEquality()
                .equals(other._friendsCertifiedToday, _friendsCertifiedToday) &&
            const DeepCollectionEquality()
                .equals(other._recentRecords, _recentRecords));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentUser,
      todaySummary,
      const DeepCollectionEquality().hash(_friendsCertifiedToday),
      const DeepCollectionEquality().hash(_recentRecords));

  /// Create a copy of HomeResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeResponseImplCopyWith<_$HomeResponseImpl> get copyWith =>
      __$$HomeResponseImplCopyWithImpl<_$HomeResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HomeResponseImplToJson(
      this,
    );
  }
}

abstract class _HomeResponse implements HomeResponse {
  const factory _HomeResponse(
      {required final UserRef currentUser,
      required final DailySummary todaySummary,
      final List<CertifiedFriend> friendsCertifiedToday,
      final List<FoodRecordCard> recentRecords}) = _$HomeResponseImpl;

  factory _HomeResponse.fromJson(Map<String, dynamic> json) =
      _$HomeResponseImpl.fromJson;

  @override
  UserRef get currentUser;
  @override
  DailySummary get todaySummary;
  @override
  List<CertifiedFriend> get friendsCertifiedToday;
  @override
  List<FoodRecordCard> get recentRecords;

  /// Create a copy of HomeResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeResponseImplCopyWith<_$HomeResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
