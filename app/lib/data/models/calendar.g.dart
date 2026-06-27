// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecordsByMealImpl _$$RecordsByMealImplFromJson(Map<String, dynamic> json) =>
    _$RecordsByMealImpl(
      breakfast: (json['breakfast'] as List<dynamic>?)
              ?.map((e) => FoodRecordCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <FoodRecordCard>[],
      lunch: (json['lunch'] as List<dynamic>?)
              ?.map((e) => FoodRecordCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <FoodRecordCard>[],
      dinner: (json['dinner'] as List<dynamic>?)
              ?.map((e) => FoodRecordCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <FoodRecordCard>[],
      snack: (json['snack'] as List<dynamic>?)
              ?.map((e) => FoodRecordCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <FoodRecordCard>[],
    );

Map<String, dynamic> _$$RecordsByMealImplToJson(_$RecordsByMealImpl instance) =>
    <String, dynamic>{
      'breakfast': instance.breakfast,
      'lunch': instance.lunch,
      'dinner': instance.dinner,
      'snack': instance.snack,
    };

_$CalendarDayResponseImpl _$$CalendarDayResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$CalendarDayResponseImpl(
      date: json['date'] as String,
      calorieTarget: (json['calorieTarget'] as num).toInt(),
      totalCalories: (json['totalCalories'] as num).toInt(),
      macros: Macros.fromJson(json['macros'] as Map<String, dynamic>),
      progressPercent: (json['progressPercent'] as num).toInt(),
      recordsByMeal:
          RecordsByMeal.fromJson(json['recordsByMeal'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CalendarDayResponseImplToJson(
        _$CalendarDayResponseImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'calorieTarget': instance.calorieTarget,
      'totalCalories': instance.totalCalories,
      'macros': instance.macros,
      'progressPercent': instance.progressPercent,
      'recordsByMeal': instance.recordsByMeal,
    };
