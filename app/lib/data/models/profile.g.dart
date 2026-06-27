// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileImpl _$$ProfileImplFromJson(Map<String, dynamic> json) =>
    _$ProfileImpl(
      displayName: json['displayName'] as String,
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      birthYear: (json['birthYear'] as num).toInt(),
      heightCm: (json['heightCm'] as num).toDouble(),
      currentWeightKg: (json['currentWeightKg'] as num).toDouble(),
      targetWeightKg: (json['targetWeightKg'] as num).toDouble(),
      targetDate: json['targetDate'] as String,
    );

Map<String, dynamic> _$$ProfileImplToJson(_$ProfileImpl instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'gender': _$GenderEnumMap[instance.gender]!,
      'birthYear': instance.birthYear,
      'heightCm': instance.heightCm,
      'currentWeightKg': instance.currentWeightKg,
      'targetWeightKg': instance.targetWeightKg,
      'targetDate': instance.targetDate,
    };

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.other: 'other',
};

_$ProfileResponseImpl _$$ProfileResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfileResponseImpl(
      profile: json['profile'] == null
          ? null
          : Profile.fromJson(json['profile'] as Map<String, dynamic>),
      dailyCalorieTarget: (json['dailyCalorieTarget'] as num).toInt(),
      weeklyWeightDelta: (json['weeklyWeightDelta'] as num).toDouble(),
    );

Map<String, dynamic> _$$ProfileResponseImplToJson(
        _$ProfileResponseImpl instance) =>
    <String, dynamic>{
      'profile': instance.profile,
      'dailyCalorieTarget': instance.dailyCalorieTarget,
      'weeklyWeightDelta': instance.weeklyWeightDelta,
    };

_$ProfileUpsertRequestImpl _$$ProfileUpsertRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfileUpsertRequestImpl(
      displayName: json['displayName'] as String,
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      birthYear: (json['birthYear'] as num).toInt(),
      heightCm: (json['heightCm'] as num).toDouble(),
      currentWeightKg: (json['currentWeightKg'] as num).toDouble(),
      targetWeightKg: (json['targetWeightKg'] as num).toDouble(),
      targetDate: json['targetDate'] as String,
    );

Map<String, dynamic> _$$ProfileUpsertRequestImplToJson(
        _$ProfileUpsertRequestImpl instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'gender': _$GenderEnumMap[instance.gender]!,
      'birthYear': instance.birthYear,
      'heightCm': instance.heightCm,
      'currentWeightKg': instance.currentWeightKg,
      'targetWeightKg': instance.targetWeightKg,
      'targetDate': instance.targetDate,
    };
