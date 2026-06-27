import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

/// 프로필 — openapi Profile. targetDate 는 date-only 문자열(YYYY-MM-DD).
@freezed
class Profile with _$Profile {
  const factory Profile({
    required String displayName,
    required Gender gender,
    required int birthYear,
    required double heightCm,
    required double currentWeightKg,
    required double targetWeightKg,
    required String targetDate,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}

/// openapi ProfileResponse. profile 없으면 null + target/delta 0.
@freezed
class ProfileResponse with _$ProfileResponse {
  const factory ProfileResponse({
    Profile? profile,
    required int dailyCalorieTarget,
    required double weeklyWeightDelta,
  }) = _ProfileResponse;

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);
}

/// PUT /v1/me/profile 요청 바디 — openapi ProfileUpsertRequest.
@freezed
class ProfileUpsertRequest with _$ProfileUpsertRequest {
  const factory ProfileUpsertRequest({
    required String displayName,
    required Gender gender,
    required int birthYear,
    required double heightCm,
    required double currentWeightKg,
    required double targetWeightKg,
    required String targetDate,
  }) = _ProfileUpsertRequest;

  factory ProfileUpsertRequest.fromJson(Map<String, dynamic> json) =>
      _$ProfileUpsertRequestFromJson(json);
}
