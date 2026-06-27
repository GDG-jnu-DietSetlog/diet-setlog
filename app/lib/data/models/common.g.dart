// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MacrosImpl _$$MacrosImplFromJson(Map<String, dynamic> json) => _$MacrosImpl(
      proteinG: (json['proteinG'] as num).toDouble(),
      carbsG: (json['carbsG'] as num).toDouble(),
      fatG: (json['fatG'] as num).toDouble(),
    );

Map<String, dynamic> _$$MacrosImplToJson(_$MacrosImpl instance) =>
    <String, dynamic>{
      'proteinG': instance.proteinG,
      'carbsG': instance.carbsG,
      'fatG': instance.fatG,
    };

_$UserRefImpl _$$UserRefImplFromJson(Map<String, dynamic> json) =>
    _$UserRefImpl(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
    );

Map<String, dynamic> _$$UserRefImplToJson(_$UserRefImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
    };
