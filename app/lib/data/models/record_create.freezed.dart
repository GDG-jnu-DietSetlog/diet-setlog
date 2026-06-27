// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record_create.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ItemInput _$ItemInputFromJson(Map<String, dynamic> json) {
  return _ItemInput.fromJson(json);
}

/// @nodoc
mixin _$ItemInput {
  String get name => throw _privateConstructorUsedError;
  String? get amount => throw _privateConstructorUsedError;
  int get calories => throw _privateConstructorUsedError;
  double get proteinG => throw _privateConstructorUsedError;
  double get carbsG => throw _privateConstructorUsedError;
  double get fatG => throw _privateConstructorUsedError;

  /// Serializes this ItemInput to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ItemInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItemInputCopyWith<ItemInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemInputCopyWith<$Res> {
  factory $ItemInputCopyWith(ItemInput value, $Res Function(ItemInput) then) =
      _$ItemInputCopyWithImpl<$Res, ItemInput>;
  @useResult
  $Res call(
      {String name,
      String? amount,
      int calories,
      double proteinG,
      double carbsG,
      double fatG});
}

/// @nodoc
class _$ItemInputCopyWithImpl<$Res, $Val extends ItemInput>
    implements $ItemInputCopyWith<$Res> {
  _$ItemInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ItemInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? amount = freezed,
    Object? calories = null,
    Object? proteinG = null,
    Object? carbsG = null,
    Object? fatG = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String?,
      calories: null == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as int,
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
abstract class _$$ItemInputImplCopyWith<$Res>
    implements $ItemInputCopyWith<$Res> {
  factory _$$ItemInputImplCopyWith(
          _$ItemInputImpl value, $Res Function(_$ItemInputImpl) then) =
      __$$ItemInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String? amount,
      int calories,
      double proteinG,
      double carbsG,
      double fatG});
}

/// @nodoc
class __$$ItemInputImplCopyWithImpl<$Res>
    extends _$ItemInputCopyWithImpl<$Res, _$ItemInputImpl>
    implements _$$ItemInputImplCopyWith<$Res> {
  __$$ItemInputImplCopyWithImpl(
      _$ItemInputImpl _value, $Res Function(_$ItemInputImpl) _then)
      : super(_value, _then);

  /// Create a copy of ItemInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? amount = freezed,
    Object? calories = null,
    Object? proteinG = null,
    Object? carbsG = null,
    Object? fatG = null,
  }) {
    return _then(_$ItemInputImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String?,
      calories: null == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as int,
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
class _$ItemInputImpl implements _ItemInput {
  const _$ItemInputImpl(
      {required this.name,
      this.amount,
      required this.calories,
      required this.proteinG,
      required this.carbsG,
      required this.fatG});

  factory _$ItemInputImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItemInputImplFromJson(json);

  @override
  final String name;
  @override
  final String? amount;
  @override
  final int calories;
  @override
  final double proteinG;
  @override
  final double carbsG;
  @override
  final double fatG;

  @override
  String toString() {
    return 'ItemInput(name: $name, amount: $amount, calories: $calories, proteinG: $proteinG, carbsG: $carbsG, fatG: $fatG)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemInputImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.proteinG, proteinG) ||
                other.proteinG == proteinG) &&
            (identical(other.carbsG, carbsG) || other.carbsG == carbsG) &&
            (identical(other.fatG, fatG) || other.fatG == fatG));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, amount, calories, proteinG, carbsG, fatG);

  /// Create a copy of ItemInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemInputImplCopyWith<_$ItemInputImpl> get copyWith =>
      __$$ItemInputImplCopyWithImpl<_$ItemInputImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ItemInputImplToJson(
      this,
    );
  }
}

abstract class _ItemInput implements ItemInput {
  const factory _ItemInput(
      {required final String name,
      final String? amount,
      required final int calories,
      required final double proteinG,
      required final double carbsG,
      required final double fatG}) = _$ItemInputImpl;

  factory _ItemInput.fromJson(Map<String, dynamic> json) =
      _$ItemInputImpl.fromJson;

  @override
  String get name;
  @override
  String? get amount;
  @override
  int get calories;
  @override
  double get proteinG;
  @override
  double get carbsG;
  @override
  double get fatG;

  /// Create a copy of ItemInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItemInputImplCopyWith<_$ItemInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecordCreateRequest _$RecordCreateRequestFromJson(Map<String, dynamic> json) {
  return _RecordCreateRequest.fromJson(json);
}

/// @nodoc
mixin _$RecordCreateRequest {
  String? get analysisId => throw _privateConstructorUsedError;
  MealType get mealType => throw _privateConstructorUsedError;
  DateTime get eatenAt => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int get totalCalories => throw _privateConstructorUsedError;
  Macros get macros => throw _privateConstructorUsedError;
  String? get memo => throw _privateConstructorUsedError;
  List<ItemInput> get items => throw _privateConstructorUsedError;
  bool get publishToFeed => throw _privateConstructorUsedError;

  /// Serializes this RecordCreateRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecordCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecordCreateRequestCopyWith<RecordCreateRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordCreateRequestCopyWith<$Res> {
  factory $RecordCreateRequestCopyWith(
          RecordCreateRequest value, $Res Function(RecordCreateRequest) then) =
      _$RecordCreateRequestCopyWithImpl<$Res, RecordCreateRequest>;
  @useResult
  $Res call(
      {String? analysisId,
      MealType mealType,
      DateTime eatenAt,
      String title,
      int totalCalories,
      Macros macros,
      String? memo,
      List<ItemInput> items,
      bool publishToFeed});

  $MacrosCopyWith<$Res> get macros;
}

/// @nodoc
class _$RecordCreateRequestCopyWithImpl<$Res, $Val extends RecordCreateRequest>
    implements $RecordCreateRequestCopyWith<$Res> {
  _$RecordCreateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecordCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? analysisId = freezed,
    Object? mealType = null,
    Object? eatenAt = null,
    Object? title = null,
    Object? totalCalories = null,
    Object? macros = null,
    Object? memo = freezed,
    Object? items = null,
    Object? publishToFeed = null,
  }) {
    return _then(_value.copyWith(
      analysisId: freezed == analysisId
          ? _value.analysisId
          : analysisId // ignore: cast_nullable_to_non_nullable
              as String?,
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as MealType,
      eatenAt: null == eatenAt
          ? _value.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      totalCalories: null == totalCalories
          ? _value.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as int,
      macros: null == macros
          ? _value.macros
          : macros // ignore: cast_nullable_to_non_nullable
              as Macros,
      memo: freezed == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ItemInput>,
      publishToFeed: null == publishToFeed
          ? _value.publishToFeed
          : publishToFeed // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of RecordCreateRequest
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
abstract class _$$RecordCreateRequestImplCopyWith<$Res>
    implements $RecordCreateRequestCopyWith<$Res> {
  factory _$$RecordCreateRequestImplCopyWith(_$RecordCreateRequestImpl value,
          $Res Function(_$RecordCreateRequestImpl) then) =
      __$$RecordCreateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? analysisId,
      MealType mealType,
      DateTime eatenAt,
      String title,
      int totalCalories,
      Macros macros,
      String? memo,
      List<ItemInput> items,
      bool publishToFeed});

  @override
  $MacrosCopyWith<$Res> get macros;
}

/// @nodoc
class __$$RecordCreateRequestImplCopyWithImpl<$Res>
    extends _$RecordCreateRequestCopyWithImpl<$Res, _$RecordCreateRequestImpl>
    implements _$$RecordCreateRequestImplCopyWith<$Res> {
  __$$RecordCreateRequestImplCopyWithImpl(_$RecordCreateRequestImpl _value,
      $Res Function(_$RecordCreateRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecordCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? analysisId = freezed,
    Object? mealType = null,
    Object? eatenAt = null,
    Object? title = null,
    Object? totalCalories = null,
    Object? macros = null,
    Object? memo = freezed,
    Object? items = null,
    Object? publishToFeed = null,
  }) {
    return _then(_$RecordCreateRequestImpl(
      analysisId: freezed == analysisId
          ? _value.analysisId
          : analysisId // ignore: cast_nullable_to_non_nullable
              as String?,
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as MealType,
      eatenAt: null == eatenAt
          ? _value.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      totalCalories: null == totalCalories
          ? _value.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as int,
      macros: null == macros
          ? _value.macros
          : macros // ignore: cast_nullable_to_non_nullable
              as Macros,
      memo: freezed == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ItemInput>,
      publishToFeed: null == publishToFeed
          ? _value.publishToFeed
          : publishToFeed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecordCreateRequestImpl implements _RecordCreateRequest {
  const _$RecordCreateRequestImpl(
      {this.analysisId,
      required this.mealType,
      required this.eatenAt,
      required this.title,
      required this.totalCalories,
      required this.macros,
      this.memo,
      final List<ItemInput> items = const <ItemInput>[],
      required this.publishToFeed})
      : _items = items;

  factory _$RecordCreateRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecordCreateRequestImplFromJson(json);

  @override
  final String? analysisId;
  @override
  final MealType mealType;
  @override
  final DateTime eatenAt;
  @override
  final String title;
  @override
  final int totalCalories;
  @override
  final Macros macros;
  @override
  final String? memo;
  final List<ItemInput> _items;
  @override
  @JsonKey()
  List<ItemInput> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final bool publishToFeed;

  @override
  String toString() {
    return 'RecordCreateRequest(analysisId: $analysisId, mealType: $mealType, eatenAt: $eatenAt, title: $title, totalCalories: $totalCalories, macros: $macros, memo: $memo, items: $items, publishToFeed: $publishToFeed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordCreateRequestImpl &&
            (identical(other.analysisId, analysisId) ||
                other.analysisId == analysisId) &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.totalCalories, totalCalories) ||
                other.totalCalories == totalCalories) &&
            (identical(other.macros, macros) || other.macros == macros) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.publishToFeed, publishToFeed) ||
                other.publishToFeed == publishToFeed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      analysisId,
      mealType,
      eatenAt,
      title,
      totalCalories,
      macros,
      memo,
      const DeepCollectionEquality().hash(_items),
      publishToFeed);

  /// Create a copy of RecordCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordCreateRequestImplCopyWith<_$RecordCreateRequestImpl> get copyWith =>
      __$$RecordCreateRequestImplCopyWithImpl<_$RecordCreateRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecordCreateRequestImplToJson(
      this,
    );
  }
}

abstract class _RecordCreateRequest implements RecordCreateRequest {
  const factory _RecordCreateRequest(
      {final String? analysisId,
      required final MealType mealType,
      required final DateTime eatenAt,
      required final String title,
      required final int totalCalories,
      required final Macros macros,
      final String? memo,
      final List<ItemInput> items,
      required final bool publishToFeed}) = _$RecordCreateRequestImpl;

  factory _RecordCreateRequest.fromJson(Map<String, dynamic> json) =
      _$RecordCreateRequestImpl.fromJson;

  @override
  String? get analysisId;
  @override
  MealType get mealType;
  @override
  DateTime get eatenAt;
  @override
  String get title;
  @override
  int get totalCalories;
  @override
  Macros get macros;
  @override
  String? get memo;
  @override
  List<ItemInput> get items;
  @override
  bool get publishToFeed;

  /// Create a copy of RecordCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecordCreateRequestImplCopyWith<_$RecordCreateRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecordCreateResponse _$RecordCreateResponseFromJson(Map<String, dynamic> json) {
  return _RecordCreateResponse.fromJson(json);
}

/// @nodoc
mixin _$RecordCreateResponse {
  String get recordId => throw _privateConstructorUsedError;
  FoodRecordCard get record => throw _privateConstructorUsedError;
  DailySummary get dailySummary => throw _privateConstructorUsedError;

  /// Serializes this RecordCreateResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecordCreateResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecordCreateResponseCopyWith<RecordCreateResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordCreateResponseCopyWith<$Res> {
  factory $RecordCreateResponseCopyWith(RecordCreateResponse value,
          $Res Function(RecordCreateResponse) then) =
      _$RecordCreateResponseCopyWithImpl<$Res, RecordCreateResponse>;
  @useResult
  $Res call(
      {String recordId, FoodRecordCard record, DailySummary dailySummary});

  $FoodRecordCardCopyWith<$Res> get record;
  $DailySummaryCopyWith<$Res> get dailySummary;
}

/// @nodoc
class _$RecordCreateResponseCopyWithImpl<$Res,
        $Val extends RecordCreateResponse>
    implements $RecordCreateResponseCopyWith<$Res> {
  _$RecordCreateResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecordCreateResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recordId = null,
    Object? record = null,
    Object? dailySummary = null,
  }) {
    return _then(_value.copyWith(
      recordId: null == recordId
          ? _value.recordId
          : recordId // ignore: cast_nullable_to_non_nullable
              as String,
      record: null == record
          ? _value.record
          : record // ignore: cast_nullable_to_non_nullable
              as FoodRecordCard,
      dailySummary: null == dailySummary
          ? _value.dailySummary
          : dailySummary // ignore: cast_nullable_to_non_nullable
              as DailySummary,
    ) as $Val);
  }

  /// Create a copy of RecordCreateResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FoodRecordCardCopyWith<$Res> get record {
    return $FoodRecordCardCopyWith<$Res>(_value.record, (value) {
      return _then(_value.copyWith(record: value) as $Val);
    });
  }

  /// Create a copy of RecordCreateResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DailySummaryCopyWith<$Res> get dailySummary {
    return $DailySummaryCopyWith<$Res>(_value.dailySummary, (value) {
      return _then(_value.copyWith(dailySummary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RecordCreateResponseImplCopyWith<$Res>
    implements $RecordCreateResponseCopyWith<$Res> {
  factory _$$RecordCreateResponseImplCopyWith(_$RecordCreateResponseImpl value,
          $Res Function(_$RecordCreateResponseImpl) then) =
      __$$RecordCreateResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String recordId, FoodRecordCard record, DailySummary dailySummary});

  @override
  $FoodRecordCardCopyWith<$Res> get record;
  @override
  $DailySummaryCopyWith<$Res> get dailySummary;
}

/// @nodoc
class __$$RecordCreateResponseImplCopyWithImpl<$Res>
    extends _$RecordCreateResponseCopyWithImpl<$Res, _$RecordCreateResponseImpl>
    implements _$$RecordCreateResponseImplCopyWith<$Res> {
  __$$RecordCreateResponseImplCopyWithImpl(_$RecordCreateResponseImpl _value,
      $Res Function(_$RecordCreateResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecordCreateResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recordId = null,
    Object? record = null,
    Object? dailySummary = null,
  }) {
    return _then(_$RecordCreateResponseImpl(
      recordId: null == recordId
          ? _value.recordId
          : recordId // ignore: cast_nullable_to_non_nullable
              as String,
      record: null == record
          ? _value.record
          : record // ignore: cast_nullable_to_non_nullable
              as FoodRecordCard,
      dailySummary: null == dailySummary
          ? _value.dailySummary
          : dailySummary // ignore: cast_nullable_to_non_nullable
              as DailySummary,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecordCreateResponseImpl implements _RecordCreateResponse {
  const _$RecordCreateResponseImpl(
      {required this.recordId,
      required this.record,
      required this.dailySummary});

  factory _$RecordCreateResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecordCreateResponseImplFromJson(json);

  @override
  final String recordId;
  @override
  final FoodRecordCard record;
  @override
  final DailySummary dailySummary;

  @override
  String toString() {
    return 'RecordCreateResponse(recordId: $recordId, record: $record, dailySummary: $dailySummary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordCreateResponseImpl &&
            (identical(other.recordId, recordId) ||
                other.recordId == recordId) &&
            (identical(other.record, record) || other.record == record) &&
            (identical(other.dailySummary, dailySummary) ||
                other.dailySummary == dailySummary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, recordId, record, dailySummary);

  /// Create a copy of RecordCreateResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordCreateResponseImplCopyWith<_$RecordCreateResponseImpl>
      get copyWith =>
          __$$RecordCreateResponseImplCopyWithImpl<_$RecordCreateResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecordCreateResponseImplToJson(
      this,
    );
  }
}

abstract class _RecordCreateResponse implements RecordCreateResponse {
  const factory _RecordCreateResponse(
      {required final String recordId,
      required final FoodRecordCard record,
      required final DailySummary dailySummary}) = _$RecordCreateResponseImpl;

  factory _RecordCreateResponse.fromJson(Map<String, dynamic> json) =
      _$RecordCreateResponseImpl.fromJson;

  @override
  String get recordId;
  @override
  FoodRecordCard get record;
  @override
  DailySummary get dailySummary;

  /// Create a copy of RecordCreateResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecordCreateResponseImplCopyWith<_$RecordCreateResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
