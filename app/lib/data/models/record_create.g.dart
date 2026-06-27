// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ItemInputImpl _$$ItemInputImplFromJson(Map<String, dynamic> json) =>
    _$ItemInputImpl(
      name: json['name'] as String,
      amount: json['amount'] as String?,
      calories: (json['calories'] as num).toInt(),
      proteinG: (json['proteinG'] as num).toDouble(),
      carbsG: (json['carbsG'] as num).toDouble(),
      fatG: (json['fatG'] as num).toDouble(),
    );

Map<String, dynamic> _$$ItemInputImplToJson(_$ItemInputImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'amount': instance.amount,
      'calories': instance.calories,
      'proteinG': instance.proteinG,
      'carbsG': instance.carbsG,
      'fatG': instance.fatG,
    };

_$RecordCreateRequestImpl _$$RecordCreateRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$RecordCreateRequestImpl(
      analysisId: json['analysisId'] as String?,
      mealType: $enumDecode(_$MealTypeEnumMap, json['mealType']),
      eatenAt: DateTime.parse(json['eatenAt'] as String),
      title: json['title'] as String,
      totalCalories: (json['totalCalories'] as num).toInt(),
      macros: Macros.fromJson(json['macros'] as Map<String, dynamic>),
      memo: json['memo'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ItemInput.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ItemInput>[],
      publishToFeed: json['publishToFeed'] as bool,
    );

Map<String, dynamic> _$$RecordCreateRequestImplToJson(
        _$RecordCreateRequestImpl instance) =>
    <String, dynamic>{
      'analysisId': instance.analysisId,
      'mealType': _$MealTypeEnumMap[instance.mealType]!,
      'eatenAt': instance.eatenAt.toIso8601String(),
      'title': instance.title,
      'totalCalories': instance.totalCalories,
      'macros': instance.macros,
      'memo': instance.memo,
      'items': instance.items,
      'publishToFeed': instance.publishToFeed,
    };

const _$MealTypeEnumMap = {
  MealType.breakfast: 'breakfast',
  MealType.lunch: 'lunch',
  MealType.dinner: 'dinner',
  MealType.snack: 'snack',
};

_$RecordCreateResponseImpl _$$RecordCreateResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$RecordCreateResponseImpl(
      recordId: json['recordId'] as String,
      record: FoodRecordCard.fromJson(json['record'] as Map<String, dynamic>),
      dailySummary:
          DailySummary.fromJson(json['dailySummary'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$RecordCreateResponseImplToJson(
        _$RecordCreateResponseImpl instance) =>
    <String, dynamic>{
      'recordId': instance.recordId,
      'record': instance.record,
      'dailySummary': instance.dailySummary,
    };
