import 'package:freezed_annotation/freezed_annotation.dart';
import 'common.dart';
import 'food_record.dart';

part 'calendar.freezed.dart';
part 'calendar.g.dart';

/// 끼니별 기록 그룹 — 4키 항상 존재.
@freezed
class RecordsByMeal with _$RecordsByMeal {
  const factory RecordsByMeal({
    @Default(<FoodRecordCard>[]) List<FoodRecordCard> breakfast,
    @Default(<FoodRecordCard>[]) List<FoodRecordCard> lunch,
    @Default(<FoodRecordCard>[]) List<FoodRecordCard> dinner,
    @Default(<FoodRecordCard>[]) List<FoodRecordCard> snack,
  }) = _RecordsByMeal;

  factory RecordsByMeal.fromJson(Map<String, dynamic> json) =>
      _$RecordsByMealFromJson(json);
}

/// openapi CalendarDayResponse.
@freezed
class CalendarDayResponse with _$CalendarDayResponse {
  const factory CalendarDayResponse({
    required String date,
    required int calorieTarget,
    required int totalCalories,
    required Macros macros,
    required int progressPercent,
    required RecordsByMeal recordsByMeal,
  }) = _CalendarDayResponse;

  factory CalendarDayResponse.fromJson(Map<String, dynamic> json) =>
      _$CalendarDayResponseFromJson(json);
}
