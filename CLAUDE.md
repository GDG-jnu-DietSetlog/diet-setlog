# diet-setlog

다이어트/운동 세트 기록 모바일 앱. 크로스플랫폼 모바일 앱(Android + iOS) + 백엔드 API 구조.
프론트엔드는 **Flutter(Dart)**, 백엔드는 **Node + TypeScript**(권장).

## 아키텍처 (모노레포)

```
diet-setlog/
├── app/             # Flutter 모바일 앱 (Android + iOS)
│   └── lib/
├── server/          # 백엔드 API (Node + TypeScript 권장)
└── .claude/         # Claude Code 설정
```

> 아직 스캐폴딩 전입니다. 위 구조는 권장안이며, 실제로 프로젝트를 만들면
> 이 파일의 명령어 섹션을 실제 스크립트에 맞게 갱신하세요.
> (예: `flutter create app`, 서버는 별도 초기화)

## 빌드 & 실행 (스캐폴딩 후 채워넣기)

### 모바일 — Flutter (`app/`)
- 의존성 설치: `flutter pub get`
- 실행: `flutter run`  (연결된 기기/에뮬레이터)
- 안드로이드 빌드: `flutter build apk` / `flutter build appbundle`
- iOS 빌드: `flutter build ios`  (macOS + Xcode 필요)
- 포맷: `dart format .`
- 정적분석(린트): `flutter analyze`
- 테스트: `flutter test`
- 코드 생성(json_serializable 등 사용 시): `dart run build_runner build --delete-conflicting-outputs`

### 백엔드 (`server/`)
- 설치: `npm install`
- 개발 실행: `npm run dev`
- 테스트: `npm test`  (전체 스위트 대신 변경된 파일 단위로 빠르게)
- 린트: `npm run lint`
- 타입체크: `npx tsc --noEmit`

## 코드 스타일

### Flutter / Dart
- `flutter_lints`(또는 `very_good_analysis`) 규칙을 따른다 — 커밋 전 `flutter analyze` 통과.
- `dart format`으로 포맷팅 통일.
- 위젯은 작게 분리하고, 비즈니스 로직은 위젯에서 분리(상태관리 — 예: Riverpod/Bloc, 택1 후 일관 사용).
- 네트워크/모델 클래스는 불변(immutable)으로, JSON 직렬화는 코드 생성기 사용.

### 백엔드 / TypeScript
- TypeScript 우선, `any` 지양. ES 모듈, 2칸 들여쓰기.
- 비동기는 `async/await`. 입력은 zod로 검증.

### API 계약 (앱 ↔ 서버)
- Flutter(Dart)와 서버(TS)는 언어가 달라 타입을 직접 공유할 수 없다.
- **서버를 단일 진실 공급원(source of truth)** 으로 본다: OpenAPI 스펙 또는 zod 스키마로 계약을 정의하고,
  Dart 모델은 그 계약에 맞춰 작성/생성한다. 계약 변경 시 양쪽을 함께 갱신한다.

## 백엔드 — 트래픽 스파이크 대응 (중요)

하루 중 특정 시간대(예: 식사 시간, 운동 직후)에 트래픽이 몰릴 수 있다.
새 엔드포인트/기능을 만들 때 다음을 기본 전제로 한다:

- **무상태(stateless)** 설계 — 세션을 메모리에 두지 않는다(JWT 또는 외부 세션 스토어).
- **DB 커넥션 풀링** — 요청마다 새 커넥션을 열지 않는다. 서버리스면 풀러(예: PgBouncer) 고려.
- **캐싱** — 읽기 많은 조회는 캐시(예: Redis) + 적절한 TTL. 핫 경로에 불필요한 DB 조회 금지.
- **레이트 리미팅** — 사용자/IP 단위 요청 제한으로 스파이크 시 보호.
- **N+1 쿼리 금지** — 목록 응답은 페이지네이션(`?cursor=&limit=`) 필수.
- **무거운 작업은 비동기 큐로** — 푸시 알림, 집계 등은 요청 처리 흐름에서 분리.
- 부하가 예상되는 변경 시, 이 가정들을 충족하는지 스스로 점검하고 위반 시 알린다.

## 디자인

- UI 디자인은 Figma "프롭 팀" 파일 기준. Figma MCP로 프레임 스펙(색상/간격/타이포)을 읽어 Flutter 위젯으로 옮긴다.
- Figma MCP가 생성하는 예시 코드는 웹/React 기준일 수 있으므로, 토큰·치수·레이아웃을 참고해 Flutter로 재작성한다.

## 보안

- 시크릿(`.env`, API 키, 서명 키, 키스토어)은 절대 커밋하지 않는다 — `.gitignore` 확인.
- 클라이언트 입력은 서버에서 항상 검증(zod)한다 — 클라 검증만 믿지 않는다.
- 비밀번호/토큰 등 민감정보는 로그에 남기지 않는다.

## 워크플로우

- 큰 변경은 먼저 계획 모드(`/plan` 또는 Plan 에이전트)로 설계 후 실행한다.
- 변경 후 `flutter analyze`/`flutter test`(또는 서버 테스트)로 스스로 검증(루프를 닫는다)한다.
- 관련 없는 작업 사이에는 `/clear`로 컨텍스트를 정리한다.
- 커밋 메시지는 명확하게, 변경 의도를 한 줄로 요약한다.
