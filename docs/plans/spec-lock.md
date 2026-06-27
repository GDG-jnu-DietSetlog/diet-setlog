# diet-setlog — 구현 명세 잠금 (Spec Lock)

> **목적**: "누구나 plans를 읽고 만들면 완벽히 똑같은 앱이 나온다"를 보장한다.
> 기존 plans는 디자인·API·DB 뼈대가 단단하나, ① 문서 간 모순 ② "예:"로만 남은 값 ③ 툴링/버전 부재로 두 구현이 갈렸다. 이 문서가 그 **마지막 못**을 박는다.
>
> **권위 규칙**: 다른 plans 문서와 충돌하면 **이 문서가 최우선**이다. 계약의 기계 판독본은 [`openapi.yaml`](./openapi.yaml)이며, 산문과 충돌하면 `openapi.yaml`이 최우선이다.
> 출처 디자인: Figma "프롭 팀"(`WgmQmy0thsZO3mJ5gcO5zH`) — **읽기 전용**. 여기서 "디자인 추가 슬롯"으로 표기한 항목은 Figma 미반영 상태로 구현 측 합의값이다.

---

## 0. 우선순위 & 단일 진실원

| 영역 | 단일 진실원 |
|---|---|
| API 요청/응답 계약 | [`openapi.yaml`](./openapi.yaml) (기계 판독) → 이 문서 §5~6 (산문) |
| DB 스키마 | [`api-db-design.md §2.2`](./api-db-design.md) + 본 문서 §4 (델타) |
| 화면 좌표/토큰 | [`screens.md`](./screens.md) · [`design-system.md`](./design-system.md) |
| 플로우/범위 | [`dietsetlog-wireframe-plan.md`](./dietsetlog-wireframe-plan.md) + 본 문서 §2 |
| 추천 알고리즘 | [`decisions/.../0001`](../decisions/friend-recommendation/0001-recommendation-algorithm.md) + 본 문서 §8 (상수 확정) |
| 상수/버전/툴링 | **본 문서 §7·§10·§11** |

---

## 1. 모노레포 구조 (확정)

`CLAUDE.md`는 `app/`+`server/`를, plans는 `mobile/`+`api/`를 써서 갈렸다. **확정: `app/` + `server/`** (`CLAUDE.md` 기준). 백엔드는 REST API만이 아니라 큐 워커·S3 업로드·Gemini 호출·인증 등을 포함하므로 `api/`보다 `server/`가 정확하다.

```
diet-setlog/
├── app/             # Flutter 앱 (Android + iOS)
│   ├── lib/
│   ├── assets/fonts/    # Pretendard
│   └── pubspec.yaml
├── server/          # Node + TypeScript (Express + Prisma + 큐 워커)
│   ├── src/
│   ├── prisma/schema.prisma
│   ├── prisma/seed.ts
│   └── package.json
├── docs/
└── .claude/
```

> plans 본문에 남아 있던 `mobile/`·`api/` 표기는 모두 `app/`·`server/`로 정정됨. `CLAUDE.md`와 일치.

---

## 2. Tier 1 모순 해소 — 7개 확정

design-system §7의 열린 항목 + 디렉터리명을 모두 닫는다.

| # | 항목 | 기존 모순 | **확정 결정** |
|---|---|---|---|
| 1 | 나이(birthYear) 입력 | API는 필수, 온보딩 화면 없음 | **STEP2에 "년생" 필드 추가**(디자인 추가 슬롯). §3 매핑 참조. |
| 2 | STEP1 이름(displayName) | 받지만 저장 경로 없음 | **`PUT /v1/me/profile` 바디에 `displayName` 포함** → `User.displayName` 갱신. |
| 3 | 디렉터리 구조 | `app/server` vs `mobile/api` | **`app/` + `server/`** (`CLAUDE.md` 기준; 백엔드는 API만이 아님). §1. |
| 4 | memo 필드 | 화면엔 있고 계약엔 없음 | **`FoodRecord.memo String?`(≤200자) 추가**, `POST /v1/food-records` 바디에 `memo?` 포함. |
| 5 | 끼니 칩 | 화면 3개(간식 없음) vs enum/캘린더 4개 | **끼니 4종 확정**(`breakfast/lunch/dinner/snack`). 기록작성 화면에 **간식 칩 추가**(디자인 추가 슬롯). |
| 6 | 피드(좋아요/댓글) | 디자인 완비, API/DB 없음 | **v1 범위 포함**. §4·§5에 모델·엔드포인트 신설. |
| 7 | 캘린더 친구추가 UI | 디자인엔 있고 보드는 "제거" | **제거 확정**. 월간 달력 우상단 친구추가 아이콘·팝업·타인 달력 보기는 구현하지 않음. |
| 8 | bottom nav "프로필" 탭 | 탭은 4개(홈/카메라/캘린더/프로필)인데 **프로필 화면 스펙이 없음** | **v1: 프로필 탭은 렌더하되 탭 동작 no-op(비활성)**. 별도 프로필 화면은 v1 범위 밖(Figma 프레임 없음). 홈 진입 탭은 홈, 카메라=촬영, 캘린더=캘린더만 활성. |

---

## 3. 온보딩 STEP 매핑 (확정)

| STEP | 화면(Figma) | 입력 필드 | API |
|---|---|---|---|
| STEP1 | `1:643` 프로필1 | `displayName`(이름, 1~50자) | 클라 draft |
| STEP2 | `1:36` 프로필2 | `gender`, **`birthYear`(년생, 신규)**, `heightCm`, `currentWeightKg` | 클라 draft |
| STEP3 | `1:74` 프로필3 | `targetWeightKg`, `targetDate` | **`PUT /v1/me/profile`** |

- STEP3 "시작하기"가 STEP1·2 draft를 합쳐 한 번에 전송한다.
- **요청 바디(확정)**: `{ displayName, gender, birthYear, heightCm, currentWeightKg, targetWeightKg, targetDate }`.
- 서버: `displayName`→`User.displayName`, 나머지→`Profile`(upsert). 동시에 `User.goalDirection`·`User.ageBucket` 파생 갱신(§8).
- **STEP2 년생 UI(디자인 추가 슬롯)**: 키/몸무게 필드와 동일 규격(342×48, radius12). 입력 방식 = 숫자 키패드 4자리 또는 연도 휠 피커. 라벨 "출생연도", 단위 표기 "년". 위치는 성별 토글과 키 필드 사이(입력 그룹 세로 gap 36 유지).

---

## 4. 데이터 모델 — 추가/변경 (api-db-design §2.2 델타)

기존 Prisma 스키마에 **아래만 추가/변경**한다. 나머지는 api-db-design 그대로.

```prisma
model FoodRecord {
  // ... 기존 필드 유지 ...
  memo          String?                            // 신규: 기록 메모(≤200자)
  likeCount     Int        @default(0)             // 신규: 피드 좋아요 수(denorm)
  commentCount  Int        @default(0)             // 신규: 피드 댓글 수(denorm)
  likes         PostLike[]
  comments      PostComment[]
  // publishedToFeed=true 인 레코드가 곧 "피드 글(Post)"이다. 별도 Post 테이블 없음.
}

// 피드 좋아요 (멱등: 한 사람이 한 글에 1회)
model PostLike {
  recordId  String
  userId    String
  createdAt DateTime   @default(now())
  record    FoodRecord @relation(fields: [recordId], references: [id], onDelete: Cascade)
  user      User       @relation("postLiker", fields: [userId], references: [id], onDelete: Cascade)

  @@id([recordId, userId])                          // 멱등 좋아요
  @@index([userId])
}

// 피드 댓글
model PostComment {
  id        String     @id @default(uuid())
  recordId  String
  userId    String
  body      String                                  // ≤300자
  createdAt DateTime   @default(now())
  record    FoodRecord @relation(fields: [recordId], references: [id], onDelete: Cascade)
  user      User       @relation("postCommenter", fields: [userId], references: [id], onDelete: Cascade)

  @@index([recordId, createdAt])                    // 글별 댓글 페이징
}

model User {
  // ... 기존 필드 유지 ...
  likesGiven    PostLike[]    @relation("postLiker")
  commentsMade  PostComment[] @relation("postCommenter")
}
```

- **마이그레이션**: 위 3개(컬럼 추가 + 테이블 2개)를 `prisma migrate dev --name add_feed_memo`로 단일 마이그레이션.
- 좋아요/댓글 시 `FoodRecord.likeCount`/`commentCount`를 트랜잭션 내 증감(denorm, N+1 방지).

---

## 5. API — 추가/변경 + 미해결(§9) 확정

### 5.1 기존 §9 열린 질문 — 전부 확정

| §9 질문 | **확정** |
|---|---|
| Q4: `GET /me/profile` 미존재 응답 | **`200 + { profile: null }`** (404 금지). 앱 분기 단순화. |
| Q5: 분석 경로 비동기 vs 동기 | **비동기 큐 + 폴링만**(동기 빠른경로 폐기). `POST /v1/food-analyses` 는 항상 `202 { status:"processing" }` 반환 → 폴링. 재현성 위해 단일 경로. |
| Q6: 타임존 | **KST(`Asia/Seoul`) 고정**. `eatenLocalDate` = `eatenAt`의 KST date. |

### 5.2 신규 엔드포인트 (피드)

| # | Method | Path | 인증 | 캐시 |
|---|---|---|---|---|
| 13 | GET | `/v1/feed?cursor=&limit=` | Bearer | Redis 30s |
| 14 | POST | `/v1/posts/{recordId}/like` | Bearer | 무효화: feed,home |
| 15 | DELETE | `/v1/posts/{recordId}/like` | Bearer | 무효화: feed,home |
| 16 | GET | `/v1/posts/{recordId}/comments?cursor=&limit=` | Bearer | - |
| 17 | POST | `/v1/posts/{recordId}/comments` | Bearer | 무효화: feed |

- **`GET /v1/feed`**: `publishedToFeed=true` 인 글 중 **(나 ∪ 내가 follow한 사람)** 의 것을 `createdAt desc` 정렬. keyset 커서 `(createdAt, id)`. 각 글 = `FeedPost` 스키마(§6). 필터칩(전체/아침/점심/저녁)은 `?mealType=` 옵션.
- **좋아요**: `POST`=멱등 insert + 대상글 `likeCount+1`(이미 있으면 변동 없음). `DELETE`=삭제 시에만 `-1`. RESP `{ recordId, liked, likeCount }`.
- **댓글 목록**: `createdAt asc`, keyset, 기본 limit 20. RESP `{ comments: [Comment], nextCursor }`.
- **댓글 작성**: 바디 `{ body }`(1~300자, zod). RESP `201 { comment }` + 글 `commentCount+1`.
- 본인/친구 글 외 타인 글 직접 접근은 `404`(피드 노출 범위 밖 글 보호).

### 5.3 변경 엔드포인트

- **`PUT /v1/me/profile`**: 요청 바디에 **`displayName` 추가**(§3). 응답 `profile` 객체에 `displayName`·`birthYear` 포함(§6).
- **`POST /v1/food-records`**: 요청 바디에 **`memo?` 추가**(≤200). 응답 `record`·`dailySummary`에 반영.
- **`GET /v1/calendar/daily-summary`** 응답의 끼니 그룹 `recordsByMeal`는 **`snack` 키 포함**(4종).

---

## 6. 응답 객체 스키마 (전부 확정)

기존 문서가 이름만 언급한 중첩 객체의 **필드를 못 박는다**. (타입 표기: `s`=string, `i`=int, `f`=float, `b`=bool, `?`=nullable, `dt`=ISO8601, `d`=YYYY-MM-DD)

```jsonc
// 공통 매크로
Macros            = { proteinG:f, carbsG:f, fatG:f }

// 끼니 enum
MealType          = "breakfast" | "lunch" | "dinner" | "snack"

// ── GET /v1/me/profile (있음) / PUT /v1/me/profile ──
ProfileResponse   = {
  profile: {
    displayName:s, gender:"male"|"female"|"other", birthYear:i,
    heightCm:f, currentWeightKg:f, targetWeightKg:f, targetDate:d
  } | null,                              // 없으면 profile:null (200)
  dailyCalorieTarget:i, weeklyWeightDelta:f
}

// ── GET /v1/home ──
HomeResponse      = {
  currentUser: { id:s, displayName:s, avatarUrl:s? },
  todaySummary: {
    date:d, calorieTarget:i, totalCalories:i, macros:Macros,
    remainingCalories:i, progressRatio:f            // 0.0~1.0+ (목표 대비)
  },
  friendsCertifiedToday: [                          // 오늘 기록 1건+ 인 내 친구
    { id:s, displayName:s, avatarUrl:s?, certifiedAt:dt }
  ],
  recentRecords: [ FoodRecordCard ]                 // 최신 N=10, eatenAt desc
}

// ── 공통 카드(홈/캘린더 공용) ──
FoodRecordCard    = {
  id:s, title:s, imageUrl:s?, mealType:MealType, eatenAt:dt,
  totalCalories:i, macros:Macros, memo:s?, publishedToFeed:b,
  likeCount:i, commentCount:i,
  items: [ FoodItem ]
}
FoodItem          = { id:s, name:s, amount:s?, calories:i, proteinG:f, carbsG:f, fatG:f, sortOrder:i }

// ── POST /v1/food-analyses / GET /v1/food-analyses/{id} ──
AnalysisResponse  = {
  analysisId:s, status:"processing"|"completed"|"failed", imageUrl:s,
  result: AnalysisResult?,                          // completed 일 때만
  needsReview:b?,                                   // completed 일 때
  errorCode:s?, message:s?                          // failed 일 때
}
AnalysisResult    = {                               // §9 Gemini 정규화 결과
  dishName:s, totalCalories:i, macros:Macros,
  items: [ { name:s, amount:s?, calories:i, proteinG:f, carbsG:f, fatG:f } ],
  confidence:f, notes:s?
}

// ── POST /v1/food-records ──
RecordCreateResponse = {
  recordId:s, record: FoodRecordCard,
  dailySummary: {                                   // 그날 갱신 요약(홈/캘린더 즉시 반영)
    date:d, calorieTarget:i, totalCalories:i, macros:Macros, remainingCalories:i
  }
}

// ── GET /v1/calendar/daily-summary ──
CalendarDayResponse = {
  date:d, calorieTarget:i, totalCalories:i, macros:Macros,
  progressPercent:i,                                // 도넛 "70 %" = round(totalCalories/calorieTarget*100)
  recordsByMeal: {                                  // 4 키 항상 존재(없으면 [])
    breakfast:[FoodRecordCard], lunch:[FoodRecordCard],
    dinner:[FoodRecordCard], snack:[FoodRecordCard]
  }
}

// ── GET /v1/friends ──
FriendsResponse   = {
  friends: [ { id:s, displayName:s, avatarUrl:s?, mutualFriendCount:i, certifiedToday:b } ],
  nextCursor:s?
}

// ── GET /v1/friends/search ──
FriendSearchResponse = {
  users: [ { id:s, displayName:s, avatarUrl:s?, followerCount:i, postCount:i, mutualFriendCount:i, selected:b } ],
  nextCursor:s?
}

// ── GET /v1/feed ──
FeedResponse      = { posts: [ FeedPost ], nextCursor:s? }
FeedPost          = {
  recordId:s, author: { id:s, displayName:s, avatarUrl:s? },
  title:s, imageUrl:s, mealType:MealType, eatenAt:dt,
  totalCalories:i, macros:Macros, memo:s?,
  likeCount:i, commentCount:i, likedByMe:b,
  previewComments: [ Comment ]                      // 최신 2개
}
Comment           = { id:s, author:{ id:s, displayName:s, avatarUrl:s? }, body:s, createdAt:dt }

// ── 공통 에러 ──
ErrorResponse     = { error: { code:s, message:s, fields: { [k:s]:s }? } }
```

---

## 7. 상수 & 검증 범위 잠금 (전부 "예:" 제거)

| 항목 | **확정값** |
|---|---|
| **JWT** | HS256, 만료 **365일**, 잔여 **<30일 시 슬라이딩 재발급**. payload `{ sub, ver, iat, exp }`. |
| **게스트 displayName** | `"user-" + 6자리 소문자 영숫자`(base36, 충돌 시 재생성). |
| **레이트리밋** (userId+IP) | 전역 **120 req/min**, 분석 업로드 **10 req/min**, `POST /sessions/guest` **5 req/min/IP**, 댓글 **30/min**. 초과 `429` + `Retry-After`. |
| **이미지 업로드** | MIME `image/jpeg|png|webp`, **최소 1KB · 최대 10MB**(초과 `413`). |
| **분석 폴링(앱)** | 간격 **1.5s**, 지수백오프 ×1.5(최대 6s), **최대 20회(~60s)** 후 실패 처리. |
| **검색 debounce** | **300ms**. |
| **캐시 TTL** | home 45s · friends 45s · calendar 30s · feed 30s · friends/search 추천리스트 **4h**. |
| **칼로리 clamp** | `dailyCalorieTarget` **min 1200 · max 5000**. |
| **활동계수(TDEE)** | 고정 **1.4**(활동량 미입력). |
| **지방 환산** | **7700 kcal/kg**. |
| **페이지네이션** | `limit` 기본 **20 · 최대 50**. `nextCursor` = **base64url(JSON)** keyset 토큰. null=끝. |
| **검증 범위(zod)** | `displayName` 1~50 · `birthYear` 1920~(올해−14) · `heightCm` 80~250 · `weightKg` 20~400 · `targetDate` 미래 & ≤2년 · `memo` 0~200 · `title` 1~50 · 댓글 `body` 1~300. |
| **숫자 정합** | `items` 합과 `totalCalories`/`macros` 불일치는 **경고만**(사용자 수정 우선, 저장 차단 안 함). |

**에러 코드 enum(확정)**: `VALIDATION_FAILED`(400) · `UNAUTHORIZED`(401) · `FORBIDDEN`(403) · `NOT_FOUND`(404) · `CONFLICT`(409) · `PAYLOAD_TOO_LARGE`(413) · `ANALYSIS_FAILED`(422) · `RATE_LIMITED`(429) · `INTERNAL`(500). 분석 실패 `errorCode`: `IMAGE_UNREADABLE` · `NO_FOOD_DETECTED` · `MODEL_TIMEOUT` · `MODEL_ERROR`.

---

## 8. 추천 알고리즘 — P0 상수 잠금

ADR 0001은 "정렬키 우선순위 vs 가중합" 두 구현을 허용했다. **재현성을 위해 v1은 정렬키 방식으로 단일화**한다(가중합 전환은 P1+, 별도 ADR).

- **정렬키(확정)**: `mutualFriendCount DESC → goalSimilarity DESC → activityRecency DESC → followerCount DESC → id ASC`. (P0엔 mutual≈0이라 goalSimilarity가 사실상 1순위)
- **goalSimilarity(me, c) ∈ [0,1]**:
  ```
  0.40·[goalDirection 동일] + 0.25·clamp(1−|Δw_me−Δw_c|/NORM_w)
+ 0.20·[ageBucket 동일]     + 0.15·clamp(1−|cal_me−cal_c|/NORM_cal)
  ```
  - **`NORM_w = 1.0`** (kg/주), **`NORM_cal = 800`** (kcal). `clamp`는 [0,1].
  - `goalDirection`: `sign(targetWeightKg − currentWeightKg)` → `lose`(<0)·`maintain`(0)·`gain`(>0).
  - **`ageBucket = floor(birthYear / 10) * 10`** (예 1993→1990).
- **activityRecency** = `0.5·min(postCount,20)/20 + 0.5·[lastPostedAt ≤ now−7d 이면 1, 아니면 0]`.
- **alreadyShownPenalty**: 후보에서 `FriendRecFeedback.action ∈ {dismissed, hidden}` 인 사용자 **제외**. `shown`은 유지(정렬키 방식이라 페널티 점수 대신 제외/유지로 단순화).
- **후보 생성 LIMIT**: FoF **200** · 카카오 전체(검수 후) · 폴백(`goalDirection=me ∧ ageBucket=me`) **100**, 부족 시 `lastPostedAt` 최신 **100** 보강. `statement_timeout = 500ms`. **슈퍼노드 degree cap = 1000**(초과 친구는 2-hop 확장 제외).
- **랭킹 캐시**: 좁힌 후보 점수 정렬 → Redis **TTL 4h** → 페이징은 캐시 리스트 offset. follow/unfollow·새 글 시 해당 유저 추천 캐시 무효화.
- **seed 사용자**(`prisma/seed.ts`): **30명**, 목표방향 lose/maintain/gain ≈ 5:2:3, ageBucket 1980~2000 분포, `postCount` 1~30 랜덤, `lastPostedAt` 최근 14일 내 분산. 폴백이 의미 있게.

---

## 9. Gemini 프롬프트 (원문 확정)

서버 워커가 `gemini-2.5-flash`에 보내는 프롬프트. **이 문구를 그대로 사용**(재현성 핵심). `responseMimeType: "application/json"` + 아래 schema 강제.

**System / instruction:**
```
You are a Korean nutrition analysis assistant. Analyze the food in the image and
return ONLY a JSON object. Estimate per-100g-realistic values for a single served
portion shown. Use Korean dish/ingredient names (한글). All macro/calorie numbers
are grams/kcal as integers except confidence. If the image has no recognizable
food, return dishName:"", totalCalories:0, empty items, confidence:0.
Do not include any text outside the JSON.
```

**Response schema (강제):**
```json
{
  "type":"object",
  "properties":{
    "dishName":{"type":"string"},
    "totalCalories":{"type":"integer"},
    "macros":{"type":"object","properties":{
      "proteinG":{"type":"number"},"carbsG":{"type":"number"},"fatG":{"type":"number"}},
      "required":["proteinG","carbsG","fatG"]},
    "items":{"type":"array","items":{"type":"object","properties":{
      "name":{"type":"string"},"amount":{"type":"string"},
      "calories":{"type":"integer"},"proteinG":{"type":"number"},
      "carbsG":{"type":"number"},"fatG":{"type":"number"}},
      "required":["name","calories","proteinG","carbsG","fatG"]}},
    "confidence":{"type":"number"},
    "notes":{"type":"string"}
  },
  "required":["dishName","totalCalories","macros","items","confidence"]
}
```

**정규화/판정 규칙(서버):**
- 모델 JSON을 그대로 `geminiRaw`에 저장, 위 schema로 검증 후 `result`에 정규화.
- **`needsReview = true`** 조건: `confidence < 0.6` **또는** `items` 비어 있음 **또는** `totalCalories == 0` 인데 `dishName != ""`.
- `dishName == "" && items == []` → `status="failed"`, `errorCode="NO_FOOD_DETECTED"`.
- 모델 타임아웃(15s) → `MODEL_TIMEOUT`, 파싱 실패 → `MODEL_ERROR`.

---

## 10. 툴링 & 버전 잠금

### 10.1 app/ (Flutter)
- **Flutter 3.24.x (stable) · Dart 3.5.x**. `flutter --version`로 고정, `.fvmrc` 또는 README에 명시.
- 핵심 패키지(`pubspec.yaml`, 정확 버전 lock):
  | 패키지 | 버전 | 용도 |
  |---|---|---|
  | `flutter_riverpod` | ^2.5.1 | 상태관리(session/profile/analysis/record/calendar/friend/feed provider 분리) |
  | `go_router` | ^14.2.0 | 라우팅(선언적) |
  | `dio` | ^5.4.0 | HTTP 클라이언트(인터셉터로 Bearer 주입) |
  | `flutter_secure_storage` | ^9.2.0 | sessionToken 저장 |
  | `image_picker` | ^1.1.0 | 카메라/갤러리 |
  | `cached_network_image` | ^3.3.0 | 이미지 캐시 |
  | `freezed` + `json_serializable` | ^2.5 / ^6.8 | 불변 모델 + JSON(코드 생성) |
  | `flutter_screenutil` | ^5.9.3 | 반응형(§11) |
  | `intl` | ^0.19.0 | 날짜/숫자 포맷(KST) |
  | `table_calendar` | ^3.1.2 | 월간 캘린더 그리드 |
  | `iconify_flutter` | ^0.0.7 | iconify 아이콘(solar/uit/iconamoon 등) |
- 모델 생성: `dart run build_runner build --delete-conflicting-outputs`.

### 10.2 server/ (Node + TS)
- **Node 20 LTS · TypeScript 5.5.x · ES modules · 2-space indent**.
- 핵심 패키지(`package.json`):
  | 패키지 | 버전 | 용도 |
  |---|---|---|
  | `express` | ^4.19.2 | 라우팅 |
  | `prisma` / `@prisma/client` | ^5.18 | ORM/마이그레이션 |
  | `zod` | ^3.23 | 입력 검증 |
  | `jsonwebtoken` | ^9.0.2 | JWT 서명/검증 |
  | `bullmq` (+ `ioredis`) | ^5.12 | 분석 비동기 큐. ⚠️ 연결은 **인스턴스 말고 옵션 객체**로(번들 ioredis 타입충돌 회피, §13.5-13) |
  | `rate-limit-redis` + `express-rate-limit` | ^4.2 / ^7.4 | 레이트리밋 |
  | `@google-cloud/storage` | ^7.12 | **GCS 업로드**(스토리지 = GCP, 로컬은 fake-gcs-server 에뮬레이터) |
  | `multer` | ^1.4.5-lts.1 | multipart |
  | `@google/generative-ai` | ^0.21 | Gemini |
  | `vitest` | ^2.0 | 테스트(단일 채택, "또는 npm test" 모호성 제거) |
- 스크립트: `dev`(tsx watch) · `build`(tsc) · `test`(vitest) · `lint`(eslint) · `prisma:migrate` · `prisma:seed`.

---

## 11. Flutter 반응형 / 폰트 / 아이콘

- **반응형 전략**: `flutter_screenutil` 의 `designSize: Size(390, 844)`. screens.md의 절대 좌표/치수는 **`.w`/`.h`/`.r`/`.sp`** 로 변환해 비율 스케일. 즉 좌표는 390×844 기준 그대로 쓰되 기기 폭에 비례. (피드만 높이 1381 스크롤)
- **폰트**: **Pretendard**(OFL 라이선스). `app/assets/fonts/`에 weight별 ttf 배치(`Pretendard-Bold/SemiBold/Medium/Regular`), `pubspec.yaml` fontFamily 선언. 출처: 공식 Pretendard 배포(릴리스 ttf). 전 화면 공통.
- **아이콘**: `iconify_flutter` 로 Figma 명시 아이콘을 그대로 매핑 — `solar:camera-linear`, `uit:calender`, `iconamoon:profile-fill`, `weui:back`, `mdi:bell`, `tabler:heart-filled`, `mynaui:chat`, `mi:send`, `solar:home-*`(홈 탭). 색/크기는 design-system 토큰 적용.
- **숫자/날짜 포맷**: 천단위 콤마(`1,650`), 날짜 `intl` `Asia/Seoul`. 캘린더 표기 "2025년 5월 24일 토요일" 형식.

---

## 12. 잔여 "디자인 추가 슬롯" (Figma 미반영, 구현 합의값)

Figma는 읽기 전용이라 아래는 **문서·구현 합의로 확정**하되, 추후 디자인 보드 갱신 대상이다(보드 TODO와 일치).

1. STEP2 "년생" 입력 필드(§3) — 보드 노트 #5와 일치.
2. 기록작성 화면 "간식" 끼니 칩(4번째) — §2-5.
3. 캘린더 친구추가 UI **제거** — §2-7(보드 노트와 일치).

> 위 3개는 Figma 변경 없이 구현하며, "디자인 보드 갱신 후 좌표 동기화"를 후속 작업으로 남긴다.

---

## 13.5 파일럿 슬라이스에서 발견된 계약 보강 (구현으로 검증됨)

`server/` 파일럿(session→profile→home)을 실제로 빌드·실행하며 드러난, 문서만으론 안 보였던 구멍들. **아래는 구현 시 따를 확정값**이다.

1. **`gender="other"`의 BMR 상수가 명세에 없음** — Mifflin 식은 male(+5)/female(−161)만 정의. → **확정: other = 두 상수의 평균 `−78`** 사용. (`server/src/lib/calorie.ts`)
2. **stateless ↔ tokenVersion 무효화 긴장** — "요청마다 DB 조회 없이 서명만 검증"(stateless)과 "tokenVersion 불일치 거부"(DB 조회 필요)가 충돌. → **확정: authGuard는 서명만 검증(무DB). tokenVersion 체크는 민감 동작(로그아웃/탈취 대응)에서만 별도 수행.**
3. **`GET /v1/home` 인데 profile 미존재** — 부트스트랩이 보장하지만 방어 필요. → **확정: profile 없으면 `404 NOT_FOUND`("profile required").**
4. **`profile: null` 일 때 나머지 두 필드 값** — `ProfileResponse`는 `dailyCalorieTarget`·`weeklyWeightDelta`를 항상 요구. → **확정: profile 없으면 둘 다 `0`.**
5. **Prisma enum 단일행 표기 불가** — api-db-design §2.2의 `enum Gender { male female other }` 압축 표기는 **실제 Prisma에서 컴파일 안 됨**(값마다 개행 필수). → 스키마 작성 시 멀티라인. (문서 스니펫은 가독성용, 실제 코드는 멀티라인)
6. **`targetDate` 직렬화** — 응답에서 `YYYY-MM-DD`(date-only) 문자열로 직렬화 확정(Prisma `@db.Date` → `toISOString().slice(0,10)`).
7. **백엔드 실행 = Docker 전체** — `server/docker-compose.yml`로 DB+서버를 함께 띄운다(`docker compose up --build`, 컨테이너 시작 시 `prisma migrate deploy` 자동). 호스트엔 Node만 있으면 됨. Redis/MinIO는 후속 wave에서 같은 compose에 추가.

**records+calendar 도메인(#13)에서 추가 발견:**

8. **`FoodRecord.imageUrl`은 요청 바디에 없음** — `POST /v1/food-records` 바디에 imageUrl 필드가 없다. → **확정: `analysisId`로 연결된 `FoodAnalysis.imageUrl`을 승계**(analysisId 없으면 null). (`records.routes.ts`)
9. **날짜 검증은 regex만으론 부족 → 500 유발** — `^\d{4}-\d{2}-\d{2}$`는 `2026-13-99`·`2026-02-30`(JS가 3-02로 롤오버)을 통과시켜 `new Date` Invalid → Prisma 쿼리에서 500. → **확정: 모든 날짜 입력은 엄격검증(`isStrictYmd`: 파싱 후 왕복 일치)으로 `400` 반환.** `targetDate`(profile)·`date`(calendar) 모두 적용. (`lib/kst.ts`)
10. **CRLF 줄바꿈이 컨테이너 셸을 깨뜨림** — Windows 호스트에서 `git`이 `docker-entrypoint.sh`를 CRLF로 체크아웃하면 컨테이너 bash가 `$'\r'`로 깨짐. → **확정: 루트 `.gitattributes`로 `*.sh`·Dockerfile 등 LF 고정 + Dockerfile에서 `sed`로 CR 제거(2중 방어).**

> 파일럿+records 도메인을 실제로 빌드·실행하지 않았으면 8·9·10은 전부 런타임에서야 터졌을 구멍 — 특히 9는 명백한 500 버그였다.

**analyses 인프라 wave(#20)에서 추가 발견·결정:**

11. **스토리지 = GCS (S3 아님)** — 설계의 "S3 호환 스토리지"를 **Google Cloud Storage로 확정**(앱이 Gemini=구글이라 생태계 일관). SDK `@google-cloud/storage`, 로컬은 `fake-gcs-server` 에뮬레이터. env: `GCS_BUCKET`·`GCS_PROJECT_ID`·`GCS_API_ENDPOINT`(에뮬레이터)·`GCS_PUBLIC_URL`. 실제 배포는 서비스계정(`GOOGLE_APPLICATION_CREDENTIALS`). api-db-design §7의 `S3_*`는 `GCS_*`로 대체.
12. **`FoodAnalysis`에 이미지 MIME 미저장** — 워커가 Gemini 호출 시 contentType이 필요한데 스키마에 없음. → **확정: `imageKey` 확장자에서 MIME 유도**(jpg/png/webp). (재업로드/재처리에 충분)
13. **BullMQ ↔ ioredis 번들 충돌** — bullmq가 자체 ioredis를 번들해 top-level ioredis 인스턴스를 `connection`에 넘기면 타입 불일치. → **확정: 연결은 인스턴스 말고 `{ host, port }` 옵션 객체**로 넘겨 BullMQ가 내부 생성하게 한다. (`lib/redis.ts`)
14. **Gemini 키 없이도 전 구조 검증** — 워커·큐·GCS·폴링은 키와 무관. → **목(mock) Gemini로 골격 완성**(`usingMockGemini`), 키 주입 시 동일 코드로 live 전환(프롬프트는 §9 원문).

> 분석 wave를 목으로라도 실제 실행했기에 11~14가 드러났다. 스토리지 제공자(11)는 코드 한 줄이 아니라 SDK·compose·env 전반을 바꾸는 결정 — 늦게 발견했으면 비쌌다.

---

## 13. 재현성 자가 체크리스트

두 팀이 이 문서 + openapi.yaml + 기존 plans로 빌드했을 때 동일해야 하는 것:

- [ ] 디렉터리: `app/` + `server/`.
- [ ] 온보딩 3 STEP 필드/순서/저장 경로 동일(이름·년생 포함).
- [ ] 모든 API 요청·응답 JSON 필드가 §6 / openapi.yaml과 1:1.
- [ ] `dailyCalorieTarget` 계산 결과가 동일(같은 입력 → 같은 정수). 상수 1.4 / 7700 / clamp 1200~5000.
- [ ] 친구 추천 정렬이 동일(정렬키 + goalSimilarity NORM_w=1.0 / NORM_cal=800 / decade bucket).
- [ ] Gemini 프롬프트·schema·needsReview 규칙 동일.
- [ ] 피드/좋아요/댓글 동작 동일.
- [ ] 매직넘버(레이트리밋·TTL·폴링·페이징·검증범위) 동일.
- [ ] 패키지/버전 동일 → 빌드 산출물 동등.
