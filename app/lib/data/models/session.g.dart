// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GuestSessionImpl _$$GuestSessionImplFromJson(Map<String, dynamic> json) =>
    _$GuestSessionImpl(
      userId: json['userId'] as String,
      sessionToken: json['sessionToken'] as String,
      isNewUser: json['isNewUser'] as bool,
    );

Map<String, dynamic> _$$GuestSessionImplToJson(_$GuestSessionImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'sessionToken': instance.sessionToken,
      'isNewUser': instance.isNewUser,
    };
