# diet-setlog — API 흐름 & DB 설계

> 대상: 이슈 #1 `dietsetlog-wireframe-plan.md`의 1차 구현 범위.
> 스택: **Express + TypeScript + Prisma + PostgreSQL**, 이미지 = S3 호환 스토리지, 분석 = Gemini `gemini-2.5-flash`.
> 이 문서는 **코드가 아니라 설계(계약·흐름·스키마)** 만 다룬다. 화면/플로우 범위는 이슈 #1을 따른다.

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
- ⚠️ **이슈 #1과의 충돌**: 이슈 #1은 "v1은 로그인 없이"였다. 카카오 로그인을 시작에 두면 익명 게스트 세션을 **대체할지 / 폴백으로 둘지** 결정 필요(9번 참고).
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
model User {
  id           String   @id @default(uuid())
  displayName  String                          // 카카오 닉네임 또는 게스트 기본값
  avatarUrl    String?
  isGuest      Boolean  @default(true)          // 카카오 로그인 사용자는 false
  tokenVersion Int      @default(0)             // JWT 일괄 무효화용
  friendCount  Int      @default(0)             // 친구 수(추천 정렬용, denormalized)
  postCount    Int      @default(0)             // 활동수=피드에 올린 글 수(추천 정렬용, denormalized)
  createdAt    DateTime @default(now())
  updatedAt    DateTime @updatedAt

  profile       Profile?
  identities    AuthIdentity[]
  analyses      FoodAnalysis[]
  records       FoodRecord[]
  following     FriendRelation[] @relation("follower")   // 내가 친구로 추가한 관계
  followers     FriendRelation[] @relation("following")  // 나를 친구로 추가한 관계

  @@index([displayName])                        // 친구 검색
  @@index([friendCount, postCount])             // 친구 추천 정렬(친구수↓ → 활동수↓)
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

enum Gender         { male female other }
enum AuthProvider   { google kakao }
enum CaptureSource  { camera gallery }
enum AnalysisStatus { processing completed failed }
enum MealType       { breakfast lunch dinner snack }
```

### 2.3 설계 메모
- **`FoodAnalysis.result` 는 jsonb**(저장 전 임시·가변). 영구·집계 대상은 정규화된 `FoodRecord`/`FoodItem` 컬럼이 진실.
- **친구 기능은 두 화면**: ① 친구 목록 화면(`GET /v1/friends`) ② 추천/검색 화면(`GET /v1/friends/search` + follow/unfollow). 둘 다 `FriendRelation`(단방향, follower→following) 테이블을 사용. 추천/검색에서 선택하면 친구 목록에 추가된다. `selected` = "이미 내 친구인가". `mutualFriendCount` = 나의 following ∩ 상대의 following (v1은 seed라 0 가능).
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
| 4 | GET | `/v1/home` | Bearer | Redis 30~60s |
| 5 | GET | `/v1/friends` | Bearer | Redis 30~60s |
| 6 | GET | `/v1/friends/search?q=` | Bearer | seed만 캐시 |
| 7 | POST | `/v1/friends/{id}/follow` | Bearer | 무효화: home,friends,search |
| 8 | DELETE | `/v1/friends/{id}/follow` | Bearer | 무효화: home,friends,search |
| 9 | POST | `/v1/food-analyses` | Bearer | - (큐) |
| 10 | GET | `/v1/food-analyses/{id}` | Bearer | - (폴링) |
| 11 | POST | `/v1/food-records` | Bearer | 무효화: home,calendar |
| 12 | GET | `/v1/calendar/daily-summary?date=` | Bearer | Redis 30s |

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
- 요청: `{ gender, birthYear, heightCm, currentWeightKg, targetWeightKg, targetDate }`.
  - **STEP 2**(`다음` 버튼, **API 호출 없음** — 클라 draft만): `gender`, `birthYear`(생년), `heightCm`, `currentWeightKg`.
  - **STEP 3**(`시작하기` 버튼): STEP 2 draft + `targetWeightKg`, `targetDate` 를 합쳐 위 페이로드로 전송.
  - `birthYear` 는 나이 계산용(활동량은 입력받지 않음).
- zod 검증: birthYear(예 1920~현재, age 14세 이상), heightCm(예 80~250), weight(예 20~400), targetDate(미래), gender enum.
- 흐름:
  - → 3.1 로 `dailyCalorieTarget`, `weeklyWeightDelta` 계산.
  - DB: `Profile` **upsert** (userId 기준) — 재호출 멱등.
  - 캐시: home 무효화.
- RESP `200`: `{ profile, dailyCalorieTarget, weeklyWeightDelta }`.
- 실패: `400` + fields → 앱은 화면 유지 + 입력 보존.

### 4.4 `GET /v1/home` — 홈 데이터
- DB(병렬, N+1 금지):
  - todaySummary: `FoodRecord` where `userId, eatenLocalDate=today` → `sum(totalCalories, macros)` + `Profile.dailyCalorieTarget`.
  - friendsCertifiedToday: **내 친구**(`FriendRelation` follower=me) 중 오늘 `FoodRecord` 1건 이상 있는 유저 목록(join + distinct).
  - currentUser: `User`(displayName, avatarUrl).
  - recentRecords: `FoodRecord` 최신 N개(`orderBy eatenAt desc, take N`).
- 캐시: 키 `home:{userId}`, TTL 30~60s. 기록/팔로우/프로필 변경 시 무효화.
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
- 캐시: `friends:{userId}`, TTL 30~60s. 친구 추가/제거 시 무효화.
- RESP `200`: `{ friends: [...], nextCursor? }`.

### 4.6 `GET /v1/friends/search?q=` — 친구 추천/검색 (친구 추가용)
- **친구를 추가하기 위한** 추천/검색 화면용. 위 친구 목록과는 **다른 화면**.
- 공통 정렬·페이징: **친구수(`friendCount`) 많은 순 → 활동수(`postCount`=피드에 올린 글 수) 많은 순**. 동률 tie-break는 `id`.
  - 무한 스크롤: 복합 keyset cursor `(friendCount, postCount, id)`. `?cursor=&limit=`(기본 20), `nextCursor`(null이면 끝).
  - 후보에서 항상 **본인 / 이미 내 친구**는 제외.

- **`q` 빈값 = 추천 목록** — **내 친구 수로 분기**:
  - **내 친구 0명** → 후보 = **내 카카오톡 친구 중 우리 앱 가입자**(카카오 친구목록 API ∩ `AuthIdentity(provider=kakao)`). 위 정렬로 리스트업.
  - **내 친구 1명 이상** → 후보 = **친구의 친구**(내 친구들의 친구 합집합). 위 정렬로 리스트업.
  - 두 경우 모두 본인·이미 친구 제외, 친구수↓ → 활동수↓ 정렬, cursor 무한 스크롤.
  - ⚠️ 카카오 분기는 **카카오 로그인 + 친구목록 동의**(1.5)가 전제. 미연동 상태면 추천이 비거나 seed로 대체.

- **`q` 있음 = 검색**: `User.displayName ILIKE %q%`(본인 제외). 디바운스는 클라. 이미 친구인 사람은 표시하되 `selected=true`. 정렬은 동일(친구수↓ → 활동수↓).
- 각 row의 `selected` = "이미 내 친구인가" = `FriendRelation(follower=me, following=row)` 존재 여부.
- RESP `200`: `{ users: [{ id, displayName, friendCount, postCount, mutualFriendCount, selected }], nextCursor? }`.
- 실패 시 앱은 기존 결과 유지 + inline retry.
- 성능: `friendCount`/`postCount` 는 **denormalized 카운터**(User)로 두고 정렬·cursor에 사용(매 요청 집계 금지). 카카오 친구 매칭 결과는 짧은 TTL로 캐시.

### 4.7 `POST /v1/friends/{friendUserId}/follow` — 친구 추가 (추천/검색에서 선택)
- 추천/검색 목록의 row를 선택하면 **친구로 추가**된다.
- 검증: 자기 자신 추가 금지(`400`), 대상 존재 확인(`404`).
- DB(tx): `FriendRelation` insert(`@@unique`로 **멱등** — 이미 친구면 카운터 변동 없음) + **본인 `friendCount` +1**(denormalized, 추천 정렬용). *(친구를 상호관계로 본다면 양쪽 +1 — 9번 결정 필요)*
- 캐시: home, friends, search 관련 무효화.
- RESP `200`: `{ friendUserId, selected: true }`.
- 성공 시 앱은 해당 row와 친구 목록/홈 친구 영역을 갱신한다.

### 4.8 `DELETE /v1/friends/{friendUserId}/follow` — 친구 제거 (선택 해제)
- 선택 해제 시 **친구에서 제거**된다.
- DB(tx): `FriendRelation` delete (실제 삭제된 경우에만 **본인 `friendCount` −1**; 없으면 `200`, 카운터 변동 없음 — 멱등).
- 캐시: home, friends, search 무효화.
- RESP `200`: `{ friendUserId, selected: false }`.

### 4.9 `POST /v1/food-analyses` — 이미지 업로드 + 분석 시작 (multipart)
- 요청(multipart): `image`(file), optional `{ source: "camera"|"gallery" }`.
- 검증: MIME(jpeg/png/webp), 크기 상한(예 10MB, 초과 `413`).
- 흐름(**비동기 큐 권장**):
  - → 이미지 S3 업로드(`imageKey`, `imageUrl`).
  - DB: `FoodAnalysis` insert (`status=processing`).
  - 큐: 분석 잡 enqueue(analysisId).
  - RESP `202/200`: `{ analysisId, status:"processing", imageUrl }`.
  - (워커) EXT: Gemini `gemini-2.5-flash` 호출(이미지 + 프롬프트) → 4.10 형태로 정규화 → DB update(`completed`/`failed`, `result`, `needsReview`).
- **동기 빠른경로 옵션**: 분석이 즉시 끝나면 바로 `{ status:"completed", result }` 반환 가능(계약은 둘 다 허용).
- 스파이크: 업로드/분석 전용 **빡센 레이트리밋**, 큐로 Gemini 동시호출 상한 제어, 요청 흐름 차단 금지.

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
  - DB tx: `FoodRecord` insert + `FoodItem[]` bulk insert. `analysisId` 있으면 연결(`@unique`). `publishToFeed=true` 면 **본인 `postCount` +1**(활동수, 추천 정렬용).
  - 캐시: `home:{userId}`, `calendar:{userId}:{date}` 무효화.
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
 ├─ (도입 예정) 카카오 로그인 → AuthIdentity(kakao) upsert → sessionToken 발급
 │     ※ Figma 로그인 화면 미정. 게스트 대체/폴백 여부는 9번 결정.
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
- 카카오 **친구목록 매칭**: 비즈앱 검수 전까지 미동작 → 그 동안 "친구 0명" 추천은 seed로 대체(친구의 친구 추천은 범위 안).
- 카카오 **외** 로그인(구글 등) — 미논의(스키마는 `AuthIdentity`로 확장 대비).

---

## 7. 환경변수(.env, 서버 전용)
`DATABASE_URL`, `JWT_SECRET`, `GEMINI_API_KEY`, `S3_ENDPOINT`/`S3_BUCKET`/`S3_ACCESS_KEY`/`S3_SECRET_KEY`/`S3_REGION`, `REDIS_URL`(캐시·레이트리밋), `KAKAO_REST_API_KEY`/`KAKAO_ADMIN_KEY`(카카오 로그인·친구목록), `APP_TZ=Asia/Seoul`.
→ **절대 커밋 금지**(.gitignore 확인). 클라이언트는 Gemini/S3 직접 호출하지 않음.

---

## 8. 인덱스/성능 체크리스트
- `User.displayName` (친구 검색 ILIKE — 대량 시 `pg_trgm` GIN 고려).
- `FoodRecord(userId, eatenLocalDate)` (홈 오늘/캘린더 핫경로).
- `FoodAnalysis(userId, createdAt)`, `FoodItem(recordId)`, `FriendRelation @@unique + followingId`.
- 친구 목록 / 추천·검색 목록은 **무한 스크롤**(cursor 기반 더 불러오기 `?cursor=&limit=`). Gemini 호출은 큐로 동시성 상한.

---

## 9. 결정된 사항 / 남은 질문
**결정됨**
- 권장 칼로리: **프로필 설정 STEP 2 화면에서 `birthYear`(생년) 입력**받아 Mifflin BMR 계산. **활동량은 입력받지 않고** 서버 고정계수 `1.4` 사용.
- **로그인: 앱 시작 시 카카오톡 로그인 도입 예정**(그 외 방법 미논의). Figma 로그인 화면 디자인은 아직 없음.
- 친구는 **친구 목록 화면(`GET /v1/friends`)** 과 **추천/검색 화면(`GET /v1/friends/search`)** 두 개로 분리. 추천/검색에서 선택하면 친구 목록에 추가. 두 목록 모두 **무한 스크롤**(cursor 기반).
- 친구 **추천**(공통 정렬: **친구수↓ → 활동수(글수)↓**, 본인·이미 친구 제외):
  - **내 친구 0명** → **카카오톡 친구**(우리 앱 가입자) 기반.
  - **내 친구 1명+** → **친구의 친구** 기반.

**남은 질문**
1. **카카오 로그인 vs 익명 게스트**: 시작 화면에 카카오 로그인을 두면 이슈 #1의 "로그인 없이 v1"과 충돌 → 게스트 세션을 **대체할지/폴백으로 둘지** 결정 필요.
2. **친구가 상호관계인가 단방향인가**: 단방향이면 follow 시 본인 `friendCount`만 +1, 상호관계면 양쪽 +1(추천 친구수 집계 방식이 달라짐).
3. 카카오 **친구목록 동의**(친구 scope)는 비즈앱 검수 필요 — 미연동 시 0명 추천이 빈 화면이 됨(seed 대체 여부).
4. `GET /v1/me/profile` 미존재 시 **404 vs 200+null** (본 설계는 200+null 권장).
5. 분석 경로: **비동기 큐 기본** vs 동기 빠른경로 허용(본 설계는 둘 다 계약 허용, 큐 권장).
6. 캘린더 타임존: v1 **KST 고정** 가정 — 다국가 지원 시 사용자 tz 컬럼 필요.
