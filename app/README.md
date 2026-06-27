# app — diet-setlog Flutter 앱

다이어트/식단 기록 모바일 앱(Android · iOS · Web). 디자인은 Figma "프롭 팀" 기준,
API 계약은 [../docs/plans/openapi.yaml](../docs/plans/openapi.yaml)을 따른다.

- **요구 버전**: Flutter **3.24.x** (stable) · Dart **3.5.x**
- **상태관리** Riverpod · **라우팅** go_router · **HTTP** dio · **모델** freezed/json_serializable · **반응형** flutter_screenutil(390×844)

## 폴더 구조 (`lib/`)

```
lib/
├── core/       # env·dio 클라이언트(인터셉터)·secure storage·에러 매핑·calorie/date 유틸
├── design/     # 디자인 토큰(색·타이포·간격) + 공통 위젯(버튼·입력·바텀네비·영양 카드 …)
├── data/       # freezed 모델(openapi 1:1) + 엔드포인트별 API 서비스
├── features/   # 도메인별 화면 + provider (session·onboarding·home·friends·analysis·record·calendar·feed)
└── routing/    # go_router(부트스트랩 분기 + bottom-nav shell)
```

## 명령

```bash
flutter pub get                                            # 의존성
dart run build_runner build --delete-conflicting-outputs   # freezed/json 코드 생성(모델 변경 시)

flutter run                                                # 기기/에뮬레이터(Android·iOS)
flutter run -d chrome                                       # 웹 미리보기

flutter analyze                                            # 정적 분석(커밋 전 통과)
flutter test                                               # 단위·위젯 테스트
dart format .                                              # 포맷
```

## 설정

- **API base URL**: 기본 `http://localhost:3000/v1`. 빌드 시 override —
  `--dart-define=API_BASE_URL=...`
  - Android 에뮬레이터 → `http://10.0.2.2:3000/v1`
  - 웹/iOS 시뮬레이터 → `http://localhost:3000/v1`
- **폰트**: Pretendard(`assets/fonts/`, 전 화면 공통)
- **아이콘**: iconify_flutter, **반응형**: screenutil `designSize: Size(390, 844)`
- **이미지**: 카메라/갤러리는 바이트(`Uint8List`)로 처리 → 모바일·웹 공용

## 디자인 · 계약

- 화면 스펙·디자인 토큰: [../docs/plans/screens.md](../docs/plans/screens.md) · [../docs/plans/design-system.md](../docs/plans/design-system.md)
- API 계약(단일 진실원): [../docs/plans/openapi.yaml](../docs/plans/openapi.yaml) · 확정값 [../docs/plans/spec-lock.md](../docs/plans/spec-lock.md)
- 백엔드 실행: [../server/README.md](../server/README.md)
