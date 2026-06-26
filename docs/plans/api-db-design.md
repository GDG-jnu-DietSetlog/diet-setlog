# diet-setlog — API 흐름 & DB 설계

> 대상: 이슈 #1 `dietsetlog-wireframe-plan.md`의 1차 구현 범위.
> 스택: **Express + TypeScript + Prisma + PostgreSQL**, 이미지 = **Google Cloud Storage**(로컬 fake-gcs-server), 분석 = Gemini `gemini-2.5-flash`. (스토리지 GCS 확정: [spec-lock §13.5-11](./spec-lock.md))
> 이 문서는 **코드가 아니라 설계(계약·흐름·스키마)** 만 다룬다. 화면/플로우 범위는 이슈 #1을 따른다.
>
> ⚠️ **확정 델타(이 문서보다 우선)**: [spec-lock.md](./spec-lock.md) + 기계 판독 계약 [openapi.yaml](./openapi.yaml). 아래 추가/변경이 반영됨:
> - 모델: `FoodRecord.memo`·`likeCount`·`commentCount`, 신규 `PostLike`·`PostComment`([spec-lock §4](./spec-lock.md)).
> - 엔드포인트 추가: `/v1/feed`·`/v1/posts/{id}/like`·`/v1/posts/{id}/comments`([spec-lock §5.2](./spec-lock.md)).
> - `PUT /v1/me/profile` 바디에 `displayName` 추가, `POST /v1/food-records` 바디에 `memo?` 추가([spec-lock §5.3](./spec-lock.md)).
> - 중첩 응답 객체(todaySummary·recentRecords·record·dailySummary 등) 필드 확정([spec-lock §6](./spec-lock.md)).
> - 매직넘버(레이트리밋·TTL·폴링·페이징·검증범위)·추천 상수·Gemini 프롬프트 확정([spec-lock §7~9](./spec-lock.md)).

---

## 1. 공통 규칙 (모든 API 전제)

### 1.1 인증 — 익명 sessionToken (stateless)
- 모든 protected API는 `Authorization: Bearer <sessionToken>` 를 받는다.
- `sessionToken` 은 **서버가 서명한 JWT** (HS256, 비밀키 `JWT_SECRET`).
  - payload: `{ sub: userId, ver: tokenVersion, iat }`.
  - 만료: 게스트 토큰은 기기 secure storage에 보관되는 유일 자격증명이므로 장수명(예 365일) + 슬라이딩 재발급.
- **stateless 이유**: 트래픽 스파이크 대비(메모리 세션 X). 요청마다 DB 조회 없이 서명만 검증.
- **무효화(로그아웃/탈취 대응)**: `User.tokenVersion` 과 payload `ver` 불일치 시 거부 → 토큰 일괄 폐기 가능.
- 이후 OAuth 연결 시에도 `userId` 는 유지되고 새 토큰만 재발급한다(아래 `AuthIdentity` 참고).

미들웨어 순서: `rateLimit → authGuard(JWT 검증) → handler`.
`POST /v1/sessions/guest` 만 authGuard 예외(토큰 발급 엔드포인트).

### 1.2 응답/에러 포맷
- 성공: 각 API 정의 본문(JSON).
- 에러(공통):
  ```json
  { "error": { "code": "VALIDATION_FAILED", "message": "...", "fields": { "heightCm": "out of range" } } }
  ```
- 상태코드: 400 검증, 401 토큰 없음/무효, 403 권한, 404 미존재, 409 충돌, 413 파일초과, 422 분석불가, 429 레이트리밋, 5xx 서버.
- **입력은 항상 zod로 검증**(클라 검증만 믿지 않음). 민감정보(토큰/키)는 로그 금지.

### 1.3 스파이크 대응 기본 (식사·운동 직후 몰림)
- DB 커넥션 **풀링**(Prisma `connection_limit`), 서버리스면 PgBouncer.
- 읽기 핫경로(`/v1/home`, 친구 seed)는 **Redis 캐시 + 짧은 TTL**, 쓰기 시 무효화.
- **레이트 리밋**: 사용자(userId)+IP 기준. 분석 업로드는 별도 더 빡센 버킷.
- **목록은 커서 페이지네이션**(`?cursor=&limit=`), N+1 금지(Prisma `include`/`select`).
- 무거운 작업(Gemini 호출)은 **비동기 큐**로 분리(요청 흐름 차단 X).

### 1.4 시간/날짜 처리
- 모든 timestamp는 `timestamptz`(UTC 저장).
- 캘린더/홈의 "오늘"은 **사용자 로컬 날짜** 기준. v1은 KST(`Asia/Seoul`) 고정 가정.
- `FoodRecord` 에 `eatenAt(timestamptz)` 와 함께 조회용 `eatenLocalDate(date)` 를 저장·인덱싱(캘린더 집계 가속, 타임존 경계 버그 방지).

### 1.5 로그인 — 카카오 (도입 예정)
- 앱 시작 시 **카카오톡으로 로그인**을 도입할 예정이다. (그 외 로그인 방법은 아직 논의 안 됨)
- ⚠️ **Figma에 로그인 화면 디자인이 아직 없음** → 화면 확정 후 플로우/필드 마무리. 아래는 설계 골격.
- 흐름: 카카오 SDK 로그인 → 앱이 카카오 `accessToken` 획득 → 서버에 전달 → 서버가 카카오 사용자 정보 검증 → `AuthIdentity(provider=kakao, providerUserId=kakaoId)` upsert → 연결된 `User` 에 동일한 `sessionToken`(JWT) 발급.
- **카카오 친구 추천**을 쓰려면 카카오 **친구 목록 동의(친구 scope, 비즈앱 검수)** 가 필요하다. → 친구 목록 API로 "내 카카오 친구 중 우리 앱 가입자"를 매칭한다(아래 4.6).
- **이슈 #1과의 정리(확정)**: **게스트 세션을 유지하고 카카오는 선택**으로 둔다([0001 ADR §7](../decisions/friend-recommendation/0001-recommendation-algorithm.md)). 게스트로 시작 → 친구 기능 사용 시 카카오 유도 → `AuthIdentity` 로 게스트→카카오 승격(`userId` 유지).
- `displayName`/`avatarUrl` 은 카카오 프로필에서 채운다(동의 항목 범위 내).

---

## 2. DB 설계

### 2.1 ERD (관계 요약)
```
User 1───1 Profile
User 1───N AuthIdentity        (카카오 로그인 / 추후 타 OAuth)
User 1───N FoodAnalysis
User 1───N FoodRecord 1───N FoodItem
User 1───N FriendRelation(follower)   ── FriendRelation(following) N───1 User
FoodAnalysis 1───0..1 FoodRecord      (분석 → 기록 출처 추적)
```

### 2.2 Prisma 스키마 (설계안)
```prisma
// 사용자(카카오 로그인 / 추후 타 OAuth 연결 대상)
// 친구 추천 신호는 decisions/friend-recommendation/0001-recommendation-algorithm.md 참조.
model User {
  id             String    @id @default(uuid())
  displayName    String                          // 카카오 닉네임 또는 게스트 기본값
  avatarUrl      String?
  isGuest        Boolean   @default(true)         // 카카오 로그인 사용자는 false
  tokenVersion   Int       @default(0)            // JWT 일괄 무효화용
  // ── 친구 추천용 denormalized 신호 (단방향 follow) ──
  followerCount  Int       @default(0)            // 나를 follow한 수(인기 정렬)
  followingCount Int       @default(0)            // 내가 follow한 수(FoF 탐색)
  postCount      Int       @default(0)            // 활동수=피드에 올린 글 수
  lastPostedAt   DateTime?                        // 활동 최근성(publishToFeed 시 갱신)
  goalDirection  GoalDir?                         // 목표 방향(Profile에서 파생·denorm, 후보 필터)
  ageBucket      Int?                             // birthYear→10년 버킷(후보 필터)
  createdAt      DateTime  @default(now())
  updatedAt      DateTime  @updatedAt

  profile       Profile?
  identities    AuthIdentity[]
  analyses      FoodAnalysis[]
  records       FoodRecord[]
  following     FriendRelation[] @relation("follower")   // 내가 follow한 관계
  followers     FriendRelation[] @relation("following")  // 나를 follow한 관계
  recFeedback   FriendRecFeedback[] @relation("recOwner")

  @@index([displayName])                        // 친구 검색
  @@index([followerCount, postCount])           // 인기·활동 정렬
  @@index([goalDirection, ageBucket])           // ③ 목표유사 후보 생성(P0 핵심 경로)
  @@index([lastPostedAt])                       // 활동 폴백 후보
}

// 추후 OAuth 연결(익명 계정 유지한 채 provider 연결)
model AuthIdentity {
  id             String   @id @default(uuid())
  userId         String
  provider       AuthProvider                   // google | kakao
  providerUserId String                         // provider 측 고유 id
  createdAt      DateTime @default(now())
  user           User     @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@unique([provider, providerUserId])
  @@index([userId])
}

model Profile {
  userId             String   @id                // 1:1 (User.id 그대로 PK)
  gender             Gender
  birthYear          Int                         // 나이 계산용(BMR). 활동량은 입력받지 않음
  heightCm           Float
  currentWeightKg    Float
  targetWeightKg     Float
  targetDate         DateTime @db.Date
  dailyCalorieTarget Int                         // 서버 계산·저장
  weeklyWeightDelta  Float                       // 주당 목표 체중 변화(kg, 음수=감량)
  createdAt          DateTime @default(now())
  updatedAt          DateTime @updatedAt
  user               User     @relation(fields: [userId], references: [id], onDelete: Cascade)
}

// Gemini 분석 1건(기록 저장 전 임시 단위)
model FoodAnalysis {
  id          String         @id @default(uuid())
  userId      String
  imageKey    String                              // S3 object key
  imageUrl    String                              // 표시용 URL(또는 signed URL)
  source      CaptureSource?                      // camera | gallery
  status      AnalysisStatus @default(processing) // processing|completed|failed
  needsReview Boolean        @default(false)      // 모델 응답 불완전
  geminiRaw   Json?                               // 모델 원본 JSON(디버깅/재처리)
  result      Json?                               // 정규화 결과(아래 4.3 형태)
  errorCode   String?
  errorMsg    String?
  createdAt   DateTime       @default(now())
  updatedAt   DateTime       @updatedAt
  user        User           @relation(fields: [userId], references: [id], onDelete: Cascade)
  record      FoodRecord?

  @@index([userId, createdAt])
}

// 사용자가 저장한 식단 기록(대표 단위)
model FoodRecord {
  id            String     @id @default(uuid())
  userId        String
  analysisId    String?    @unique               // 출처 분석(있으면)
  mealType      MealType                          // breakfast|lunch|dinner|snack
  title         String
  imageUrl      String?
  eatenAt       DateTime                          // 실제 섭취 시각(UTC)
  eatenLocalDate DateTime  @db.Date               // 캘린더 집계용(KST 기준 date)
  totalCalories Int
  proteinG      Float                             // 기록 전체 합계
  carbsG        Float
  fatG          Float
  publishedToFeed Boolean  @default(false)
  createdAt     DateTime   @default(now())
  updatedAt     DateTime   @updatedAt
  user          User          @relation(fields: [userId], references: [id], onDelete: Cascade)
  analysis      FoodAnalysis? @relation(fields: [analysisId], references: [id])
  items         FoodItem[]

  @@index([userId, eatenLocalDate])               // 캘린더/홈 오늘 조회 핫경로
}

// FoodRecord 안의 개별 음식 항목
model FoodItem {
  id        String     @id @default(uuid())
  recordId  String
  name      String
  amount    String?                               // 예: "1공기", "120g"
  calories  Int
  proteinG  Float
  carbsG    Float
  fatG      Float
  sortOrder Int        @default(0)
  record    FoodRecord @relation(fields: [recordId], references: [id], onDelete: Cascade)

  @@index([recordId])
}

// follower → following (방향성 있는 follow)
model FriendRelation {
  id          String   @id @default(uuid())
  followerId  String                              // follow 하는 사람(나)
  followingId String                              // follow 당하는 사람
  createdAt   DateTime @default(now())
  follower    User     @relation("follower",  fields: [followerId],  references: [id], onDelete: Cascade)
  following   User     @relation("following", fields: [followingId], references: [id], onDelete: Cascade)

  @@unique([followerId, followingId])             // 중복 follow 방지(멱등)
  @@index([followingId])                          // 맞팔/팔로워 조회
}

// 친구 추천 노출/거절 이력 (impression discounting — 이미 본/숨긴 추천 디스카운트)
model FriendRecFeedback {
  userId      String                              // 추천을 받은 사람(나)
  candidateId String                              // 추천된 후보
  action      RecAction                           // shown | dismissed | hidden
  createdAt   DateTime @default(now())
  user        User     @relation("recOwner", fields: [userId], references: [id], onDelete: Cascade)

  @@id([userId, candidateId])
  @@index([userId, action])
}

enum Gender         { male female other }
enum GoalDir        { lose maintain gain }       // 목표 방향(추천 후보 필터)
enum RecAction      { shown dismissed hidden }   // 추천 피드백
enum AuthProvider   { google kakao }
enum CaptureSource  { camera gallery }
enum AnalysisStatus { processing completed failed }
enum MealType       { breakfast lunch dinner snack }
```

### 2.3 설계 메모
- **`FoodAnalysis.result` 는 jsonb**(저장 전 임시·가변). 영구·집계 대상은 정규화된 `FoodRecord`/`FoodItem` 컬럼이 진실.
- **친구 기능은 두 화면**: ① 친구 목록 화면(`GET /v1/friends`) ② 추천/검색 화면(`GET /v1/friends/search` + follow/unfollow). 둘 다 `FriendRelation`(단방향, follower→following) 테이블을 사용. 추천/검색에서 선택하면 친구 목록에 추가된다. `selected` = "이미 내 친구인가". `mutualFriendCount` = 나의 following ∩ 상대의 following = **추천 랭킹 1순위 신호**(FoF self-join의 `COUNT(*)`로 산출, 카카오/폴백 후보는 0 가능).
- **추천 신호 카운터(denormalized)**: `followerCount`(나를 follow, 인기 정렬)·`followingCount`(내가 follow, FoF 탐색)·`postCount`·`lastPostedAt`(활동). 목표유사 후보 필터용 `goalDirection`·`ageBucket`은 `Profile` 저장 시 User에 파생 저장. 알고리즘 상세는 [decisions/friend-recommendation/0001](../decisions/friend-recommendation/0001-recommendation-algorithm.md).
- **삭제 정책**: User 삭제 시 하위 전부 `Cascade`. 단 `FoodRecord.analysis` 는 출처 보존 위해 `SetNull` 성격(analysisId nullable).
- **마이그레이션**: `prisma migrate dev`(개발) / `prisma migrate deploy`(배포). seed 사용자(친구 검색용 mock)는 `prisma/seed.ts`.

---

## 3. 계산 로직 (서버 단일 책임)

### 3.1 권장 칼로리 / 주간 체중 변화 (`PUT /v1/me/profile` 시 계산)
- 나이: `age = (오늘 연도) − birthYear` (프로필에서 `birthYear` 입력받음).
- BMR (Mifflin–St Jeor):
  - male:   `10*kg + 6.25*cm − 5*age + 5`
  - female: `10*kg + 6.25*cm − 5*age − 161`
- **활동량은 입력받지 않는다**(요구가 과하고 애매). 활동계수는 서버 고정 상수 `1.4`(가벼운 활동) 사용.
- `TDEE = BMR * 1.4`.
- 목표까지 주수: `weeks = max(1, (targetDate − today) / 7일)`.
- `weeklyWeightDelta = (targetWeightKg − currentWeightKg) / weeks` (kg/주, 음수=감량).
- 일일 칼로리 조정: `dailyAdjust = weeklyWeightDelta * 7700 / 7` (지방 1kg≈7700kcal).
- `dailyCalorieTarget = round(TDEE + dailyAdjust)`, 안전 하한 clamp(예: 1200kcal).

> 이 값들은 **저장**(Profile)하여 홈/캘린더에서 재계산 없이 사용.

---

## 4. API 상세 흐름

표기: `→` 처리 단계, `DB:` DB 작업, `EXT:` 외부 호출, `RESP:` 응답.

### 4.0 엔드포인트 목록
| # | Method | Path | 인증 | 캐시 |
|---|--------|------|------|------|
| 1 | POST | `/v1/sessions/guest` | 없음 | - |
| 2 | GET | `/v1/me/profile` | Bearer | - |
| 3 | PUT | `/v1/me/profile` | Bearer | 무효화: home |
| 4 | GET | `/v1/home` | Bearer | Redis 45s |
| 5 | GET | `/v1/friends` | Bearer | Redis 45s |
| 6 | GET | `/v1/friends/search?q=` | Bearer | seed만 캐시 |
| 7 | POST | `/v1/friends/{id}/follow` | Bearer | 무효화: home,friends,search |
| 8 | DELETE | `/v1/friends/{id}/follow` | Bearer | 무효화: home,friends,search |
| 9 | POST | `/v1/food-analyses` | Bearer | - (큐) |
| 10 | GET | `/v1/food-analyses/{id}` | Bearer | - (폴링) |
| 11 | POST | `/v1/food-records` | Bearer | 무효화: home,calendar,feed |
| 12 | GET | `/v1/calendar/daily-summary?date=` | Bearer | Redis 30s |
| 13 | GET | `/v1/feed?cursor=&limit=&mealType=` | Bearer | Redis 30s |
| 14 | POST | `/v1/posts/{recordId}/like` | Bearer | 무효화: feed,home |
| 15 | DELETE | `/v1/posts/{recordId}/like` | Bearer | 무효화: feed,home |
| 16 | GET | `/v1/posts/{recordId}/comments?cursor=` | Bearer | - |
| 17 | POST | `/v1/posts/{recordId}/comments` | Bearer | 무효화: feed |

> 13~17(피드)는 [spec-lock §5.2](./spec-lock.md) 신설. 상세 요청/응답은 [openapi.yaml](./openapi.yaml).

---

### 4.1 `POST /v1/sessions/guest` — 게스트 세션 생성
- **트리거**: 앱 최초 실행, secure storage에 토큰 없음.
- 요청: body 없음(또는 `{ deviceHint? }`).
- 흐름:
  - → `displayName` 기본값 생성("user-" + 짧은 랜덤).
  - DB: `User` insert (`isGuest=true, tokenVersion=0`).
  - → JWT 서명(`sub=userId, ver=0`).
- RESP `201`: `{ userId, sessionToken, isNewUser: true }`.
- 스파이크: 쓰기 1건뿐, 레이트리밋(IP당 분당 N)으로 남발 방지.

### 4.2 `GET /v1/me/profile` — 프로필 조회(부트스트랩 분기)
- **트리거**: 앱 시작 시 토큰 있음 → 홈/프로필설정 분기 판단.
- DB: `Profile` by userId.
- RESP `200` (있음): `{ profile, dailyCalorieTarget, weeklyWeightDelta }`.
- RESP `404`/`{ profile: null }` (없음): 앱은 프로필 설정 화면으로.
  - 권장: 200 + `{ profile: null }` 로 통일(앱 분기 단순화).

### 4.3 `PUT /v1/me/profile` — 프로필 저장 (STEP 3 "시작하기")
- 요청: `{ displayName, gender, birthYear, heightCm, currentWeightKg, targetWeightKg, targetDate }`.
  - **STEP 1**(`다음`, **API 호출 없음** — 클라 draft): `displayName`(이름).
  - **STEP 2**(`다음`, **API 호출 없음** — 클라 draft): `gender`, `birthYear`(출생연도), `heightCm`, `currentWeightKg`.
  - **STEP 3**(`시작하기`): STEP 1·2 draft + `targetWeightKg`, `targetDate` 를 합쳐 위 페이로드로 전송.
  - `birthYear` 는 나이 계산용(활동량은 입력받지 않음). 검증 범위 확정값은 [spec-lock §7](./spec-lock.md).
- zod 검증: displayName(1~50), birthYear(1920~올해−14), heightCm(80~250), weight(20~400), targetDate(미래 & ≤2년), gender enum.
- 흐름:
  - → 3.1 로 `dailyCalorieTarget`, `weeklyWeightDelta` 계산.
  - DB: `Profile` **upsert** (userId 기준) — 재호출 멱등. **`User.displayName`**도 갱신. 동시에 **`User.goalDirection`**(targetWeightKg−currentWeightKg 부호 → lose/maintain/gain) + **`User.ageBucket`**(`floor(birthYear/10)*10`) 파생 갱신(추천 후보 필터용).
  - 캐시: home 무효화.
- RESP `200`: `{ profile, dailyCalorieTarget, weeklyWeightDelta }`.
- 실패: `400` + fields → 앱은 화면 유지 + 입력 보존.

### 4.4 `GET /v1/home` — 홈 데이터
- DB(병렬, N+1 금지):
  - todaySummary: `FoodRecord` where `userId, eatenLocalDate=today` → `sum(totalCalories, macros)` + `Profile.dailyCalorieTarget`.
  - friendsCertifiedToday: **내 친구**(`FriendRelation` follower=me) 중 오늘 `FoodRecord` 1건 이상 있는 유저 목록(join + distinct).
  - currentUser: `User`(displayName, avatarUrl).
  - recentRecords: `FoodRecord` 최신 N개(`orderBy eatenAt desc, take N`).
- 캐시: 키 `home:{userId}`, TTL 45s([spec-lock §7](./spec-lock.md)). 기록/팔로우/프로필 변경 시 무효화.
- RESP `200`: `{ todaySummary, friendsCertifiedToday, currentUser, recentRecords }`.
- 핫경로 → 캐시 우선, 미스 시에만 위 집계 쿼리.

> 친구 기능은 **두 화면**으로 나뉜다.
> ① **친구 목록 화면** — 이미 내 친구인 사람들을 본다(`GET /v1/friends`).
> ② **추천/검색 화면** — 친구를 *추가*하려고 사용자를 찾고 선택한다(`GET /v1/friends/search` + follow/unfollow).
> 둘 다 같은 `FriendRelation` 테이블을 읽고/쓴다. 추천/검색에서 선택하면 친구 목록에 들어온다.

### 4.5 `GET /v1/friends` — 친구 목록 (친구 목록 화면)
- **친구 목록 페이지**가 사용하는 API. 내가 친구로 추가한 사용자(`FriendRelation` follower=me) 목록을 반환.
- DB: `FriendRelation where followerId=me` join `User`(N+1 금지).
- 각 row: `{ id, displayName, avatarUrl?, mutualFriendCount, certifiedToday }`.
- **무한 스크롤**: 하단까지 스크롤하면 다음 batch 로드. `?cursor=&limit=`(기본 20), `nextCursor`(null이면 끝).
- 캐시: `friends:{userId}`, TTL 45s([spec-lock §7](./spec-lock.md)). 친구 추가/제거 시 무효화.
- RESP `200`: `{ friends: [...], nextCursor? }`.

### 4.6 `GET /v1/friends/search?q=` — 친구 추천/검색 (친구 추가용)
> 알고리즘 결정: [decisions/friend-recommendation/0001](../decisions/friend-recommendation/0001-recommendation-algorithm.md). 아래는 그 구현 계약.

- **친구를 추가하기 위한** 추천/검색 화면용. 위 친구 목록과는 **다른 화면**. 후보에서 항상 **본인 / 이미 내 친구** 제외.

- **`q` 빈값 = 추천 목록** — 2단계 깔때기(후보 생성 → 결정론적 랭킹, ML 없음):

  **① 후보 생성(union + 우선순위, 하드스위치 아님)** — 인덱스로 싸게 좁힌다(소스별 `LIMIT`):
  - **FoF**: 내 친구의 친구(`FriendRelation` self-join). `statement_timeout` + 슈퍼노드 degree cap.
  - **카카오 친구**: 카카오 친구목록 API ∩ `AuthIdentity(provider=kakao)`. (카카오 로그인+친구 scope 검수 전제 — 미연동 시 생략)
  - **목표/활동 폴백**: `goalDirection=me ∧ ageBucket=me`(`@@index([goalDirection,ageBucket])`), 부족하면 `lastPostedAt` 최신순. → P0 런칭기 빈 화면 방지.

  **② 랭킹(좁혀진 소수 후보에만 점수 계산)**:
  ```
  score = w1·mutualFriendCount + w2·goalSimilarity + w3·activityRecency
        + w4·followerCount − w5·alreadyShownPenalty,   tie-break: id
  ```
  - `mutualFriendCount`: FoF self-join `COUNT(*)`. `goalSimilarity∈[0,1]`: 목표방향·강도·나이대·칼로리 근접(ADR §3). `activityRecency`: `postCount`+`lastPostedAt`. `alreadyShownPenalty`: `FriendRecFeedback`.
  - **가중치는 네트워크 성숙도에 따라 이동**: P0 런칭(목표유사도·활동 주력, mutual≈0) → P3 성숙(공통친구 지배).

  **③ 페이징** — ⚠️ 1·2순위가 **계산값이라 DB keyset 불가**:
  - 좁힌 후보에 점수 계산 → 정렬 리스트를 **Redis 캐시**(수시간 TTL) → 페이징은 **캐시된 정렬 리스트** 기준. `?cursor=&limit=`(기본 20)는 캐시 리스트의 offset/토큰. follow/unfollow·새 글 시 해당 유저 추천 캐시 무효화.

- **`q` 있음 = 검색**: `User.displayName ILIKE %q%`(본인 제외, `pg_trgm` 고려). 이미 친구인 사람은 표시하되 `selected=true`. 정렬은 동일 점수식(검색은 후보=매치된 유저).
- 각 row `selected` = `FriendRelation(follower=me, following=row)` 존재 여부.
- RESP `200`: `{ users: [{ id, displayName, avatarUrl?, followerCount, postCount, mutualFriendCount, selected }], nextCursor? }`.
- 실패 시 앱은 기존 결과 유지 + inline retry.
- 성능: 카운터(`followerCount`/`postCount`/`lastPostedAt`)·필터키(`goalDirection`/`ageBucket`)는 denormalized → 후보 생성/정렬에 사용(매 요청 집계 금지). 후보 신호는 **batch 조회**(N+1 금지).

### 4.7 `POST /v1/friends/{friendUserId}/follow` — 친구 추가 (추천/검색에서 선택)
- 추천/검색 목록의 row를 선택하면 **친구로 추가**된다.
- 검증: 자기 자신 추가 금지(`400`), 대상 존재 확인(`404`).
- DB(tx): `FriendRelation` insert(`@@unique`로 **멱등** — 이미 친구면 카운터 변동 없음) + **본인 `followingCount` +1** + **대상 `followerCount` +1**(denormalized; 단방향 follow, 9번 결정 반영).
- 캐시: home, friends, search 관련 무효화(본인·대상 추천 캐시 포함).
- RESP `200`: `{ friendUserId, selected: true }`.
- 성공 시 앱은 해당 row와 친구 목록/홈 친구 영역을 갱신한다.

### 4.8 `DELETE /v1/friends/{friendUserId}/follow` — 친구 제거 (선택 해제)
- 선택 해제 시 **친구에서 제거**된다.
- DB(tx): `FriendRelation` delete (실제 삭제된 경우에만 **본인 `followingCount` −1** + **대상 `followerCount` −1**; 없으면 `200`, 카운터 변동 없음 — 멱등).
- 캐시: home, friends, search 무효화(본인·대상 추천 캐시 포함).
- RESP `200`: `{ friendUserId, selected: false }`.

### 4.9 `POST /v1/food-analyses` — 이미지 업로드 + 분석 시작 (multipart)
- 요청(multipart): `image`(file), optional `{ source: "camera"|"gallery" }`.
- 검증: MIME(jpeg/png/webp), 크기 1KB~10MB(초과 `413`). 확정값 [spec-lock §7](./spec-lock.md).
- 흐름(**비동기 큐 — 단일 경로 확정**, 동기 빠른경로 폐기):
  - → 이미지 S3 업로드(`imageKey`, `imageUrl`).
  - DB: `FoodAnalysis` insert (`status=processing`).
  - 큐: 분석 잡 enqueue(analysisId).
  - RESP **`202`**: `{ analysisId, status:"processing", imageUrl }` — **항상 processing 반환**. 결과는 4.10 폴링으로만 확인.
  - (워커) EXT: Gemini `gemini-2.5-flash` 호출(이미지 + **프롬프트는 [spec-lock §9](./spec-lock.md) 원문**) → 4.10 형태로 정규화 → DB update(`completed`/`failed`, `result`, `needsReview`).
- 스파이크: 업로드/분석 전용 **빡센 레이트리밋**(10/min, [spec-lock §7](./spec-lock.md)), 큐로 Gemini 동시호출 상한 제어, 요청 흐름 차단 금지.

### 4.10 `GET /v1/food-analyses/{analysisId}` — 분석 상태 폴링
- 권한: `FoodAnalysis.userId == me` 아니면 `404`.
- RESP `200`:
  - 처리중: `{ analysisId, status:"processing", imageUrl }`.
  - 완료: `{ analysisId, status:"completed", imageUrl, result, needsReview }`.
  - 실패: `{ analysisId, status:"failed", errorCode, message }`.
- **정규화 `result` 형태**(서버 보장):
  ```json
  {
    "dishName": "string",
    "totalCalories": 0,
    "macros": { "proteinG": 0, "carbsG": 0, "fatG": 0 },
    "items": [{ "name": "string", "amount": "string?", "calories": 0,
                "proteinG": 0, "carbsG": 0, "fatG": 0 }],
    "confidence": 0.0,
    "notes": "string?"
  }
  ```
  - 모델 응답 불완전 → `needsReview: true`(앱에서 수정 가능).
- 실패 재시도: 앱이 **같은 이미지로** `POST /v1/food-analyses` 재호출.
- 폴링 간격 권장: 1~2s, 지수백오프, 최대 시도수 제한.

### 4.11 `POST /v1/food-records` — 기록 저장 ("피드에 올리기")
- 요청:
  ```json
  { "analysisId": "uuid?", "mealType": "lunch", "eatenAt": "ISO8601",
    "title": "string", "totalCalories": 0,
    "macros": { "proteinG": 0, "carbsG": 0, "fatG": 0 },
    "items": [ ...FoodItem ], "publishToFeed": true }
  ```
- zod: enum/숫자/합계 정합(`items` 합 ≈ `totalCalories`/macros — 경고만, 사용자 수정 우선).
- 흐름(**트랜잭션**):
  - → `eatenLocalDate` = `eatenAt` 의 KST date 계산.
  - DB tx: `FoodRecord` insert + `FoodItem[]` bulk insert. `analysisId` 있으면 연결(`@unique`). `publishToFeed=true` 면 **본인 `postCount` +1 + `lastPostedAt`=now**(활동수·최근성, 추천 정렬용).
  - 캐시: `home:{userId}`, `calendar:{userId}:{date}`, `feed`(publishToFeed=true 시) 무효화.
- RESP `201`: `{ recordId, record, dailySummary }` (그날 갱신된 요약 포함 → 앱이 홈/캘린더 즉시 반영).
- 실패: form state 유지(앱). 서버는 부분저장 없도록 tx 보장.

### 4.12 `GET /v1/calendar/daily-summary?date=YYYY-MM-DD` — 날짜별 요약
- 검증: `date` 형식.
- DB: `FoodRecord` where `userId, eatenLocalDate=date` + `items` include(N+1 금지), `Profile.dailyCalorieTarget`.
  - 끼니별 그룹화(`recordsByMeal`: breakfast/lunch/dinner/snack).
- 캐시: `calendar:{userId}:{date}`, TTL 30s.
- RESP `200`: `{ date, calorieTarget, totalCalories, macros, recordsByMeal }`.
  - 기록 없음: 빈 배열/0 합계(앱은 Figma 빈 상태 렌더).
- ⚠️ 이번 단계 범위: row 클릭 상세 이동 / 상세 조회·수정 endpoint(`GET·PATCH /v1/food-records/{id}`)는 **구현 안 함**.

---

## 5. 부트스트랩 전체 시퀀스 (앱↔서버)
```
앱 시작
 ├─ (선택) 카카오 로그인 → AuthIdentity(kakao) upsert → sessionToken 발급
 │     ※ Figma 로그인 화면 미정. 게스트 폴백 유지·카카오 선택 확정(0001 ADR §7).
 ├─ secure storage sessionToken?
 │   ├─ 없음 → 카카오 로그인(또는 POST /v1/sessions/guest) → 토큰 저장 → 프로필설정 화면
 │   └─ 있음 → GET /v1/me/profile
 │        ├─ profile null → 프로필설정 화면 → PUT /v1/me/profile → 홈
 │        └─ profile 존재 → 홈 (GET /v1/home)
 └─ 홈에서: 카메라(9→10→11) / 캘린더(12) / 친구 목록(5) · 친구 추가(6→7/8)
```

---

## 6. 범위 밖(이번 단계 미구현, 명시)
- 캘린더 끼니별 row 클릭 동작.
- `GET /v1/food-records/{recordId}` 상세 조회.
- 음식 상세 화면 / "수정하기" 버튼.
- `PATCH /v1/food-records/{recordId}` 기존 기록 수정.
- 카카오 **친구목록 매칭**: 비즈앱 검수 전까지 미동작 → 그 동안 추천은 **목표유사도+활동 폴백**으로 대체(FoF 추천은 범위 안). [0001 ADR §6](../decisions/friend-recommendation/0001-recommendation-algorithm.md).
- 카카오 **외** 로그인(구글 등) — 미논의(스키마는 `AuthIdentity`로 확장 대비).

---

## 7. 환경변수(.env, 서버 전용)
`DATABASE_URL`, `JWT_SECRET`, `GEMINI_API_KEY`, **GCS**: `GCS_BUCKET`/`GCS_PROJECT_ID`/`GCS_API_ENDPOINT`(에뮬레이터)/`GCS_PUBLIC_URL`(+실배포 `GOOGLE_APPLICATION_CREDENTIALS`), `REDIS_URL`(큐·캐시·레이트리밋), `KAKAO_REST_API_KEY`/`KAKAO_ADMIN_KEY`(카카오 로그인·친구목록), `APP_TZ=Asia/Seoul`.
→ **절대 커밋 금지**(.gitignore 확인). 클라이언트는 Gemini/S3 직접 호출하지 않음.

---

## 8. 인덱스/성능 체크리스트
- `User.displayName` (친구 검색 ILIKE — 대량 시 `pg_trgm` GIN 고려).
- **추천**: `User(followerCount, postCount)`(인기·활동), `User(goalDirection, ageBucket)`(목표유사 후보), `User(lastPostedAt)`(활동 폴백). `FriendRecFeedback(userId, action)`.
- `FoodRecord(userId, eatenLocalDate)` (홈 오늘/캘린더 핫경로).
- `FoodAnalysis(userId, createdAt)`, `FoodItem(recordId)`, `FriendRelation @@unique + followingId`.
- 친구 **목록**은 cursor keyset 무한 스크롤. **추천**은 랭킹 1·2순위(mutual·goalSimilarity)가 계산값이라 DB keyset 불가 → **후보 좁히기 → 점수 계산 → 정렬 리스트 Redis 캐시 → 캐시 페이징**([ADR §8](../decisions/friend-recommendation/0001-recommendation-algorithm.md)). Gemini 호출은 큐로 동시성 상한.

---

## 9. 결정된 사항 / 남은 질문
**결정됨**
- 권장 칼로리: **프로필 설정 STEP 2 화면에서 `birthYear`(생년) 입력**받아 Mifflin BMR 계산. **활동량은 입력받지 않고** 서버 고정계수 `1.4` 사용.
- **로그인: 앱 시작 시 카카오톡 로그인 도입 예정**(그 외 방법 미논의). Figma 로그인 화면 디자인은 아직 없음.
- 친구는 **친구 목록 화면(`GET /v1/friends`)** 과 **추천/검색 화면(`GET /v1/friends/search`)** 두 개로 분리. 추천/검색에서 선택하면 친구 목록에 추가. 두 목록 모두 **무한 스크롤**(cursor 기반).
- 친구 **추천 알고리즘 확정** → [decisions/friend-recommendation/0001](../decisions/friend-recommendation/0001-recommendation-algorithm.md). 요지: 2단계 깔때기(후보 생성→결정론적 랭킹), 랭킹 `mutualFriendCount → goalSimilarity → activityRecency → followerCount → id`, 후보 union(FoF·카카오·목표/활동 폴백), 네트워크 성숙도별 가중치 이동.
- **관계 모델**: 단방향 follow. 카운터 `followerCount`(인기)/`followingCount`(FoF) 분리.
- **로그인**: 게스트 폴백 유지 + 카카오 선택(검수 의존성을 v1 출시 경로에서 분리).
- **콜드스타트 폴백**: 카카오 미연동 구간은 목표유사도+활동으로 채워 빈 화면 방지.

**남은 질문 → 전부 확정됨([spec-lock §5.1](./spec-lock.md))**
1. ~~카카오 로그인 vs 게스트~~ → **게스트 폴백 유지, 카카오 선택**(0001 ADR §7).
2. ~~친구 상호/단방향~~ → **단방향 follow**(0001 ADR §5).
3. ~~카카오 친구목록 미연동 폴백~~ → **목표유사도+활동 폴백**(0001 ADR §6). 비즈앱 검수 통과 시 카카오 소스 활성화.
4. ~~`GET /v1/me/profile` 404 vs 200+null~~ → ✅ **200 + { profile: null } 확정**(404 금지).
5. ~~분석 경로 비동기 vs 동기~~ → ✅ **비동기 큐 + 폴링만 확정**(동기 빠른경로 폐기, 항상 202 processing).
6. ~~캘린더 타임존~~ → ✅ **KST(`Asia/Seoul`) 고정 확정**. 다국가 지원 시 사용자 tz 컬럼은 후속.
