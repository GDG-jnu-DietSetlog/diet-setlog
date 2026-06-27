// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailySummaryImpl _$$DailySummaryImplFromJson(Map<String, dynamic> json) =>
    _$DailySummaryImpl(
      date: json['date'] as String,
      calorieTarget: (json['calorieTarget'] as num).toInt(),
      totalCalories: (json['totalCalories'] as num).toInt(),
      macros: Macros.fromJson(json['macros'] as Map<String, dynamic>),
      remainingCalories: (json['remainingCalories'] as num).toInt(),
      progressRatio: (json['progressRatio'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$$DailySummaryImplToJson(_$DailySummaryImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'calorieTarget': instance.calorieTarget,
      'totalCalories': instance.totalCalories,
      'macros': instance.macros,
      'remainingCalories': instance.remainingCalories,
      'progressRatio': instance.progressRatio,
    };

_$CertifiedFriendImpl _$$CertifiedFriendImplFromJson(
        Map<String, dynamic> json) =>
    _$CertifiedFriendImpl(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      certifiedAt: DateTime.parse(json['certifiedAt'] as String),
    );

Map<String, dynamic> _$$CertifiedFriendImplToJson(
        _$CertifiedFriendImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
      'certifiedAt': instance.certifiedAt.toIso8601String(),
    };

_$HomeResponseImpl _$$HomeResponseImplFromJson(Map<String, dynamic> json) =>
    _$HomeResponseImpl(
      currentUser:
          UserRef.fromJson(json['currentUser'] as Map<String, dynamic>),
      todaySummary:
          DailySummary.fromJson(json['todaySummary'] as Map<String, dynamic>),
      friendsCertifiedToday: (json['friendsCertifiedToday'] as List<dynamic>?)
              ?.map((e) => CertifiedFriend.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <CertifiedFriend>[],
      recentRecords: (json['recentRecords'] as List<dynamic>?)
              ?.map((e) => FoodRecordCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <FoodRecordCard>[],
    );

Map<String, dynamic> _$$HomeResponseImplToJson(_$HomeResponseImpl instance) =>
    <String, dynamic>{
      'currentUser': instance.currentUser,
      'todaySummary': instance.todaySummary,
      'friendsCertifiedToday': instance.friendsCertifiedToday,
      'recentRecords': instance.recentRecords,
    };
