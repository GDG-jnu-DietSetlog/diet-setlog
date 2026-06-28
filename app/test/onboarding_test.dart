import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:diet_setlog/core/calorie.dart';
import 'package:diet_setlog/core/providers.dart';
import 'package:diet_setlog/data/api/profile_api.dart';
import 'package:diet_setlog/data/models/enums.dart';
import 'package:diet_setlog/data/models/profile.dart';
import 'package:diet_setlog/features/onboarding/onboarding_controller.dart';
import 'package:diet_setlog/features/session/session_providers.dart';

class FakeProfileApi implements ProfileApi {
  ProfileResponse getResult =
      const ProfileResponse(dailyCalorieTarget: 0, weeklyWeightDelta: 0);
  ProfileResponse? putResult;
  ProfileUpsertRequest? lastPutRequest;
  bool throwOnPut = false;
  bool throwOnGet = false;

  @override
  Future<ProfileResponse> getProfile() async {
    if (throwOnGet) throw Exception('boom');
    return getResult;
  }

  @override
  Future<ProfileResponse> putProfile(ProfileUpsertRequest req) async {
    lastPutRequest = req;
    if (throwOnPut) throw Exception('boom');
    return putResult ?? getResult;
  }
}

void main() {
  group('OnboardingDraft validation (spec-lock §7)', () {
    test('step1 requires 1~50 char name', () {
      expect(const OnboardingDraft(displayName: '').step1Valid, isFalse);
      expect(const OnboardingDraft(displayName: '서진').step1Valid, isTrue);
    });

    test('step1: 공백만 있는 이름은 무효, 50자 경계', () {
      expect(const OnboardingDraft(displayName: '   ').step1Valid, isFalse);
      final name50 = 'a' * 50;
      final name51 = 'a' * 51;
      expect(OnboardingDraft(displayName: name50).step1Valid, isTrue);
      expect(OnboardingDraft(displayName: name51).step1Valid, isFalse);
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

    test('step2 경계값 검증', () {
      const base = OnboardingDraft(
        gender: Gender.female,
        birthYear: 1990,
        heightCm: 170,
        currentWeightKg: 60,
      );
      // birthYear: 1920 ~ (올해-14)
      final maxYear = DateTime.now().year - 14;
      expect(base.copyWith(birthYear: 1920).step2Valid, isTrue);
      expect(base.copyWith(birthYear: 1919).step2Valid, isFalse);
      expect(base.copyWith(birthYear: maxYear).step2Valid, isTrue);
      expect(
          base.copyWith(birthYear: maxYear + 1).step2Valid, isFalse); // 14세 미만
      // heightCm: 80 ~ 250
      expect(base.copyWith(heightCm: 80).step2Valid, isTrue);
      expect(base.copyWith(heightCm: 79).step2Valid, isFalse);
      expect(base.copyWith(heightCm: 250).step2Valid, isTrue);
      expect(base.copyWith(heightCm: 251).step2Valid, isFalse);
      // currentWeightKg: 20 ~ 400
      expect(base.copyWith(currentWeightKg: 20).step2Valid, isTrue);
      expect(base.copyWith(currentWeightKg: 19).step2Valid, isFalse);
      expect(base.copyWith(currentWeightKg: 400).step2Valid, isTrue);
      expect(base.copyWith(currentWeightKg: 401).step2Valid, isFalse);
    });

    test('step3 requires target weight + date', () {
      final ok = OnboardingDraft(
        targetWeightKg: 62,
        targetDate: DateTime(2026, 9, 30),
      );
      expect(ok.step3Valid, isTrue);
      expect(const OnboardingDraft(targetWeightKg: 62).step3Valid, isFalse);
    });

    test('step3 경계: 무게 범위 + 날짜 누락', () {
      final d = DateTime(2026, 9, 30);
      expect(OnboardingDraft(targetWeightKg: 20, targetDate: d).step3Valid,
          isTrue);
      expect(OnboardingDraft(targetWeightKg: 19, targetDate: d).step3Valid,
          isFalse);
      expect(OnboardingDraft(targetWeightKg: 400, targetDate: d).step3Valid,
          isTrue);
      expect(OnboardingDraft(targetWeightKg: 401, targetDate: d).step3Valid,
          isFalse);
    });
  });

  group('OnboardingDraftNotifier 입력 핸들링', () {
    ProviderContainer makeContainer(FakeProfileApi fake) {
      final c = ProviderContainer(
        overrides: [profileApiProvider.overrideWithValue(fake)],
      );
      addTearDown(c.dispose);
      return c;
    }

    test('null 설정 setter 들은 값을 비운다(copyWith 가 아닌 풀 재생성 이유)', () {
      final c = makeContainer(FakeProfileApi());
      final n = c.read(onboardingDraftProvider.notifier);

      n.setBirthYear(1990);
      n.setHeight(170);
      n.setCurrentWeight(65);
      n.setTargetWeight(60);
      expect(c.read(onboardingDraftProvider).birthYear, 1990);

      n.setBirthYear(null);
      n.setHeight(null);
      n.setCurrentWeight(null);
      n.setTargetWeight(null);
      final d = c.read(onboardingDraftProvider);
      expect(d.birthYear, isNull);
      expect(d.heightCm, isNull);
      expect(d.currentWeightKg, isNull);
      expect(d.targetWeightKg, isNull);
    });

    test('setName/setGender/setTargetDate 반영', () {
      final c = makeContainer(FakeProfileApi());
      final n = c.read(onboardingDraftProvider.notifier);
      n.setName('지민');
      n.setGender(Gender.female);
      n.setTargetDate(DateTime(2026, 12, 1));
      final d = c.read(onboardingDraftProvider);
      expect(d.displayName, '지민');
      expect(d.gender, Gender.female);
      expect(d.targetDate, DateTime(2026, 12, 1));
    });

    test('submit 성공: 요청 직렬화(YYYY-MM-DD) + profile 상태 갱신', () async {
      final fake = FakeProfileApi()
        ..putResult = const ProfileResponse(
          profile: Profile(
            displayName: '서진',
            gender: Gender.male,
            birthYear: 1996,
            heightCm: 175,
            currentWeightKg: 70,
            targetWeightKg: 62,
            targetDate: '2026-09-05',
          ),
          dailyCalorieTarget: 2000,
          weeklyWeightDelta: -0.5,
        );
      final c = makeContainer(fake);
      final n = c.read(onboardingDraftProvider.notifier);
      n.setName('  서진  '); // trim 확인
      n.setGender(Gender.male);
      n.setBirthYear(1996);
      n.setHeight(175);
      n.setCurrentWeight(70);
      n.setTargetWeight(62);
      n.setTargetDate(DateTime(2026, 9, 5)); // 한 자리 월/일 → 0 패딩

      final res = await n.submit();

      expect(res.dailyCalorieTarget, 2000);
      // 요청 직렬화 확인
      expect(fake.lastPutRequest!.displayName, '서진'); // trim 됨
      expect(fake.lastPutRequest!.targetDate, '2026-09-05');
      // profile 전역 상태 갱신
      expect(c.read(profileStateProvider)!.profile!.targetWeightKg, 62);
    });

    test('submit 실패: 예외 전파 + profile 상태 미변경', () async {
      final fake = FakeProfileApi()..throwOnPut = true;
      final c = makeContainer(fake);
      final n = c.read(onboardingDraftProvider.notifier);
      n.setName('서진');
      n.setGender(Gender.male);
      n.setBirthYear(1996);
      n.setHeight(175);
      n.setCurrentWeight(70);
      n.setTargetWeight(62);
      n.setTargetDate(DateTime(2026, 9, 5));

      await expectLater(n.submit(), throwsA(isA<Exception>()));
      expect(c.read(profileStateProvider), isNull); // 갱신 안 됨
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
