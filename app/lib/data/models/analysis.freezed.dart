// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analysis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AnalysisItem _$AnalysisItemFromJson(Map<String, dynamic> json) {
  return _AnalysisItem.fromJson(json);
}

/// @nodoc
mixin _$AnalysisItem {
  String get name => throw _privateConstructorUsedError;
  String? get amount => throw _privateConstructorUsedError;
  int get calories => throw _privateConstructorUsedError;
  double get proteinG => throw _privateConstructorUsedError;
  double get carbsG => throw _privateConstructorUsedError;
  double get fatG => throw _privateConstructorUsedError;

  /// Serializes this AnalysisItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalysisItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalysisItemCopyWith<AnalysisItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalysisItemCopyWith<$Res> {
  factory $AnalysisItemCopyWith(
          AnalysisItem value, $Res Function(AnalysisItem) then) =
      _$AnalysisItemCopyWithImpl<$Res, AnalysisItem>;
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
class _$AnalysisItemCopyWithImpl<$Res, $Val extends AnalysisItem>
    implements $AnalysisItemCopyWith<$Res> {
  _$AnalysisItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalysisItem
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
abstract class _$$AnalysisItemImplCopyWith<$Res>
    implements $AnalysisItemCopyWith<$Res> {
  factory _$$AnalysisItemImplCopyWith(
          _$AnalysisItemImpl value, $Res Function(_$AnalysisItemImpl) then) =
      __$$AnalysisItemImplCopyWithImpl<$Res>;
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
class __$$AnalysisItemImplCopyWithImpl<$Res>
    extends _$AnalysisItemCopyWithImpl<$Res, _$AnalysisItemImpl>
    implements _$$AnalysisItemImplCopyWith<$Res> {
  __$$AnalysisItemImplCopyWithImpl(
      _$AnalysisItemImpl _value, $Res Function(_$AnalysisItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnalysisItem
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
    return _then(_$AnalysisItemImpl(
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
class _$AnalysisItemImpl implements _AnalysisItem {
  const _$AnalysisItemImpl(
      {required this.name,
      this.amount,
      required this.calories,
      required this.proteinG,
      required this.carbsG,
      required this.fatG});

  factory _$AnalysisItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalysisItemImplFromJson(json);

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
    return 'AnalysisItem(name: $name, amount: $amount, calories: $calories, proteinG: $proteinG, carbsG: $carbsG, fatG: $fatG)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalysisItemImpl &&
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

  /// Create a copy of AnalysisItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalysisItemImplCopyWith<_$AnalysisItemImpl> get copyWith =>
      __$$AnalysisItemImplCopyWithImpl<_$AnalysisItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalysisItemImplToJson(
      this,
    );
  }
}

abstract class _AnalysisItem implements AnalysisItem {
  const factory _AnalysisItem(
      {required final String name,
      final String? amount,
      required final int calories,
      required final double proteinG,
      required final double carbsG,
      required final double fatG}) = _$AnalysisItemImpl;

  factory _AnalysisItem.fromJson(Map<String, dynamic> json) =
      _$AnalysisItemImpl.fromJson;

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

  /// Create a copy of AnalysisItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalysisItemImplCopyWith<_$AnalysisItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AnalysisResult _$AnalysisResultFromJson(Map<String, dynamic> json) {
  return _AnalysisResult.fromJson(json);
}

/// @nodoc
mixin _$AnalysisResult {
  String get dishName => throw _privateConstructorUsedError;
  int get totalCalories => throw _privateConstructorUsedError;
  Macros get macros => throw _privateConstructorUsedError;
  List<AnalysisItem> get items => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this AnalysisResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalysisResultCopyWith<AnalysisResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalysisResultCopyWith<$Res> {
  factory $AnalysisResultCopyWith(
          AnalysisResult value, $Res Function(AnalysisResult) then) =
      _$AnalysisResultCopyWithImpl<$Res, AnalysisResult>;
  @useResult
  $Res call(
      {String dishName,
      int totalCalories,
      Macros macros,
      List<AnalysisItem> items,
      double confidence,
      String? notes});

  $MacrosCopyWith<$Res> get macros;
}

/// @nodoc
class _$AnalysisResultCopyWithImpl<$Res, $Val extends AnalysisResult>
    implements $AnalysisResultCopyWith<$Res> {
  _$AnalysisResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dishName = null,
    Object? totalCalories = null,
    Object? macros = null,
    Object? items = null,
    Object? confidence = null,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      dishName: null == dishName
          ? _value.dishName
          : dishName // ignore: cast_nullable_to_non_nullable
              as String,
      totalCalories: null == totalCalories
          ? _value.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as int,
      macros: null == macros
          ? _value.macros
          : macros // ignore: cast_nullable_to_non_nullable
              as Macros,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<AnalysisItem>,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of AnalysisResult
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
abstract class _$$AnalysisResultImplCopyWith<$Res>
    implements $AnalysisResultCopyWith<$Res> {
  factory _$$AnalysisResultImplCopyWith(_$AnalysisResultImpl value,
          $Res Function(_$AnalysisResultImpl) then) =
      __$$AnalysisResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String dishName,
      int totalCalories,
      Macros macros,
      List<AnalysisItem> items,
      double confidence,
      String? notes});

  @override
  $MacrosCopyWith<$Res> get macros;
}

/// @nodoc
class __$$AnalysisResultImplCopyWithImpl<$Res>
    extends _$AnalysisResultCopyWithImpl<$Res, _$AnalysisResultImpl>
    implements _$$AnalysisResultImplCopyWith<$Res> {
  __$$AnalysisResultImplCopyWithImpl(
      _$AnalysisResultImpl _value, $Res Function(_$AnalysisResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dishName = null,
    Object? totalCalories = null,
    Object? macros = null,
    Object? items = null,
    Object? confidence = null,
    Object? notes = freezed,
  }) {
    return _then(_$AnalysisResultImpl(
      dishName: null == dishName
          ? _value.dishName
          : dishName // ignore: cast_nullable_to_non_nullable
              as String,
      totalCalories: null == totalCalories
          ? _value.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as int,
      macros: null == macros
          ? _value.macros
          : macros // ignore: cast_nullable_to_non_nullable
              as Macros,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<AnalysisItem>,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalysisResultImpl implements _AnalysisResult {
  const _$AnalysisResultImpl(
      {required this.dishName,
      required this.totalCalories,
      required this.macros,
      final List<AnalysisItem> items = const <AnalysisItem>[],
      required this.confidence,
      this.notes})
      : _items = items;

  factory _$AnalysisResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalysisResultImplFromJson(json);

  @override
  final String dishName;
  @override
  final int totalCalories;
  @override
  final Macros macros;
  final List<AnalysisItem> _items;
  @override
  @JsonKey()
  List<AnalysisItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final double confidence;
  @override
  final String? notes;

  @override
  String toString() {
    return 'AnalysisResult(dishName: $dishName, totalCalories: $totalCalories, macros: $macros, items: $items, confidence: $confidence, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalysisResultImpl &&
            (identical(other.dishName, dishName) ||
                other.dishName == dishName) &&
            (identical(other.totalCalories, totalCalories) ||
                other.totalCalories == totalCalories) &&
            (identical(other.macros, macros) || other.macros == macros) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, dishName, totalCalories, macros,
      const DeepCollectionEquality().hash(_items), confidence, notes);

  /// Create a copy of AnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalysisResultImplCopyWith<_$AnalysisResultImpl> get copyWith =>
      __$$AnalysisResultImplCopyWithImpl<_$AnalysisResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalysisResultImplToJson(
      this,
    );
  }
}

abstract class _AnalysisResult implements AnalysisResult {
  const factory _AnalysisResult(
      {required final String dishName,
      required final int totalCalories,
      required final Macros macros,
      final List<AnalysisItem> items,
      required final double confidence,
      final String? notes}) = _$AnalysisResultImpl;

  factory _AnalysisResult.fromJson(Map<String, dynamic> json) =
      _$AnalysisResultImpl.fromJson;

  @override
  String get dishName;
  @override
  int get totalCalories;
  @override
  Macros get macros;
  @override
  List<AnalysisItem> get items;
  @override
  double get confidence;
  @override
  String? get notes;

  /// Create a copy of AnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalysisResultImplCopyWith<_$AnalysisResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AnalysisResponse _$AnalysisResponseFromJson(Map<String, dynamic> json) {
  return _AnalysisResponse.fromJson(json);
}

/// @nodoc
mixin _$AnalysisResponse {
  String get analysisId => throw _privateConstructorUsedError;
  AnalysisStatus get status => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  AnalysisResult? get result => throw _privateConstructorUsedError; // completed
  bool? get needsReview => throw _privateConstructorUsedError; // completed
  String? get errorCode => throw _privateConstructorUsedError; // failed
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this AnalysisResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalysisResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalysisResponseCopyWith<AnalysisResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalysisResponseCopyWith<$Res> {
  factory $AnalysisResponseCopyWith(
          AnalysisResponse value, $Res Function(AnalysisResponse) then) =
      _$AnalysisResponseCopyWithImpl<$Res, AnalysisResponse>;
  @useResult
  $Res call(
      {String analysisId,
      AnalysisStatus status,
      String imageUrl,
      AnalysisResult? result,
      bool? needsReview,
      String? errorCode,
      String? message});

  $AnalysisResultCopyWith<$Res>? get result;
}

/// @nodoc
class _$AnalysisResponseCopyWithImpl<$Res, $Val extends AnalysisResponse>
    implements $AnalysisResponseCopyWith<$Res> {
  _$AnalysisResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalysisResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? analysisId = null,
    Object? status = null,
    Object? imageUrl = null,
    Object? result = freezed,
    Object? needsReview = freezed,
    Object? errorCode = freezed,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      analysisId: null == analysisId
          ? _value.analysisId
          : analysisId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AnalysisStatus,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as AnalysisResult?,
      needsReview: freezed == needsReview
          ? _value.needsReview
          : needsReview // ignore: cast_nullable_to_non_nullable
              as bool?,
      errorCode: freezed == errorCode
          ? _value.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of AnalysisResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AnalysisResultCopyWith<$Res>? get result {
    if (_value.result == null) {
      return null;
    }

    return $AnalysisResultCopyWith<$Res>(_value.result!, (value) {
      return _then(_value.copyWith(result: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AnalysisResponseImplCopyWith<$Res>
    implements $AnalysisResponseCopyWith<$Res> {
  factory _$$AnalysisResponseImplCopyWith(_$AnalysisResponseImpl value,
          $Res Function(_$AnalysisResponseImpl) then) =
      __$$AnalysisResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String analysisId,
      AnalysisStatus status,
      String imageUrl,
      AnalysisResult? result,
      bool? needsReview,
      String? errorCode,
      String? message});

  @override
  $AnalysisResultCopyWith<$Res>? get result;
}

/// @nodoc
class __$$AnalysisResponseImplCopyWithImpl<$Res>
    extends _$AnalysisResponseCopyWithImpl<$Res, _$AnalysisResponseImpl>
    implements _$$AnalysisResponseImplCopyWith<$Res> {
  __$$AnalysisResponseImplCopyWithImpl(_$AnalysisResponseImpl _value,
      $Res Function(_$AnalysisResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnalysisResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? analysisId = null,
    Object? status = null,
    Object? imageUrl = null,
    Object? result = freezed,
    Object? needsReview = freezed,
    Object? errorCode = freezed,
    Object? message = freezed,
  }) {
    return _then(_$AnalysisResponseImpl(
      analysisId: null == analysisId
          ? _value.analysisId
          : analysisId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AnalysisStatus,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as AnalysisResult?,
      needsReview: freezed == needsReview
          ? _value.needsReview
          : needsReview // ignore: cast_nullable_to_non_nullable
              as bool?,
      errorCode: freezed == errorCode
          ? _value.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalysisResponseImpl implements _AnalysisResponse {
  const _$AnalysisResponseImpl(
      {required this.analysisId,
      required this.status,
      required this.imageUrl,
      this.result,
      this.needsReview,
      this.errorCode,
      this.message});

  factory _$AnalysisResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalysisResponseImplFromJson(json);

  @override
  final String analysisId;
  @override
  final AnalysisStatus status;
  @override
  final String imageUrl;
  @override
  final AnalysisResult? result;
// completed
  @override
  final bool? needsReview;
// completed
  @override
  final String? errorCode;
// failed
  @override
  final String? message;

  @override
  String toString() {
    return 'AnalysisResponse(analysisId: $analysisId, status: $status, imageUrl: $imageUrl, result: $result, needsReview: $needsReview, errorCode: $errorCode, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalysisResponseImpl &&
            (identical(other.analysisId, analysisId) ||
                other.analysisId == analysisId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.needsReview, needsReview) ||
                other.needsReview == needsReview) &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, analysisId, status, imageUrl,
      result, needsReview, errorCode, message);

  /// Create a copy of AnalysisResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalysisResponseImplCopyWith<_$AnalysisResponseImpl> get copyWith =>
      __$$AnalysisResponseImplCopyWithImpl<_$AnalysisResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalysisResponseImplToJson(
      this,
    );
  }
}

abstract class _AnalysisResponse implements AnalysisResponse {
  const factory _AnalysisResponse(
      {required final String analysisId,
      required final AnalysisStatus status,
      required final String imageUrl,
      final AnalysisResult? result,
      final bool? needsReview,
      final String? errorCode,
      final String? message}) = _$AnalysisResponseImpl;

  factory _AnalysisResponse.fromJson(Map<String, dynamic> json) =
      _$AnalysisResponseImpl.fromJson;

  @override
  String get analysisId;
  @override
  AnalysisStatus get status;
  @override
  String get imageUrl;
  @override
  AnalysisResult? get result; // completed
  @override
  bool? get needsReview; // completed
  @override
  String? get errorCode; // failed
  @override
  String? get message;

  /// Create a copy of AnalysisResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalysisResponseImplCopyWith<_$AnalysisResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
