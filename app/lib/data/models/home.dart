import 'package:freezed_annotation/freezed_annotation.dart';
import 'common.dart';
import 'food_record.dart';

part 'home.freezed.dart';
part 'home.g.dart';

/// 오늘 요약 — openapi DailySummary. (date 는 date-only 문자열)
@freezed
class DailySummary with _$DailySummary {
  const factory DailySummary({
    required String date,
    required int calorieTarget,
    required int totalCalories,
    required Macros macros,
    required int remainingCalories,
    @Default(0) double progressRatio,
  }) = _DailySummary;

  factory DailySummary.fromJson(Map<String, dynamic> json) =>
      _$DailySummaryFromJson(json);
}

/// 오늘 인증한 친구 — UserRef + certifiedAt.
@freezed
class CertifiedFriend with _$CertifiedFriend {
  const factory CertifiedFriend({
    required String id,
    required String displayName,
    String? avatarUrl,
    required DateTime certifiedAt,
  }) = _CertifiedFriend;

  factory CertifiedFriend.fromJson(Map<String, dynamic> json) =>
      _$CertifiedFriendFromJson(json);
}

/// openapi HomeResponse.
@freezed
class HomeResponse with _$HomeResponse {
  const factory HomeResponse({
    required UserRef currentUser,
    required DailySummary todaySummary,
    @Default(<CertifiedFriend>[]) List<CertifiedFriend> friendsCertifiedToday,
    @Default(<FoodRecordCard>[]) List<FoodRecordCard> recentRecords,
  }) = _HomeResponse;

  factory HomeResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeResponseFromJson(json);
}
