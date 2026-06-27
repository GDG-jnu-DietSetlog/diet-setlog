// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FoodItem _$FoodItemFromJson(Map<String, dynamic> json) {
  return _FoodItem.fromJson(json);
}

/// @nodoc
mixin _$FoodItem {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get amount => throw _privateConstructorUsedError;
  int get calories => throw _privateConstructorUsedError;
  double get proteinG => throw _privateConstructorUsedError;
  double get carbsG => throw _privateConstructorUsedError;
  double get fatG => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;

  /// Serializes this FoodItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FoodItemCopyWith<FoodItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodItemCopyWith<$Res> {
  factory $FoodItemCopyWith(FoodItem value, $Res Function(FoodItem) then) =
      _$FoodItemCopyWithImpl<$Res, FoodItem>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? amount,
      int calories,
      double proteinG,
      double carbsG,
      double fatG,
      int sortOrder});
}

/// @nodoc
class _$FoodItemCopyWithImpl<$Res, $Val extends FoodItem>
    implements $FoodItemCopyWith<$Res> {
  _$FoodItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? amount = freezed,
    Object? calories = null,
    Object? proteinG = null,
    Object? carbsG = null,
    Object? fatG = null,
    Object? sortOrder = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FoodItemImplCopyWith<$Res>
    implements $FoodItemCopyWith<$Res> {
  factory _$$FoodItemImplCopyWith(
          _$FoodItemImpl value, $Res Function(_$FoodItemImpl) then) =
      __$$FoodItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? amount,
      int calories,
      double proteinG,
      double carbsG,
      double fatG,
      int sortOrder});
}

/// @nodoc
class __$$FoodItemImplCopyWithImpl<$Res>
    extends _$FoodItemCopyWithImpl<$Res, _$FoodItemImpl>
    implements _$$FoodItemImplCopyWith<$Res> {
  __$$FoodItemImplCopyWithImpl(
      _$FoodItemImpl _value, $Res Function(_$FoodItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? amount = freezed,
    Object? calories = null,
    Object? proteinG = null,
    Object? carbsG = null,
    Object? fatG = null,
    Object? sortOrder = null,
  }) {
    return _then(_$FoodItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FoodItemImpl implements _FoodItem {
  const _$FoodItemImpl(
      {required this.id,
      required this.name,
      this.amount,
      required this.calories,
      required this.proteinG,
      required this.carbsG,
      required this.fatG,
      required this.sortOrder});

  factory _$FoodItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodItemImplFromJson(json);

  @override
  final String id;
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
  final int sortOrder;

  @override
  String toString() {
    return 'FoodItem(id: $id, name: $name, amount: $amount, calories: $calories, proteinG: $proteinG, carbsG: $carbsG, fatG: $fatG, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.proteinG, proteinG) ||
                other.proteinG == proteinG) &&
            (identical(other.carbsG, carbsG) || other.carbsG == carbsG) &&
            (identical(other.fatG, fatG) || other.fatG == fatG) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, amount, calories,
      proteinG, carbsG, fatG, sortOrder);

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodItemImplCopyWith<_$FoodItemImpl> get copyWith =>
      __$$FoodItemImplCopyWithImpl<_$FoodItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodItemImplToJson(
      this,
    );
  }
}

abstract class _FoodItem implements FoodItem {
  const factory _FoodItem(
      {required final String id,
      required final String name,
      final String? amount,
      required final int calories,
      required final double proteinG,
      required final double carbsG,
      required final double fatG,
      required final int sortOrder}) = _$FoodItemImpl;

  factory _FoodItem.fromJson(Map<String, dynamic> json) =
      _$FoodItemImpl.fromJson;

  @override
  String get id;
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
  @override
  int get sortOrder;

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FoodItemImplCopyWith<_$FoodItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FoodRecordCard _$FoodRecordCardFromJson(Map<String, dynamic> json) {
  return _FoodRecordCard.fromJson(json);
}

/// @nodoc
mixin _$FoodRecordCard {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  MealType get mealType => throw _privateConstructorUsedError;
  DateTime get eatenAt => throw _privateConstructorUsedError;
  int get totalCalories => throw _privateConstructorUsedError;
  Macros get macros => throw _privateConstructorUsedError;
  String? get memo => throw _privateConstructorUsedError;
  bool get publishedToFeed => throw _privateConstructorUsedError;
  int get likeCount => throw _privateConstructorUsedError;
  int get commentCount => throw _privateConstructorUsedError;
  List<FoodItem> get items => throw _privateConstructorUsedError;

  /// Serializes this FoodRecordCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FoodRecordCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FoodRecordCardCopyWith<FoodRecordCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodRecordCardCopyWith<$Res> {
  factory $FoodRecordCardCopyWith(
          FoodRecordCard value, $Res Function(FoodRecordCard) then) =
      _$FoodRecordCardCopyWithImpl<$Res, FoodRecordCard>;
  @useResult
  $Res call(
      {String id,
      String title,
      String? imageUrl,
      MealType mealType,
      DateTime eatenAt,
      int totalCalories,
      Macros macros,
      String? memo,
      bool publishedToFeed,
      int likeCount,
      int commentCount,
      List<FoodItem> items});

  $MacrosCopyWith<$Res> get macros;
}

/// @nodoc
class _$FoodRecordCardCopyWithImpl<$Res, $Val extends FoodRecordCard>
    implements $FoodRecordCardCopyWith<$Res> {
  _$FoodRecordCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FoodRecordCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? imageUrl = freezed,
    Object? mealType = null,
    Object? eatenAt = null,
    Object? totalCalories = null,
    Object? macros = null,
    Object? memo = freezed,
    Object? publishedToFeed = null,
    Object? likeCount = null,
    Object? commentCount = null,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as MealType,
      eatenAt: null == eatenAt
          ? _value.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
      publishedToFeed: null == publishedToFeed
          ? _value.publishedToFeed
          : publishedToFeed // ignore: cast_nullable_to_non_nullable
              as bool,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<FoodItem>,
    ) as $Val);
  }

  /// Create a copy of FoodRecordCard
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
abstract class _$$FoodRecordCardImplCopyWith<$Res>
    implements $FoodRecordCardCopyWith<$Res> {
  factory _$$FoodRecordCardImplCopyWith(_$FoodRecordCardImpl value,
          $Res Function(_$FoodRecordCardImpl) then) =
      __$$FoodRecordCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? imageUrl,
      MealType mealType,
      DateTime eatenAt,
      int totalCalories,
      Macros macros,
      String? memo,
      bool publishedToFeed,
      int likeCount,
      int commentCount,
      List<FoodItem> items});

  @override
  $MacrosCopyWith<$Res> get macros;
}

/// @nodoc
class __$$FoodRecordCardImplCopyWithImpl<$Res>
    extends _$FoodRecordCardCopyWithImpl<$Res, _$FoodRecordCardImpl>
    implements _$$FoodRecordCardImplCopyWith<$Res> {
  __$$FoodRecordCardImplCopyWithImpl(
      _$FoodRecordCardImpl _value, $Res Function(_$FoodRecordCardImpl) _then)
      : super(_value, _then);

  /// Create a copy of FoodRecordCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? imageUrl = freezed,
    Object? mealType = null,
    Object? eatenAt = null,
    Object? totalCalories = null,
    Object? macros = null,
    Object? memo = freezed,
    Object? publishedToFeed = null,
    Object? likeCount = null,
    Object? commentCount = null,
    Object? items = null,
  }) {
    return _then(_$FoodRecordCardImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as MealType,
      eatenAt: null == eatenAt
          ? _value.eatenAt
          : eatenAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
      publishedToFeed: null == publishedToFeed
          ? _value.publishedToFeed
          : publishedToFeed // ignore: cast_nullable_to_non_nullable
              as bool,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<FoodItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FoodRecordCardImpl implements _FoodRecordCard {
  const _$FoodRecordCardImpl(
      {required this.id,
      required this.title,
      this.imageUrl,
      required this.mealType,
      required this.eatenAt,
      required this.totalCalories,
      required this.macros,
      this.memo,
      required this.publishedToFeed,
      required this.likeCount,
      required this.commentCount,
      final List<FoodItem> items = const <FoodItem>[]})
      : _items = items;

  factory _$FoodRecordCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodRecordCardImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? imageUrl;
  @override
  final MealType mealType;
  @override
  final DateTime eatenAt;
  @override
  final int totalCalories;
  @override
  final Macros macros;
  @override
  final String? memo;
  @override
  final bool publishedToFeed;
  @override
  final int likeCount;
  @override
  final int commentCount;
  final List<FoodItem> _items;
  @override
  @JsonKey()
  List<FoodItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'FoodRecordCard(id: $id, title: $title, imageUrl: $imageUrl, mealType: $mealType, eatenAt: $eatenAt, totalCalories: $totalCalories, macros: $macros, memo: $memo, publishedToFeed: $publishedToFeed, likeCount: $likeCount, commentCount: $commentCount, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodRecordCardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            (identical(other.totalCalories, totalCalories) ||
                other.totalCalories == totalCalories) &&
            (identical(other.macros, macros) || other.macros == macros) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.publishedToFeed, publishedToFeed) ||
                other.publishedToFeed == publishedToFeed) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      imageUrl,
      mealType,
      eatenAt,
      totalCalories,
      macros,
      memo,
      publishedToFeed,
      likeCount,
      commentCount,
      const DeepCollectionEquality().hash(_items));

  /// Create a copy of FoodRecordCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodRecordCardImplCopyWith<_$FoodRecordCardImpl> get copyWith =>
      __$$FoodRecordCardImplCopyWithImpl<_$FoodRecordCardImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodRecordCardImplToJson(
      this,
    );
  }
}

abstract class _FoodRecordCard implements FoodRecordCard {
  const factory _FoodRecordCard(
      {required final String id,
      required final String title,
      final String? imageUrl,
      required final MealType mealType,
      required final DateTime eatenAt,
      required final int totalCalories,
      required final Macros macros,
      final String? memo,
      required final bool publishedToFeed,
      required final int likeCount,
      required final int commentCount,
      final List<FoodItem> items}) = _$FoodRecordCardImpl;

  factory _FoodRecordCard.fromJson(Map<String, dynamic> json) =
      _$FoodRecordCardImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get imageUrl;
  @override
  MealType get mealType;
  @override
  DateTime get eatenAt;
  @override
  int get totalCalories;
  @override
  Macros get macros;
  @override
  String? get memo;
  @override
  bool get publishedToFeed;
  @override
  int get likeCount;
  @override
  int get commentCount;
  @override
  List<FoodItem> get items;

  /// Create a copy of FoodRecordCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FoodRecordCardImplCopyWith<_$FoodRecordCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
