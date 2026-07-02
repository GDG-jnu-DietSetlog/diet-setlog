import 'package:diet_setlog/core/providers.dart';
import 'package:diet_setlog/data/api/profile_api.dart';
import 'package:diet_setlog/data/models/profile.dart';
import 'package:diet_setlog/features/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Onboarding profile flow renders core v2 fields on 390x844',
      (tester) async {
    await _setPhoneSurface(tester);

    await tester.pumpWidget(
      _TestApp(
        overrides: [
          profileApiProvider.overrideWithValue(_FakeProfileApi()),
        ],
        child: const OnboardingScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('프로필 설정'), findsOneWidget);
    expect(find.text('STEP 1/3'), findsOneWidget);
    expect(find.text('이름을 설정해주세요'), findsOneWidget);
    expect(find.text('0/50자'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '서진');
    await tester.pumpAndSettle();
    expect(find.text('2/50자'), findsOneWidget);

    await tester.tap(find.text('다음'));
    await tester.pumpAndSettle();

    expect(find.text('STEP 2/3'), findsOneWidget);
    expect(find.text('기본 정보를\n알려주세요'), findsOneWidget);
    expect(find.text('성별'), findsOneWidget);
    expect(find.text('출생연도'), findsOneWidget);
    expect(find.text('키'), findsOneWidget);
    expect(find.text('현재 몸무게'), findsOneWidget);

    await tester.tap(find.text('남성'));
    await tester.enterText(find.byType(TextField).at(0), '1996');
    await tester.enterText(find.byType(TextField).at(1), '175');
    await tester.enterText(find.byType(TextField).at(2), '70');
    await tester.pumpAndSettle();

    await tester.tap(find.text('다음'));
    await tester.pumpAndSettle();

    expect(find.text('STEP 3/3'), findsOneWidget);
    expect(find.text('목표를\n설정해주세요'), findsOneWidget);
    expect(find.text('목표 몸무게'), findsOneWidget);
    expect(find.text('목표 날짜'), findsOneWidget);
    expect(find.text('AI가 계산한 맞춤 목표'), findsOneWidget);
    expect(find.text('시작하기'), findsOneWidget);
  });
}

Future<void> _setPhoneSurface(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(390, 844);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  return Future<void>.value();
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child, required this.overrides});

  final Widget child;
  final List<Override> overrides;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: overrides,
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, _) => MaterialApp(home: child),
      ),
    );
  }
}

class _FakeProfileApi implements ProfileApi {
  @override
  Future<ProfileResponse> getProfile() async =>
      const ProfileResponse(dailyCalorieTarget: 0, weeklyWeightDelta: 0);

  @override
  Future<ProfileResponse> putProfile(ProfileUpsertRequest req) async =>
      const ProfileResponse(dailyCalorieTarget: 1800, weeklyWeightDelta: -0.5);
}
