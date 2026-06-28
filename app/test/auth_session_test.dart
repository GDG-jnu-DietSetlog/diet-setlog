import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:diet_setlog/core/api/dio_client.dart';
import 'package:diet_setlog/core/providers.dart';
import 'package:diet_setlog/core/storage/token_storage.dart';
import 'package:diet_setlog/data/api/profile_api.dart';
import 'package:diet_setlog/data/models/enums.dart';
import 'package:diet_setlog/data/models/profile.dart';
import 'package:diet_setlog/features/auth/login_controller.dart';
import 'package:diet_setlog/features/session/session_providers.dart';

// NOTE: LoginController.signInWithKakao 는 정적 Kakao SDK 호출
// (isKakaoTalkInstalled / UserApi.instance) 에 의존하며 플랫폼 채널을 직접 친다.
// 주입 가능한 의존성이 아니므로 그 메서드 자체는 단위 테스트 대상에서 제외한다.
// 대신 로그인 직후의 실제 분기 로직(resolveSession/bootstrap)을 검증한다.

class FakeTokenStorage implements TokenStorage {
  FakeTokenStorage({this.token, this.userId});
  String? token;
  String? userId;
  String? savedToken;
  String? savedUserId;

  @override
  Future<String?> readToken() async => token;

  @override
  Future<String?> readUserId() async => userId;

  @override
  Future<void> save({required String token, required String userId}) async {
    savedToken = token;
    savedUserId = userId;
  }

  @override
  Future<void> clear() async {
    token = null;
    userId = null;
  }
}

class FakeProfileApi implements ProfileApi {
  FakeProfileApi(this.getResult);
  ProfileResponse getResult;
  bool throwOnGet = false;

  @override
  Future<ProfileResponse> getProfile() async {
    if (throwOnGet) throw Exception('boom');
    return getResult;
  }

  @override
  Future<ProfileResponse> putProfile(ProfileUpsertRequest req) async =>
      throw UnimplementedError();
}

const _profile = Profile(
  displayName: '서진',
  gender: Gender.male,
  birthYear: 1996,
  heightCm: 175,
  currentWeightKg: 70,
  targetWeightKg: 62,
  targetDate: '2026-09-05',
);

ProviderContainer _container({
  required FakeTokenStorage storage,
  required FakeProfileApi profile,
  SessionTokenHolder? holder,
}) {
  final c = ProviderContainer(overrides: [
    tokenStorageProvider.overrideWithValue(storage),
    profileApiProvider.overrideWithValue(profile),
    if (holder != null) tokenHolderProvider.overrideWithValue(holder),
  ]);
  addTearDown(c.dispose);
  return c;
}

void main() {
  group('bootstrapProvider 분기', () {
    test('토큰 없음 → login (프로필 조회하지 않음)', () async {
      final profileApi = FakeProfileApi(
        const ProfileResponse(dailyCalorieTarget: 0, weeklyWeightDelta: 0),
      )..throwOnGet = true; // 호출되면 실패하도록 → 호출 안 됨을 보장
      final c = _container(
        storage: FakeTokenStorage(token: null),
        profile: profileApi,
      );

      final dest = await c.read(bootstrapProvider.future);
      expect(dest, BootDestination.login);
    });

    test('빈 토큰 → login', () async {
      final c = _container(
        storage: FakeTokenStorage(token: ''),
        profile: FakeProfileApi(
          const ProfileResponse(dailyCalorieTarget: 0, weeklyWeightDelta: 0),
        ),
      );
      expect(await c.read(bootstrapProvider.future), BootDestination.login);
    });

    test('토큰 있고 프로필 있음 → home (토큰/유저 주입)', () async {
      final holder = SessionTokenHolder();
      final c = _container(
        storage: FakeTokenStorage(token: 'tok', userId: 'u1'),
        profile: FakeProfileApi(
          const ProfileResponse(
            profile: _profile,
            dailyCalorieTarget: 2000,
            weeklyWeightDelta: -0.5,
          ),
        ),
        holder: holder,
      );

      final dest = await c.read(bootstrapProvider.future);
      expect(dest, BootDestination.home);
      expect(holder.token, 'tok'); // 메모리 홀더에 주입됨
      expect(c.read(currentUserIdProvider), 'u1');
      // resolveSession 이 profile 전역 상태도 채운다
      expect(c.read(profileStateProvider)!.profile, _profile);
    });

    test('토큰 있고 프로필 없음 → onboarding', () async {
      final c = _container(
        storage: FakeTokenStorage(token: 'tok', userId: 'u1'),
        profile: FakeProfileApi(
          const ProfileResponse(
            profile: null,
            dailyCalorieTarget: 0,
            weeklyWeightDelta: 0,
          ),
        ),
      );

      final dest = await c.read(bootstrapProvider.future);
      expect(dest, BootDestination.onboarding);
      expect(c.read(profileStateProvider)!.profile, isNull);
    });
  });

  group('LoginController 와이어링', () {
    test('loginControllerProvider 는 LoginController 를 반환', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      expect(c.read(loginControllerProvider), isA<LoginController>());
    });

    test('KakaoAuthCancelled 는 Exception 이다', () {
      expect(const KakaoAuthCancelled(), isA<Exception>());
    });
  });

  // ApiClient 가 실제로 구성되는지(스모크) — 토큰 홀더 주입 경로.
  test('ApiClient.create 는 홀더로 구성된다', () {
    final holder = SessionTokenHolder()..token = 'abc';
    final client = ApiClient.create(holder);
    expect(client.tokenHolder.token, 'abc');
  });
}
