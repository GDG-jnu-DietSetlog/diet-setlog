// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecordsByMeal _$RecordsByMealFromJson(Map<String, dynamic> json) {
  return _RecordsByMeal.fromJson(json);
}

/// @nodoc
mixin _$RecordsByMeal {
  List<FoodRecordCard> get breakfast => throw _privateConstructorUsedError;
  List<FoodRecordCard> get lunch => throw _privateConstructorUsedError;
  List<FoodRecordCard> get dinner => throw _privateConstructorUsedError;
  List<FoodRecordCard> get snack => throw _privateConstructorUsedError;

  /// Serializes this RecordsByMeal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecordsByMeal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecordsByMealCopyWith<RecordsByMeal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordsByMealCopyWith<$Res> {
  factory $RecordsByMealCopyWith(
          RecordsByMeal value, $Res Function(RecordsByMeal) then) =
      _$RecordsByMealCopyWithImpl<$Res, RecordsByMeal>;
  @useResult
  $Res call(
      {List<FoodRecordCard> breakfast,
      List<FoodRecordCard> lunch,
      List<FoodRecordCard> dinner,
      List<FoodRecordCard> snack});
}

/// @nodoc
class _$RecordsByMealCopyWithImpl<$Res, $Val extends RecordsByMeal>
    implements $RecordsByMealCopyWith<$Res> {
  _$RecordsByMealCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecordsByMeal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? breakfast = null,
    Object? lunch = null,
    Object? dinner = null,
    Object? snack = null,
  }) {
    return _then(_value.copyWith(
      breakfast: null == breakfast
          ? _value.breakfast
          : breakfast // ignore: cast_nullable_to_non_nullable
              as List<FoodRecordCard>,
      lunch: null == lunch
          ? _value.lunch
          : lunch // ignore: cast_nullable_to_non_nullable
              as List<FoodRecordCard>,
      dinner: null == dinner
          ? _value.dinner
          : dinner // ignore: cast_nullable_to_non_nullable
              as List<FoodRecordCard>,
      snack: null == snack
          ? _value.snack
          : snack // ignore: cast_nullable_to_non_nullable
              as List<FoodRecordCard>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecordsByMealImplCopyWith<$Res>
    implements $RecordsByMealCopyWith<$Res> {
  factory _$$RecordsByMealImplCopyWith(
          _$RecordsByMealImpl value, $Res Function(_$RecordsByMealImpl) then) =
      __$$RecordsByMealImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<FoodRecordCard> breakfast,
      List<FoodRecordCard> lunch,
      List<FoodRecordCard> dinner,
      List<FoodRecordCard> snack});
}

/// @nodoc
class __$$RecordsByMealImplCopyWithImpl<$Res>
    extends _$RecordsByMealCopyWithImpl<$Res, _$RecordsByMealImpl>
    implements _$$RecordsByMealImplCopyWith<$Res> {
  __$$RecordsByMealImplCopyWithImpl(
      _$RecordsByMealImpl _value, $Res Function(_$RecordsByMealImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecordsByMeal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? breakfast = null,
    Object? lunch = null,
    Object? dinner = null,
    Object? snack = null,
  }) {
    return _then(_$RecordsByMealImpl(
      breakfast: null == breakfast
          ? _value._breakfast
          : breakfast // ignore: cast_nullable_to_non_nullable
              as List<FoodRecordCard>,
      lunch: null == lunch
          ? _value._lunch
          : lunch // ignore: cast_nullable_to_non_nullable
              as List<FoodRecordCard>,
      dinner: null == dinner
          ? _value._dinner
          : dinner // ignore: cast_nullable_to_non_nullable
              as List<FoodRecordCard>,
      snack: null == snack
          ? _value._snack
          : snack // ignore: cast_nullable_to_non_nullable
              as List<FoodRecordCard>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecordsByMealImpl implements _RecordsByMeal {
  const _$RecordsByMealImpl(
      {final List<FoodRecordCard> breakfast = const <FoodRecordCard>[],
      final List<FoodRecordCard> lunch = const <FoodRecordCard>[],
      final List<FoodRecordCard> dinner = const <FoodRecordCard>[],
      final List<FoodRecordCard> snack = const <FoodRecordCard>[]})
      : _breakfast = breakfast,
        _lunch = lunch,
        _dinner = dinner,
        _snack = snack;

  factory _$RecordsByMealImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecordsByMealImplFromJson(json);

  final List<FoodRecordCard> _breakfast;
  @override
  @JsonKey()
  List<FoodRecordCard> get breakfast {
    if (_breakfast is EqualUnmodifiableListView) return _breakfast;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_breakfast);
  }

  final List<FoodRecordCard> _lunch;
  @override
  @JsonKey()
  List<FoodRecordCard> get lunch {
    if (_lunch is EqualUnmodifiableListView) return _lunch;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lunch);
  }

  final List<FoodRecordCard> _dinner;
  @override
  @JsonKey()
  List<FoodRecordCard> get dinner {
    if (_dinner is EqualUnmodifiableListView) return _dinner;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dinner);
  }

  final List<FoodRecordCard> _snack;
  @override
  @JsonKey()
  List<FoodRecordCard> get snack {
    if (_snack is EqualUnmodifiableListView) return _snack;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_snack);
  }

  @override
  String toString() {
    return 'RecordsByMeal(breakfast: $breakfast, lunch: $lunch, dinner: $dinner, snack: $snack)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordsByMealImpl &&
            const DeepCollectionEquality()
                .equals(other._breakfast, _breakfast) &&
            const DeepCollectionEquality().equals(other._lunch, _lunch) &&
            const DeepCollectionEquality().equals(other._dinner, _dinner) &&
            const DeepCollectionEquality().equals(other._snack, _snack));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_breakfast),
      const DeepCollectionEquality().hash(_lunch),
      const DeepCollectionEquality().hash(_dinner),
      const DeepCollectionEquality().hash(_snack));

  /// Create a copy of RecordsByMeal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordsByMealImplCopyWith<_$RecordsByMealImpl> get copyWith =>
      __$$RecordsByMealImplCopyWithImpl<_$RecordsByMealImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecordsByMealImplToJson(
      this,
    );
  }
}

abstract class _RecordsByMeal implements RecordsByMeal {
  const factory _RecordsByMeal(
      {final List<FoodRecordCard> breakfast,
      final List<FoodRecordCard> lunch,
      final List<FoodRecordCard> dinner,
      final List<FoodRecordCard> snack}) = _$RecordsByMealImpl;

  factory _RecordsByMeal.fromJson(Map<String, dynamic> json) =
      _$RecordsByMealImpl.fromJson;

  @override
  List<FoodRecordCard> get breakfast;
  @override
  List<FoodRecordCard> get lunch;
  @override
  List<FoodRecordCard> get dinner;
  @override
  List<FoodRecordCard> get snack;

  /// Create a copy of RecordsByMeal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecordsByMealImplCopyWith<_$RecordsByMealImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CalendarDayResponse _$CalendarDayResponseFromJson(Map<String, dynamic> json) {
  return _CalendarDayResponse.fromJson(json);
}

/// @nodoc
mixin _$CalendarDayResponse {
  String get date => throw _privateConstructorUsedError;
  int get calorieTarget => throw _privateConstructorUsedError;
  int get totalCalories => throw _privateConstructorUsedError;
  Macros get macros => throw _privateConstructorUsedError;
  int get progressPercent => throw _privateConstructorUsedError;
  RecordsByMeal get recordsByMeal => throw _privateConstructorUsedError;

  /// Serializes this CalendarDayResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CalendarDayResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CalendarDayResponseCopyWith<CalendarDayResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarDayResponseCopyWith<$Res> {
  factory $CalendarDayResponseCopyWith(
          CalendarDayResponse value, $Res Function(CalendarDayResponse) then) =
      _$CalendarDayResponseCopyWithImpl<$Res, CalendarDayResponse>;
  @useResult
  $Res call(
      {String date,
      int calorieTarget,
      int totalCalories,
      Macros macros,
      int progressPercent,
      RecordsByMeal recordsByMeal});

  $MacrosCopyWith<$Res> get macros;
  $RecordsByMealCopyWith<$Res> get recordsByMeal;
}

/// @nodoc
class _$CalendarDayResponseCopyWithImpl<$Res, $Val extends CalendarDayResponse>
    implements $CalendarDayResponseCopyWith<$Res> {
  _$CalendarDayResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CalendarDayResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? calorieTarget = null,
    Object? totalCalories = null,
    Object? macros = null,
    Object? progressPercent = null,
    Object? recordsByMeal = null,
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
      progressPercent: null == progressPercent
          ? _value.progressPercent
          : progressPercent // ignore: cast_nullable_to_non_nullable
              as int,
      recordsByMeal: null == recordsByMeal
          ? _value.recordsByMeal
          : recordsByMeal // ignore: cast_nullable_to_non_nullable
              as RecordsByMeal,
    ) as $Val);
  }

  /// Create a copy of CalendarDayResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MacrosCopyWith<$Res> get macros {
    return $MacrosCopyWith<$Res>(_value.macros, (value) {
      return _then(_value.copyWith(macros: value) as $Val);
    });
  }

  /// Create a copy of CalendarDayResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RecordsByMealCopyWith<$Res> get recordsByMeal {
    return $RecordsByMealCopyWith<$Res>(_value.recordsByMeal, (value) {
      return _then(_value.copyWith(recordsByMeal: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CalendarDayResponseImplCopyWith<$Res>
    implements $CalendarDayResponseCopyWith<$Res> {
  factory _$$CalendarDayResponseImplCopyWith(_$CalendarDayResponseImpl value,
          $Res Function(_$CalendarDayResponseImpl) then) =
      __$$CalendarDayResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String date,
      int calorieTarget,
      int totalCalories,
      Macros macros,
      int progressPercent,
      RecordsByMeal recordsByMeal});

  @override
  $MacrosCopyWith<$Res> get macros;
  @override
  $RecordsByMealCopyWith<$Res> get recordsByMeal;
}

/// @nodoc
class __$$CalendarDayResponseImplCopyWithImpl<$Res>
    extends _$CalendarDayResponseCopyWithImpl<$Res, _$CalendarDayResponseImpl>
    implements _$$CalendarDayResponseImplCopyWith<$Res> {
  __$$CalendarDayResponseImplCopyWithImpl(_$CalendarDayResponseImpl _value,
      $Res Function(_$CalendarDayResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of CalendarDayResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? calorieTarget = null,
    Object? totalCalories = null,
    Object? macros = null,
    Object? progressPercent = null,
    Object? recordsByMeal = null,
  }) {
    return _then(_$CalendarDayResponseImpl(
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
      progressPercent: null == progressPercent
          ? _value.progressPercent
          : progressPercent // ignore: cast_nullable_to_non_nullable
              as int,
      recordsByMeal: null == recordsByMeal
          ? _value.recordsByMeal
          : recordsByMeal // ignore: cast_nullable_to_non_nullable
              as RecordsByMeal,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CalendarDayResponseImpl implements _CalendarDayResponse {
  const _$CalendarDayResponseImpl(
      {required this.date,
      required this.calorieTarget,
      required this.totalCalories,
      required this.macros,
      required this.progressPercent,
      required this.recordsByMeal});

  factory _$CalendarDayResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CalendarDayResponseImplFromJson(json);

  @override
  final String date;
  @override
  final int calorieTarget;
  @override
  final int totalCalories;
  @override
  final Macros macros;
  @override
  final int progressPercent;
  @override
  final RecordsByMeal recordsByMeal;

  @override
  String toString() {
    return 'CalendarDayResponse(date: $date, calorieTarget: $calorieTarget, totalCalories: $totalCalories, macros: $macros, progressPercent: $progressPercent, recordsByMeal: $recordsByMeal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalendarDayResponseImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.calorieTarget, calorieTarget) ||
                other.calorieTarget == calorieTarget) &&
            (identical(other.totalCalories, totalCalories) ||
                other.totalCalories == totalCalories) &&
            (identical(other.macros, macros) || other.macros == macros) &&
            (identical(other.progressPercent, progressPercent) ||
                other.progressPercent == progressPercent) &&
            (identical(other.recordsByMeal, recordsByMeal) ||
                other.recordsByMeal == recordsByMeal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, calorieTarget,
      totalCalories, macros, progressPercent, recordsByMeal);

  /// Create a copy of CalendarDayResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CalendarDayResponseImplCopyWith<_$CalendarDayResponseImpl> get copyWith =>
      __$$CalendarDayResponseImplCopyWithImpl<_$CalendarDayResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CalendarDayResponseImplToJson(
      this,
    );
  }
}

abstract class _CalendarDayResponse implements CalendarDayResponse {
  const factory _CalendarDayResponse(
      {required final String date,
      required final int calorieTarget,
      required final int totalCalories,
      required final Macros macros,
      required final int progressPercent,
      required final RecordsByMeal recordsByMeal}) = _$CalendarDayResponseImpl;

  factory _CalendarDayResponse.fromJson(Map<String, dynamic> json) =
      _$CalendarDayResponseImpl.fromJson;

  @override
  String get date;
  @override
  int get calorieTarget;
  @override
  int get totalCalories;
  @override
  Macros get macros;
  @override
  int get progressPercent;
  @override
  RecordsByMeal get recordsByMeal;

  /// Create a copy of CalendarDayResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CalendarDayResponseImplCopyWith<_$CalendarDayResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
