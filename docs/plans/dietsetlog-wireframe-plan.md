# Dietlog Figma 와이어프레임 구현 계획

> 출처: 이슈 [#1](https://github.com/GDG-jnu-DietSetlog/diet-setlog/issues/1) `dietsetlog-wireframe-plan.md`.
> 구현 흐름/화면 범위의 단일 기준 문서. API 흐름·DB 스키마 상세는 [api-db-design.md](./api-db-design.md) 참고.
>
> ⚠️ **확정 델타(우선)**: [spec-lock.md](./spec-lock.md). ① 프로필 STEP2에 **출생연도(birthYear)** 추가 ② STEP1 이름은 `PUT /v1/me/profile`로 저장 ③ **피드(좋아요/댓글) v1 범위 포함** ④ 끼니 **4종**(간식 포함) ⑤ 캘린더 친구추가 제거.

## Summary
- 빈 repo에 `app/` Flutter 앱과 `server/` Node/Express TypeScript 백엔드(REST API + 큐 워커)를 함께 만든다.
- Flutter UI는 Figma `WgmQmy0thsZO3mJ5gcO5zH / Page 1 / 완성`의 디자인을 그대로 구현한다.
- 현재 구현 범위는 익명 세션 → 프로필 설정 → 홈 → 음식 촬영/갤러리 업로드 → Gemini 분석 → 기록 저장 → 캘린더 화면 표시 → 친구 검색까지다.
- 캘린더는 bottom nav 버튼으로 화면을 띄우는 것까지만 구현한다. 끼니별 기록 클릭, 음식 상세 화면, 상세 화면의 수정 버튼/수정 플로우는 이번 단계에서 제외한다.
- v1은 로그인 없이 전체 구현 범위 기능을 사용한다. 이후 Google/Kakao 로그인으로 익명 계정을 연결할 수 있게 API와 DB를 설계한다.
- 음식 분석은 서버에서 Gemini API `gemini-2.5-flash`를 호출한다.

## User Flows
- First-run profile:
  - 앱 최초 실행 → `POST /v1/sessions/guest` → 세션 저장 → 프로필 STEP 화면 → profile 저장 → 홈 이동.
- Food analysis:
  - 홈/카메라 탭 → 촬영 또는 갤러리 선택 → 이미지 업로드 → Gemini 분석 → 분석 결과 편집 화면.
- Food record:
  - 분석 결과 확인/수정 → 기록 저장 → 홈 요약과 캘린더 화면 데이터에 반영.
- Calendar:
  - bottom nav 캘린더 버튼 → 캘린더 화면 표시 → 날짜별 섭취 요약과 끼니별 기록 리스트를 조회/렌더링.
  - 끼니별 기록 row 클릭, 음식 상세 화면 이동, 상세 수정 플로우는 제외한다.
- Friend:
  - 친구 검색 → 사용자 선택 → 홈의 친구 영역에 반영.
- Returning user:
  - 저장된 익명 세션 복구 → profile 존재 시 홈 진입 → 기록/친구 상태 로드.

## Screen Actions and API Behavior
- App bootstrap:
  - 앱 시작 시 로컬 secure storage에서 `sessionToken` 확인.
  - 토큰 없음: `POST /v1/sessions/guest`.
  - 기대 응답: `{ userId, sessionToken, isNewUser: true }`.
  - 토큰 있음: `GET /v1/me/profile`.
  - profile 없음: 프로필 설정 화면으로 이동. profile 있음: 홈으로 이동.

- 프로필 STEP 2 “다음” 버튼:
  - 입력값: `gender`, **`birthYear`(출생연도, BMR 계산용 — 디자인 추가 슬롯)**, `heightCm`, `currentWeightKg`.
  - 클라이언트 검증: 출생연도/키/몸무게 숫자 범위, 필수 선택값.
  - API 호출은 하지 않고 임시 profile draft에 저장한 뒤 STEP 3으로 이동한다.

- 프로필 STEP 3 “시작하기” 버튼:
  - 입력값: STEP 1·2 draft + `targetWeightKg`, `targetDate`.
  - 호출: `PUT /v1/me/profile`.
  - 요청: `{ displayName, gender, birthYear, heightCm, currentWeightKg, targetWeightKg, targetDate }`.
  - 기대 응답: `{ profile, dailyCalorieTarget, weeklyWeightDelta }`.
  - 성공 시 홈 화면으로 이동하고 profile provider를 갱신한다.
  - 실패 시 현재 화면에 에러를 표시하고 입력값은 유지한다.

- 홈 화면 “친구 추가하기” 버튼:
  - 친구 검색 화면으로 이동.
  - 초기 진입 시 `GET /v1/friends/search?q=`로 추천/seed 사용자 목록을 가져온다.
  - 기대 응답: `{ users: [{ id, displayName, mutualFriendCount, selected }] }`.

- 친구 검색 화면 검색 입력:
  - 입력 debounce 후 `GET /v1/friends/search?q={query}`.
  - 기대 응답은 동일한 `users` 배열.
  - 네트워크 실패 시 기존 결과를 유지하고 inline retry 상태를 표시한다.

- 친구 검색 화면 “선택/선택됨” 버튼:
  - 미선택 사용자는 `POST /v1/friends/{friendUserId}/follow`.
  - 선택된 사용자는 `DELETE /v1/friends/{friendUserId}/follow`.
  - 기대 응답: `{ friendUserId, selected }`.
  - 성공 시 해당 row와 홈 친구 영역 캐시를 갱신한다.

- Bottom nav 홈 버튼:
  - 홈 화면 이동.
  - 진입 시 `GET /v1/home`.
  - 기대 응답: `{ todaySummary, friendsCertifiedToday, currentUser, recentRecords }`.

- Bottom nav 카메라 버튼:
  - 음식 업로드 화면으로 이동.
  - 사용자는 카메라 촬영 또는 갤러리 선택 중 하나를 수행한다.
  - 이미지 선택 완료 후 `POST /v1/food-analyses` multipart 호출.
  - 요청: `image`, optional `{ source: "camera" | "gallery" }`.
  - 기대 응답: **항상 `202 { analysisId, status: "processing", imageUrl }`**(비동기 큐 단일 경로, [spec-lock §5.1](./spec-lock.md)).

- 음식 분석 로딩 화면:
  - 응답이 항상 processing이므로 곧바로 `GET /v1/food-analyses/{analysisId}`를 polling한다(1.5s 간격, 최대 20회).
  - completed 수신 시 기록 작성 화면으로 이동.
  - 기대 응답: `{ analysisId, status, imageUrl, result, needsReview }`.
  - 실패 상태 응답: `{ analysisId, status: "failed", errorCode, message }`.
  - 실패 시 재시도 버튼은 같은 이미지로 `POST /v1/food-analyses`를 다시 호출한다.

- 기록 작성 화면 “수정” 동작:
  - 음식명, 총 kcal, 탄단지, `FoodItem` 목록을 로컬 form state로 수정한다.
  - 수정 중에는 API 호출하지 않는다.

- 기록 작성 화면 “피드에 올리기” 버튼:
  - 호출: `POST /v1/food-records`.
  - 요청: `{ analysisId, mealType, eatenAt, title, totalCalories, macros, items, publishToFeed: true }`.
  - `macros`는 음식 기록 전체의 3대 영양소 합계다: `{ proteinG, carbsG, fatG }`.
  - 기대 응답: `{ recordId, record, dailySummary }`.
  - 성공 시 home/calendar cache를 갱신하고 홈 또는 캘린더로 이동한다.
  - 실패 시 form state를 유지하고 저장 실패 안내를 표시한다.

- Bottom nav 캘린더 버튼:
  - 캘린더 화면으로 이동한다.
  - 호출: `GET /v1/calendar/daily-summary?date=YYYY-MM-DD`.
  - 기대 응답: `{ date, calorieTarget, totalCalories, macros, recordsByMeal }`.
  - Figma의 “오늘 섭취 요약”, 탄단지, 끼니별 기록 리스트를 이 응답으로 렌더링한다.
  - 현재 단계에서는 끼니별 기록 row를 눌러도 상세 화면으로 이동하지 않는다.

- 캘린더 화면 날짜 이동/선택:
  - 선택 날짜 변경 시 `GET /v1/calendar/daily-summary?date=YYYY-MM-DD`를 새 날짜로 재호출한다.
  - 기록이 없으면 Figma 스타일을 유지한 빈 상태를 표시한다.

## Explicitly Out of Scope for Current Stage
- 캘린더 끼니별 기록 row 클릭 동작.
- `GET /v1/food-records/{recordId}` 상세 조회 화면.
- 음식 상세 화면 UI.
- 음식 상세 화면의 “수정하기” 버튼.
- 기존 기록 수정용 `PATCH /v1/food-records/{recordId}` 플로우.

## Key Changes
- Project structure:
  - `app/`: Flutter 앱, iOS/Android 우선, 카메라/갤러리 권한 포함.
  - `server/`: Express + TypeScript + Prisma + PostgreSQL (REST API + 분석 큐 워커).
  - 이미지 저장은 S3 호환 스토리지 사용.
- Flutter UI:
  - Figma 기준 design tokens를 추출한다: 색상, typography, radius, spacing, app bar, bottom nav, primary button, input, nutrition card.
  - 화면 구성은 `ProfileSetupFlow`, `HomeScreen`, `FoodCaptureScreen`, `AnalyzingScreen`, `FoodRecordEditScreen`, `CalendarScreen`, `FriendSearchScreen`, `FriendListScreen`, **`FeedScreen`(좋아요/댓글)**.
  - `FoodDetailScreen`과 기존 기록 수정 화면은 만들지 않는다.
  - 상태 관리는 `riverpod` 기준. session, profile, food analysis, food record, calendar, friend, **feed** provider를 분리한다([spec-lock §10.1](./spec-lock.md)).
- REST API:
  - session/profile/home/friend/food-analysis/food-record/calendar route를 만든다.
  - 모든 protected API는 익명 `sessionToken`을 Authorization bearer token으로 받는다.
  - Gemini API key와 S3 credentials는 서버 `.env`로만 관리한다.
  - 상세 조회/수정 endpoint는 이번 단계에서 구현하지 않는다.
- Data model:
  - `User`: 익명 사용자와 추후 OAuth 연결 정보.
  - `Profile`: 키/몸무게/목표/권장 kcal.
  - `FoodAnalysis`: 이미지 URL, 분석 상태, Gemini raw JSON, 구조화 결과.
  - `FoodRecord`: 사용자가 저장한 식단 기록의 대표 단위.
  - `FoodItem`: `FoodRecord` 안의 개별 음식 항목.
  - `FriendRelation`: follower/following 관계.
- Gemini result shape:
  - 서버는 모델 응답을 `{ dishName, totalCalories, macros: { proteinG, carbsG, fatG }, items, confidence, notes }`로 정규화한다.
  - 모델 응답이 불완전하면 `needsReview: true`를 반환하고 앱에서 수정 가능하게 한다.

## Test Plan
- User-flow verification playbook:
  - `first_run_profile`: 세션 생성, profile 저장, 홈 진입 검증.
  - `food_capture_analysis`: 이미지 선택, S3 업로드, Gemini 분석, 결과 화면 검증.
  - `food_record_confirmation`: 분석 결과 수정, `FoodRecord`/`FoodItem` 저장, 홈/캘린더 데이터 반영 검증.
  - `daily_calendar`: bottom nav 캘린더 버튼, 날짜별 요약 조회, 끼니별 리스트 렌더링 검증.
  - `friend_discovery`: 검색, 선택/해제, 홈 반영 검증.
  - `returning_user`: 앱 재실행 후 세션/profile/기록 복구 검증.
- Flutter:
  - `flutter analyze`.
  - API client/provider unit test.
  - widget test: 프로필 입력, 분석 로딩, 기록 수정/저장, 캘린더 렌더링.
  - integration test: 익명 세션 → 프로필 → 이미지 분석 → 기록 저장 → 캘린더 화면 반영 happy path.
  - 캘린더 row tap이 상세 이동을 하지 않는지 검증한다.
  - Figma 대비 시각 QA: 주요 화면을 390x844 기준으로 캡처해 비교.
- API:
  - `npm test` 또는 `vitest`.
  - Prisma migration 검증.
  - mocked Gemini client로 분석 성공/실패/불완전 JSON 테스트.
  - S3 upload는 local mock 또는 test bucket으로 검증.
- End-to-end acceptance:
  - 로그인 없이 current-stage 범위 기능이 동작해야 한다.
  - 각 버튼 클릭은 위에 정의한 API 호출 또는 화면 전환을 정확히 수행해야 한다.
  - 저장된 기록은 홈과 캘린더 화면에서 일관되게 표시되어야 한다.
  - UI는 Figma의 현재 와이어프레임과 동일한 구조와 시각 스타일을 유지해야 한다.

## Assumptions
- 이번 구현은 Flutter 앱과 REST API 서버를 모두 같은 repo에 만든다.
- API는 Node/Express TypeScript, DB는 PostgreSQL+Prisma, 이미지 저장은 S3 호환 스토리지를 사용한다.
- 클라이언트는 Gemini API를 직접 호출하지 않는다.
- v1의 친구 검색/피드는 실제 소셜 그래프가 아니라 API DB의 seed/mock 사용자로 기능 흐름을 먼저 완성한다.
- 디자인 가이드는 별도 재디자인 없이 Figma에 있는 현재 화면을 기준으로 삼는다.
