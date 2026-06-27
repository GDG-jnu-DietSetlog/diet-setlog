/// 앱 환경/상수. 매직넘버는 docs/plans/spec-lock.md §7 에서 잠금.
abstract final class Env {
  /// API base URL. 로컬 서버 기본값(`http://localhost:3000/v1`).
  /// Android 에뮬레이터는 호스트가 10.0.2.2 이므로 빌드 시
  /// `--dart-define=API_BASE_URL=http://10.0.2.2:3000/v1` 로 override.
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/v1',
  );

  /// 카카오 앱 키 — 빌드 시 주입(시크릿 미커밋).
  /// `--dart-define=KAKAO_NATIVE_APP_KEY=...`(모바일), `--dart-define=KAKAO_JS_KEY=...`(웹).
  /// 안드로이드 매니페스트의 `kakao{네이티브키}` 스킴은 gradle 속성으로 별도 주입(README 참고).
  static const kakaoNativeAppKey = String.fromEnvironment('KAKAO_NATIVE_APP_KEY');
  static const kakaoJsKey = String.fromEnvironment('KAKAO_JS_KEY');

  // 페이지네이션(spec-lock §7)
  static const int defaultLimit = 20;
  static const int maxLimit = 50;

  // 분석 폴링(spec-lock §7)
  static const Duration pollInitialInterval = Duration(milliseconds: 1500);
  static const double pollBackoff = 1.5;
  static const Duration pollMaxInterval = Duration(seconds: 6);
  static const int pollMaxAttempts = 20;

  // 검색 debounce
  static const Duration searchDebounce = Duration(milliseconds: 300);

  // 칼로리 clamp(표시용)
  static const int calorieMin = 1200;
  static const int calorieMax = 5000;

  // 이미지 업로드 한도
  static const int imageMaxBytes = 10 * 1024 * 1024;

  // 타임존
  static const String tz = 'Asia/Seoul';
}
