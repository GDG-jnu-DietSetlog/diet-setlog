// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodItemImpl _$$FoodItemImplFromJson(Map<String, dynamic> json) =>
    _$FoodItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: json['amount'] as String?,
      calories: (json['calories'] as num).toInt(),
      proteinG: (json['proteinG'] as num).toDouble(),
      carbsG: (json['carbsG'] as num).toDouble(),
      fatG: (json['fatG'] as num).toDouble(),
      sortOrder: (json['sortOrder'] as num).toInt(),
    );

Map<String, dynamic> _$$FoodItemImplToJson(_$FoodItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'amount': instance.amount,
      'calories': instance.calories,
      'proteinG': instance.proteinG,
      'carbsG': instance.carbsG,
      'fatG': instance.fatG,
      'sortOrder': instance.sortOrder,
    };

_$FoodRecordCardImpl _$$FoodRecordCardImplFromJson(Map<String, dynamic> json) =>
    _$FoodRecordCardImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String?,
      mealType: $enumDecode(_$MealTypeEnumMap, json['mealType']),
      eatenAt: DateTime.parse(json['eatenAt'] as String),
      totalCalories: (json['totalCalories'] as num).toInt(),
      macros: Macros.fromJson(json['macros'] as Map<String, dynamic>),
      memo: json['memo'] as String?,
      publishedToFeed: json['publishedToFeed'] as bool,
      likeCount: (json['likeCount'] as num).toInt(),
      commentCount: (json['commentCount'] as num).toInt(),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <FoodItem>[],
    );

Map<String, dynamic> _$$FoodRecordCardImplToJson(
        _$FoodRecordCardImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'mealType': _$MealTypeEnumMap[instance.mealType]!,
      'eatenAt': instance.eatenAt.toIso8601String(),
      'totalCalories': instance.totalCalories,
      'macros': instance.macros,
      'memo': instance.memo,
      'publishedToFeed': instance.publishedToFeed,
      'likeCount': instance.likeCount,
      'commentCount': instance.commentCount,
      'items': instance.items,
    };

const _$MealTypeEnumMap = {
  MealType.breakfast: 'breakfast',
  MealType.lunch: 'lunch',
  MealType.dinner: 'dinner',
  MealType.snack: 'snack',
};
