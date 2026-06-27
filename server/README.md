# server — diet-setlog 백엔드

익명 세션(JWT) 기반 REST API + 분석 큐 워커. 음식 이미지를 GCS에 올리고 Gemini로 분석한다.
전 엔드포인트 계약은 [../docs/plans/openapi.yaml](../docs/plans/openapi.yaml)(단일 진실원).

- **요구**: Node **20 LTS** · Docker(권장 실행 방식) · TypeScript(ES 모듈, 2-space)
- **스택**: Express · Prisma · PostgreSQL · Redis · BullMQ(분석 큐) · `@google-cloud/storage`(GCS) · `@google/generative-ai`(Gemini)

## 실행

### Docker (권장 — 한 방에 DB+Redis+GCS+서버)
```bash
cp .env.example .env          # 필요 시 값 채우기
docker compose up --build     # postgres + redis + fake-gcs + server(:3000)
# 컨테이너 시작 시 prisma migrate deploy 자동 수행
```
헬스체크: `GET http://localhost:3000/health` → `{ "ok": true }`

### 로컬(Node 직접) — DB/Redis/GCS는 별도 필요
```bash
npm install
npm run prisma:migrate        # 마이그레이션
npm run prisma:seed           # 시드(추천용 사용자 30명)
npm run dev                   # tsx watch
```

## 환경변수 (`.env.example` 참고)

| 키 | 설명 |
|---|---|
| `DATABASE_URL` | PostgreSQL 연결 문자열 |
| `JWT_SECRET` | HS256 서명 키(최소 8자) |
| `PORT` | 서버 포트(기본 3000) |
| `APP_TZ` | 타임존(`Asia/Seoul` 고정) |
| `REDIS_URL` | Redis(큐·캐시) |
| `GCS_PROJECT_ID` · `GCS_BUCKET` · `GCS_API_ENDPOINT` · `GCS_PUBLIC_URL` | 이미지 스토리지(로컬은 fake-gcs 에뮬레이터) |
| `GEMINI_API_KEY` *(선택)* | 미설정 시 **mock 분석**으로 동작, 설정 시 live |

> 시크릿은 절대 커밋하지 않는다(`.env`는 gitignore).

## 스크립트

| 명령 | 설명 |
|---|---|
| `npm run dev` | 개발 서버(tsx watch) |
| `npm run build` | TypeScript 컴파일 |
| `npm test` | 테스트(vitest) |
| `npm run lint` | ESLint |
| `npm run prisma:migrate` / `:seed` / `:generate` | Prisma 마이그레이션 · 시드 · 클라이언트 생성 |

## 구성 요소

- **인증**: 익명 게스트 세션 발급(`POST /v1/sessions/guest`) → `Authorization: Bearer <JWT>`.
- **분석 파이프라인**: 이미지 업로드 → GCS 저장 → BullMQ 큐 → Gemini 분석 → 폴링(`GET /v1/food-analyses/{id}`).
- **캐시/스파이크 대응**: Redis 캐싱 + 커서 페이지네이션(무상태 설계).

## 계약 · 설계

- API 계약(기계 판독): [../docs/plans/openapi.yaml](../docs/plans/openapi.yaml)
- 확정값·스키마: [../docs/plans/spec-lock.md](../docs/plans/spec-lock.md) · DB/흐름 [../docs/plans/api-db-design.md](../docs/plans/api-db-design.md)
- 앱 실행: [../app/README.md](../app/README.md)
