import 'package:flutter_test/flutter_test.dart';
import 'package:diet_setlog/core/calorie.dart';
import 'package:diet_setlog/data/models/enums.dart';
import 'package:diet_setlog/features/onboarding/onboarding_controller.dart';

void main() {
  group('OnboardingDraft validation (spec-lock §7)', () {
    test('step1 requires 1~50 char name', () {
      expect(const OnboardingDraft(displayName: '').step1Valid, isFalse);
      expect(const OnboardingDraft(displayName: '서진').step1Valid, isTrue);
    });

    test('step2 requires gender/birthYear/height/weight in range', () {
      const ok = OnboardingDraft(
        gender: Gender.male,
        birthYear: 1996,
        heightCm: 175,
        currentWeightKg: 70,
      );
      expect(ok.step2Valid, isTrue);
      expect(ok.copyWith(heightCm: 60).step2Valid, isFalse); // 키 범위 밖
    });

    test('step3 requires target weight + date', () {
      final ok = OnboardingDraft(
        targetWeightKg: 62,
        targetDate: DateTime(2026, 9, 30),
      );
      expect(ok.step3Valid, isTrue);
      expect(const OnboardingDraft(targetWeightKg: 62).step3Valid, isFalse);
    });
  });

  test('estimateCalories matches server formula (maintain → TDEE)', () {
    final est = estimateCalories(
      gender: Gender.male,
      birthYear: 1996,
      heightCm: 175,
      currentWeightKg: 70,
      targetWeightKg: 70, // 유지 → dailyAdjust 0
      targetDate: DateTime(2026, 9, 5),
      today: DateTime(2026, 6, 27), // age 30
    );
    // BMR=1648.75, TDEE=*1.4=2308.25 → round 2308
    expect(est.dailyCalorieTarget, 2308);
    expect(est.weeklyWeightDelta, closeTo(0, 0.0001));
  });
}
