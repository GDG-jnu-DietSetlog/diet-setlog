# diet-setlog

다이어트/운동 **식단 기록 + AI 분석** 모바일 앱. 음식 사진을 찍으면 Gemini가 칼로리·영양을 분석하고,
기록을 캘린더로 모아 보며 친구들과 피드로 인증·응원한다.

**핵심 플로우** — 익명 세션 → 프로필 온보딩 → 홈 → 촬영/갤러리 → Gemini 분석 → 기록 작성 → 캘린더 → 피드(좋아요·댓글)

> 크로스플랫폼(Android·iOS·Web) Flutter 앱 + Node/TypeScript 백엔드 모노레포. 로그인 없이 익명으로 전 기능 사용(추후 OAuth 연결).

---

## 모노레포 구조

```
diet-setlog/
├── app/      # Flutter 앱 (Android · iOS · Web)        — app/README.md
├── server/   # Node + TypeScript 백엔드 (Express)      — server/README.md
├── docs/     # 설계·계약·리서치·의사결정(ADR)          — docs/README.md
└── .claude/  # Claude Code 설정
```

## 기술 스택

| 영역 | 스택 |
|---|---|
| **앱** | Flutter 3.24 · Dart 3.5 · Riverpod · go_router · dio · freezed · flutter_screenutil · image_picker |
| **서버** | Node 20 · TypeScript · Express · Prisma · PostgreSQL · Redis · BullMQ(큐) · GCS(이미지) · Gemini(분석) |
| **계약** | OpenAPI 3.1 (서버가 단일 진실원, Dart 모델은 계약에 맞춰 작성) |

## 빠른 시작

### 1) 백엔드 (Docker 한 방)
```bash
cd server
cp .env.example .env        # 필요 시 값 채우기 (Gemini 키 없으면 분석은 mock)
docker compose up --build   # PostgreSQL + Redis + GCS에뮬 + 서버(:3000)
```
자세한 내용·env·시드: [server/README.md](server/README.md)

### 2) 앱
```bash
cd app
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # freezed/json 모델 생성
flutter run                                                # 연결된 기기/에뮬레이터
# 웹으로 보기:
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:3000/v1
```
> Android 에뮬레이터에서 호스트 서버를 부를 땐 `--dart-define=API_BASE_URL=http://10.0.2.2:3000/v1`.

자세한 내용·구조·명령: [app/README.md](app/README.md)

## API 계약 (단일 진실원)

전 엔드포인트의 요청/응답은 **[docs/plans/openapi.yaml](docs/plans/openapi.yaml)** 에 기계 판독본으로 정의돼 있다.
산문 설계·확정값은 [docs/plans/spec-lock.md](docs/plans/spec-lock.md).

## 문서 길찾기

| 문서 | 내용 |
|---|---|
| [docs/README.md](docs/README.md) | 문서 전체 인덱스 |
| [docs/plans/README.md](docs/plans/README.md) | 구현 계획 · API/DB 설계 · 화면 스펙 · 디자인 시스템 |
| [docs/research/README.md](docs/research/README.md) | 친구추천·CI 등 리서치 |
| [docs/decisions/README.md](docs/decisions/README.md) | 확정 결정(ADR) |
| [CONTRIBUTING.md](CONTRIBUTING.md) | 브랜치·커밋·PR 규칙 |
| [CLAUDE.md](CLAUDE.md) | Claude Code용 프로젝트 지침 |

## 상태

- ✅ v1 구현 완료 — 화면 12개 + 피드(좋아요·댓글), 모바일·웹 빌드.
- 🔜 Google/Kakao 로그인으로 익명 계정 연결.

기여 전 [CONTRIBUTING.md](CONTRIBUTING.md)의 브랜치·커밋 컨벤션을 확인한다.
