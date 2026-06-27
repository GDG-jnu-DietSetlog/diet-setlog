import 'package:freezed_annotation/freezed_annotation.dart';
import 'common.dart';
import 'enums.dart';

part 'food_record.freezed.dart';
part 'food_record.g.dart';

/// openapi FoodItem.
@freezed
class FoodItem with _$FoodItem {
  const factory FoodItem({
    required String id,
    required String name,
    String? amount,
    required int calories,
    required double proteinG,
    required double carbsG,
    required double fatG,
    required int sortOrder,
  }) = _FoodItem;

  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      _$FoodItemFromJson(json);
}

/// 공통 기록 카드(홈/캘린더/기록 공용) — openapi FoodRecordCard.
@freezed
class FoodRecordCard with _$FoodRecordCard {
  const factory FoodRecordCard({
    required String id,
    required String title,
    String? imageUrl,
    required MealType mealType,
    required DateTime eatenAt,
    required int totalCalories,
    required Macros macros,
    String? memo,
    required bool publishedToFeed,
    required int likeCount,
    required int commentCount,
    @Default(<FoodItem>[]) List<FoodItem> items,
  }) = _FoodRecordCard;

  factory FoodRecordCard.fromJson(Map<String, dynamic> json) =>
      _$FoodRecordCardFromJson(json);
}
