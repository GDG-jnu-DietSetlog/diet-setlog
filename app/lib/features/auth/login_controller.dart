import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import '../../core/providers.dart';
import '../session/session_providers.dart';

/// 카카오 로그인 플로우 컨트롤러 — api-db-design §1.5.
/// SDK 로그인 → accessToken → 서버 `/sessions/kakao` → 토큰 저장/주입 → 프로필 조회.
class LoginController {
  LoginController(this._ref);
  final Ref _ref;

  /// 카카오로 로그인하고 다음 목적지(home/onboarding)를 반환한다.
  /// 사용자가 취소하면 [KakaoAuthCancelled] 를 던진다.
  Future<BootDestination> signInWithKakao() async {
    final OAuthToken token = await _kakaoLogin();

    final session =
        await _ref.read(sessionApiProvider).loginWithKakao(token.accessToken);

    final storage = _ref.read(tokenStorageProvider);
    await storage.save(token: session.sessionToken, userId: session.userId);
    _ref.read(tokenHolderProvider).token = session.sessionToken;
    _ref.read(currentUserIdProvider.notifier).state = session.userId;

    // 프로필 유무로 온보딩/홈 분기 (게스트 승격 시 프로필이 이미 있을 수 있음).
    return resolveSession(_ref);
  }

  /// 카카오톡 앱이 있으면 앱으로, 없으면 카카오계정(웹)으로 로그인.
  Future<OAuthToken> _kakaoLogin() async {
    try {
      if (await isKakaoTalkInstalled()) {
        try {
          return await UserApi.instance.loginWithKakaoTalk();
        } on KakaoAuthException {
          // 카톡 로그인 동의 취소 등 → 계정 로그인으로 폴백.
          return await UserApi.instance.loginWithKakaoAccount();
        } catch (_) {
          // 카톡 미설치/실행 실패 등 → 계정 로그인으로 폴백.
          return await UserApi.instance.loginWithKakaoAccount();
        }
      }
      return await UserApi.instance.loginWithKakaoAccount();
    } on KakaoAuthException catch (e) {
      if (e.error == AuthErrorCause.accessDenied) {
        throw const KakaoAuthCancelled();
      }
      rethrow;
    }
  }
}

/// 사용자가 카카오 동의를 취소했을 때.
class KakaoAuthCancelled implements Exception {
  const KakaoAuthCancelled();
}

final loginControllerProvider =
    Provider<LoginController>((ref) => LoginController(ref));
