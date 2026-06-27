import 'package:freezed_annotation/freezed_annotation.dart';
import 'common.dart';
import 'enums.dart';
import 'food_record.dart';
import 'home.dart';

part 'record_create.freezed.dart';
part 'record_create.g.dart';

/// 기록 작성 항목 입력 — openapi RecordCreateRequest.items[] (id 없이 전송).
@freezed
class ItemInput with _$ItemInput {
  const factory ItemInput({
    required String name,
    String? amount,
    required int calories,
    required double proteinG,
    required double carbsG,
    required double fatG,
  }) = _ItemInput;

  factory ItemInput.fromJson(Map<String, dynamic> json) =>
      _$ItemInputFromJson(json);
}

/// POST /v1/food-records 요청 바디 — openapi RecordCreateRequest.
@freezed
class RecordCreateRequest with _$RecordCreateRequest {
  const factory RecordCreateRequest({
    String? analysisId,
    required MealType mealType,
    required DateTime eatenAt,
    required String title,
    required int totalCalories,
    required Macros macros,
    String? memo,
    @Default(<ItemInput>[]) List<ItemInput> items,
    required bool publishToFeed,
  }) = _RecordCreateRequest;

  factory RecordCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$RecordCreateRequestFromJson(json);
}

/// openapi RecordCreateResponse.
@freezed
class RecordCreateResponse with _$RecordCreateResponse {
  const factory RecordCreateResponse({
    required String recordId,
    required FoodRecordCard record,
    required DailySummary dailySummary,
  }) = _RecordCreateResponse;

  factory RecordCreateResponse.fromJson(Map<String, dynamic> json) =>
      _$RecordCreateResponseFromJson(json);
}
