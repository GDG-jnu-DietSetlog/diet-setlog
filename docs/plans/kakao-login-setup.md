# 카카오 로그인 셋업 (온보딩2)

2차 시안 온보딩2(카카오 로그인) 구현에 필요한 키/설정 체크리스트.
플로우 설계: [api-db-design.md §1.5](./api-db-design.md). 시크릿은 **절대 커밋하지 않는다.**

## 1. Kakao 개발자 콘솔
1. https://developers.kakao.com 에서 앱 생성.
2. **앱 키** 확보: `네이티브 앱 키`(모바일), `JavaScript 키`(웹), `REST API 키`.
3. **플랫폼 등록**:
   - Android: 패키지명 `com.dietsetlog.diet_setlog` + 키 해시 등록.
   - iOS: 번들 ID 등록.
   - Web: 사이트 도메인 등록.
4. **카카오 로그인 활성화** + 동의 항목: 닉네임/프로필 사진(이메일·출생연도는 선택 항목으로 추가 가능).

## 2. 앱 빌드 시 키 주입 (시크릿 미커밋)
Dart 측 `KakaoSdk.init` 은 `--dart-define` 으로 주입한다 (`app/lib/core/env.dart`).

```bash
flutter run \
  --dart-define=KAKAO_NATIVE_APP_KEY=<네이티브앱키> \
  --dart-define=KAKAO_JS_KEY=<자바스크립트키> \
  --dart-define=API_BASE_URL=http://10.0.2.2:3000/v1   # 안드로이드 에뮬레이터
```

### Android — 리다이렉트 스킴
매니페스트 스킴 `kakao{네이티브앱키}` 는 gradle 속성으로 주입한다.
`app/android/local.properties`(gitignore됨)에 추가:

```properties
kakaoNativeAppKey=<네이티브앱키>
```
또는 빌드 시 `-PkakaoNativeAppKey=<네이티브앱키>`.

### iOS — URL 스킴
Xcode 빌드 설정에 사용자 정의 변수 `KAKAO_NATIVE_APP_KEY=<네이티브앱키>` 를 추가한다
(`ios/Runner/Info.plist` 가 `kakao$(KAKAO_NATIVE_APP_KEY)` 로 참조). 시크릿은 gitignore된 xcconfig 권장.

### Web
`app/web/index.html` 에 Kakao JS SDK 스크립트가 포함돼 있고, 초기화 키는
`--dart-define=KAKAO_JS_KEY` 로 전달한다.

## 3. 서버
별도 카카오 시크릿 불필요 — 앱이 받은 `accessToken` 을 서버가 카카오 `/v2/user/me` 로 검증한다
(`server/src/lib/kakao.ts`). 엔드포인트: `POST /v1/sessions/kakao` (`session.routes.ts`).
요청에 게스트 Bearer 가 함께 오면 게스트→카카오 승격(userId 유지).

## 4. 동작 확인
- 로그인 화면(온보딩2)에서 카카오 버튼 → SDK 로그인 → 서버 토큰 발급 → 프로필 없으면 프로필 설정, 있으면 홈.
- 약관/개인정보 문구 탭 → 온보딩6/7 화면.

> ⚠️ 온보딩6/7 약관/방침 본문은 오늘냠 서비스에 맞춘 **임시 초안**이다
> (`app/lib/features/auth/legal_screen.dart` 의 `kTermsSections`/`kPrivacySections`).
> 법률 검토를 거치지 않았으므로 정식 출시 전 반드시 법무 검토/교체할 것.
