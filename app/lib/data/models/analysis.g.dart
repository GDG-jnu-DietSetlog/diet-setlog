// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnalysisItemImpl _$$AnalysisItemImplFromJson(Map<String, dynamic> json) =>
    _$AnalysisItemImpl(
      name: json['name'] as String,
      amount: json['amount'] as String?,
      calories: (json['calories'] as num).toInt(),
      proteinG: (json['proteinG'] as num).toDouble(),
      carbsG: (json['carbsG'] as num).toDouble(),
      fatG: (json['fatG'] as num).toDouble(),
    );

Map<String, dynamic> _$$AnalysisItemImplToJson(_$AnalysisItemImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'amount': instance.amount,
      'calories': instance.calories,
      'proteinG': instance.proteinG,
      'carbsG': instance.carbsG,
      'fatG': instance.fatG,
    };

_$AnalysisResultImpl _$$AnalysisResultImplFromJson(Map<String, dynamic> json) =>
    _$AnalysisResultImpl(
      dishName: json['dishName'] as String,
      totalCalories: (json['totalCalories'] as num).toInt(),
      macros: Macros.fromJson(json['macros'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => AnalysisItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <AnalysisItem>[],
      confidence: (json['confidence'] as num).toDouble(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$AnalysisResultImplToJson(
        _$AnalysisResultImpl instance) =>
    <String, dynamic>{
      'dishName': instance.dishName,
      'totalCalories': instance.totalCalories,
      'macros': instance.macros,
      'items': instance.items,
      'confidence': instance.confidence,
      'notes': instance.notes,
    };

_$AnalysisResponseImpl _$$AnalysisResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$AnalysisResponseImpl(
      analysisId: json['analysisId'] as String,
      status: $enumDecode(_$AnalysisStatusEnumMap, json['status']),
      imageUrl: json['imageUrl'] as String,
      result: json['result'] == null
          ? null
          : AnalysisResult.fromJson(json['result'] as Map<String, dynamic>),
      needsReview: json['needsReview'] as bool?,
      errorCode: json['errorCode'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$AnalysisResponseImplToJson(
        _$AnalysisResponseImpl instance) =>
    <String, dynamic>{
      'analysisId': instance.analysisId,
      'status': _$AnalysisStatusEnumMap[instance.status]!,
      'imageUrl': instance.imageUrl,
      'result': instance.result,
      'needsReview': instance.needsReview,
      'errorCode': instance.errorCode,
      'message': instance.message,
    };

const _$AnalysisStatusEnumMap = {
  AnalysisStatus.processing: 'processing',
  AnalysisStatus.completed: 'completed',
  AnalysisStatus.failed: 'failed',
};
