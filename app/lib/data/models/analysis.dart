import 'package:freezed_annotation/freezed_annotation.dart';
import 'common.dart';
import 'enums.dart';

part 'analysis.freezed.dart';
part 'analysis.g.dart';

/// 분석 결과 항목 — openapi AnalysisResult.items[] (id 없음, 기록 항목과 구분).
@freezed
class AnalysisItem with _$AnalysisItem {
  const factory AnalysisItem({
    required String name,
    String? amount,
    required int calories,
    required double proteinG,
    required double carbsG,
    required double fatG,
  }) = _AnalysisItem;

  factory AnalysisItem.fromJson(Map<String, dynamic> json) =>
      _$AnalysisItemFromJson(json);
}

/// openapi AnalysisResult (completed 일 때).
@freezed
class AnalysisResult with _$AnalysisResult {
  const factory AnalysisResult({
    required String dishName,
    required int totalCalories,
    required Macros macros,
    @Default(<AnalysisItem>[]) List<AnalysisItem> items,
    required double confidence,
    String? notes,
  }) = _AnalysisResult;

  factory AnalysisResult.fromJson(Map<String, dynamic> json) =>
      _$AnalysisResultFromJson(json);
}

/// openapi AnalysisResponse — processing/completed/failed 통합.
@freezed
class AnalysisResponse with _$AnalysisResponse {
  const factory AnalysisResponse({
    required String analysisId,
    required AnalysisStatus status,
    required String imageUrl,
    AnalysisResult? result, // completed
    bool? needsReview, // completed
    String? errorCode, // failed
    String? message, // failed
  }) = _AnalysisResponse;

  factory AnalysisResponse.fromJson(Map<String, dynamic> json) =>
      _$AnalysisResponseFromJson(json);
}
