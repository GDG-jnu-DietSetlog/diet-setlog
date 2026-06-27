import '../data/models/enums.dart';

/// 권장 칼로리 미리보기(STEP3 AI 카드용). 서버 `lib/calorie.ts` 와 동일 상수/식으로
/// 계산해 미리 보여주되, 저장 후 권위값은 PUT 응답의 dailyCalorieTarget 을 따른다.
/// spec-lock §7·§8 / §13.5-1(other=−78).
class CalorieEstimate {
  const CalorieEstimate(
      {required this.dailyCalorieTarget, required this.weeklyWeightDelta});
  final int dailyCalorieTarget;
  final double weeklyWeightDelta;
}

const double _activityFactor = 1.4;
const double _kcalPerKg = 7700;
const int _calMin = 1200;
const int _calMax = 5000;

double _bmr(Gender g, double kg, double cm, int age) {
  final base = 10 * kg + 6.25 * cm - 5 * age;
  return switch (g) {
    Gender.male => base + 5,
    Gender.female => base - 161,
    Gender.other => base - 78,
  };
}

/// today 기본값은 DateTime.now(). 권위값은 서버.
CalorieEstimate estimateCalories({
  required Gender gender,
  required int birthYear,
  required double heightCm,
  required double currentWeightKg,
  required double targetWeightKg,
  required DateTime targetDate,
  DateTime? today,
}) {
  final now = today ?? DateTime.now();
  final age = now.year - birthYear;
  final tdee = _bmr(gender, currentWeightKg, heightCm, age) * _activityFactor;

  const msPerWeek = 7 * 24 * 60 * 60 * 1000;
  final weeks =
      ((targetDate.millisecondsSinceEpoch - now.millisecondsSinceEpoch) /
              msPerWeek)
          .clamp(1, double.infinity);
  final weeklyWeightDelta = (targetWeightKg - currentWeightKg) / weeks;
  final dailyAdjust = (weeklyWeightDelta * _kcalPerKg) / 7;

  final target = (tdee + dailyAdjust).round().clamp(_calMin, _calMax);
  return CalorieEstimate(
      dailyCalorieTarget: target, weeklyWeightDelta: weeklyWeightDelta);
}
