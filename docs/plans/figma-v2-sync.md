# Figma 2차 시안 동기화 작업 기록

## 작업 기준

- GitHub 원본 이슈: https://github.com/GDG-jnu-DietSetlog/diet-setlog/issues/73
- Linear 보조 이슈: https://linear.app/dietlog/issue/DIE-5/figma-2차-시안-diff-및-반영-계획
- 보호 브랜치: `feat/73-figma-v2-sync`
- Figma 파일: `프젝 팀` (`WgmQmy0thsZO3mJ5gcO5zH`)
- 시작 노드: `51:767` (확인 결과 `음식 업로드` 프레임 내부 status bar 인스턴스)
- 2차 시안 섹션: `6/27 2차 시안` (`51:1655`)
- 기준 문서: `docs/plans/screens.md`, `docs/plans/design-system.md`, `docs/plans/spec-lock.md`

## 현재 확인된 상태

- `develop`에서 직접 작업하지 않기 위해 보호 브랜치를 생성했다.
- 브랜치 생성 시점에 기존 미커밋 변경이 있었다. 내용은 카카오 로그인, 개발용 auth bypass, 프로필 인증 사용자 검증 관련 변경으로 보이며 되돌리지 않는다.
- Figma MCP 연결 완료. 계정 `Jaehyeon Hwang <jaehyeon7778@gmail.com>`에서 파일 메타데이터와 디자인 컨텍스트를 읽을 수 있다.
- Linear 연결 완료. 팀은 `Dietlog`(`DIE`, `bef24ffa-4067-410f-9570-4ce742516739`)로 확인했다.
- Linear에는 GitHub 이슈/PR 링크 중심으로 보조 기록을 남긴다.
- GitHub 기준으로 앱 wave 이슈 `#24`, `#26`, `#28`, `#30`, `#32`는 관련 PR이 merge됐지만 이슈가 열린 상태로 남아 있다.
- 현재 브랜치의 기존 코드 변경은 auth bypass와 누락 user 방어에 집중되어 있으며, profile/auth 단위 테스트는 통과했다.

## Figma 2차 프레임 인벤토리

| 화면군 | 2차 Figma frame | nodeId | 현재 판단 |
|---|---|---:|---|
| 로그인/온보딩 | 온보딩1~7 | `51:408`, `51:424`, `51:436`, `51:463`, `51:521`, `51:579`, `51:610` | 카카오 로그인/약관 화면은 이미 구현 흔적 있음. 나머지 온보딩 프레임은 추가 diff 필요 |
| 프로필 설정 | 프로필1~3 | `51:1328`, `51:315`, `51:361` | 기존 1차 프로필 STEP과 대응. 세부 토큰 diff 필요 |
| 홈 | 홈1, 홈1-1, 홈2 | `51:640`, `51:700`, `51:1240` | 홈1/홈1-1은 홈 empty 상태와 대응. 홈2는 친구 추가 화면 고도화 범위 |
| 음식 업로드 | 음식 업로드 ×3 | `51:744`, `51:765`, `51:797` | 촬영/분석/기록 작성 기존 플로우와 대응 |
| 기록 작성 확장 | 음식 업로드-추가 | `51:866` | AI 분석 항목 + 직접 입력 항목 UI. 현재 `RecordEditScreen`에 이미 다중 항목 구조 있음 |
| 업로드 완료 | 업로드 완료 | `51:977` | 기존 `RecordCompleteScreen`과 대응. 세부 토큰 diff 필요 |
| 피드 | 피드 | `51:1025`, `56:1392` | `51:1025`는 기본 친구 피드, `56:1392`는 날짜별 스토리 다시보기 변형 |
| 캘린더 | 캘린더 1, 캘린더 2 | `56:3309`, `56:1879` | 기존 월간/일별 요약보다 프레임 높이가 커짐. 세부 diff 필요 |
| 끼니 상세 | 끼니별 기록 자세히보기 | `56:2254` | 신규 화면. 기존 문서에서는 범위 밖이었으나 2차에서 명시됨 |

## 확인된 Figma diff

| 구분 | 현재 문서/구현 | 2차 Figma | 영향 범위 | 처리 |
|---|---|---|---|---|
| 시작 노드 | `51:767`을 2차 시안 대표 노드로 가정 | 실제로는 `음식 업로드` 프레임 내부 status bar | 문서 | 대표 섹션을 `51:1655`로 정정 |
| 로그인 | `LoginScreen` + Kakao login 작업 중 | `온보딩2`(`51:424`)에 390×844 카카오 로그인 화면, hero 이미지, yellow Kakao CTA | app/assets/auth | 구현 상태 확인 후 토큰/에셋만 보정 |
| 기록 작성 | `RecordEditScreen`은 다중 항목과 `snack` 포함 4끼니 enum 사용 | `음식 업로드-추가`(`51:866`)는 AI 분석 항목 + 직접 입력 항목, 3개 끼니 칩(아침/점심/저녁) | app/record, docs/spec | `spec-lock`의 4끼니가 우선. Figma 3칩은 그대로 복사하지 않고 유지 판단 |
| 일별 요약 상세 | `screens.md`는 끼니 row 상세 이동을 범위 밖으로 명시. 라우트 없음 | `끼니별 기록 자세히보기`(`56:2254`) 신규 상세 화면 | app/calendar, app/routing, API 계약 검토 | 새 GitHub 이슈로 분리 |
| 캘린더 | 기존 `CalendarScreen`에서 날짜 선택 시 `DailySummaryScreen`으로 push | 2차 `캘린더 1/2`(`56:3309`, `56:1879`)는 월간 달력 + 선택일 섭취 요약 + 끼니별 기록을 한 스크롤 화면에 통합 | app/calendar, app/routing | 별도 GitHub 이슈로 분리 |
| 홈 빈 친구 | 기존 홈은 친구 row + 큰 empty CTA 중심, 상단 앱 액션 없음 | 홈1(`51:640`)은 로고, 친구추가/알림 아이콘, `오늘 인증한 친구`, empty CTA, 플로팅 bottom nav 포함 | app/home, design icons | GitHub #80, 반영 |
| 홈 빈 게시물 | 기존 홈은 친구가 있으면 임시 여백 표시 | 홈1-1(`51:700`)은 친구 row 아래 회색 영역에 `최근 공유된 게시물이 없어요.` 표시 | app/home | GitHub #80, 반영 |
| 친구 추가 | 기존 `FriendSearchScreen`은 검색/추천 친구 플로우 있음 | 홈2(`51:1240`)는 검색바, 카카오 친구 찾기, 추천 친구, 하단 CTA의 별도 고도화 시안 | app/friends | GitHub #79, 반영 |
| 피드 기본 | 기존 `FeedScreen`은 일반 AppBar + 필터 + 카드 목록 | 피드(`51:1025`)는 로고/알림 헤더, 오늘 인증한 친구 story strip, 회색 배경, compact 카드/AI 칼로리 chip/그램 라벨 포함 | app/feed | GitHub #77, 반영 |
| 피드 날짜별 변형 | 기존 날짜별 피드/스토리 다시보기 라우트 없음 | 피드(`56:1392`)는 날짜 앱바, `스토리 다시보기`, 나의 기록/친구 기록 필터, dashed 인증 ring | app/feed, app/routing | GitHub #78, UI/라우트 반영 |

## 신규 작업 후보

| 우선순위 | 작업 | 근거 | 추적 |
|---|---|---|---|
| P1 | 끼니별 기록 상세 화면 추가 | 2차 Figma `56:2254`가 신규 화면으로 명시됨. 기존 문서에서는 범위 밖이라 구현/라우트 없음 | GitHub #74 |
| P1 | 캘린더 2차 통합 화면 리프레시 | 2차 `캘린더 1/2`는 월간/일별 요약을 한 화면에 통합하고 row CTA를 추가 | GitHub #75 |
| P2 | 홈 화면 2차 상태 반영 | 홈1/홈1-1 empty 상태와 상단 액션 추가 | GitHub #80 |
| P2 | 피드 화면 2차 기본 리프레시 | `51:1025` 기본 친구 피드 레이아웃 refresh | GitHub #77 |
| P3 | 친구 추가 화면 2차 고도화 | 홈2(`51:1240`) 카카오 친구 찾기/추천 친구 CTA | GitHub #79 |
| P3 | 날짜별 스토리 다시보기 피드 추가 | `56:1392` 날짜별 피드 변형. 라우팅/API 범위 확인 필요 | GitHub #78 |
| P3 | 로그인/온보딩 에셋·토큰 정합성 점검 | 카카오 로그인은 이미 구현됐으나 Figma hero/CTA 수치 대조 필요 | 기존 auth 변경 안정화 후 처리 |

## 구현 진행 로그

- GitHub #74: `MealDetailScreen`과 `/calendar/meal` 라우트를 추가했다.
  - 기존 `FoodRecordCard.items`, `macros`, `totalCalories`, `imageUrl`, `mealType`를 사용한다.
  - API에 macro target이 없어 상세 화면 보조값은 일일 calorie target을 30/40/30 kcal 비율로 환산한다. 서버가 macro target을 제공하면 교체한다.
- GitHub #75: `CalendarScreen`을 2차 시안 기준 통합 스크롤 화면으로 리프레시했다.
  - 월간 달력 아래에 선택일 섭취 요약과 끼니별 기록을 같은 화면에 표시한다.
  - 끼니 row의 `자세히 보기` CTA는 #74 상세 화면으로 연결한다.
- 390×844 widget test에서 발견된 캘린더 요약/끼니 row overflow를 수정했다.
  - 섭취 요약 도넛과 수치 카드를 세로 배치로 조정했다.
  - 요약 수치와 macro chip은 좁은 폭에서도 축소되도록 처리했다.
  - 끼니 row 헤더는 고정 한 줄 대신 줄바꿈 가능한 구조로 변경했다.
- #74/#75 회귀 테스트를 `app/test/calendar_test.dart`에 추가했다.
  - 캘린더 통합 화면이 선택일 요약, 끼니별 기록, 상세 CTA를 렌더링하는지 확인한다.
  - 끼니 상세 화면이 음식명, item, 영양 요약, 닫기 CTA를 렌더링하는지 확인한다.
- 홈/피드 2차 상세 diff를 추출했다.
  - 홈1(`51:640`): 상단 로고/친구추가/알림 액션, 빈 친구 CTA 문구, bottom nav 포함.
  - 홈1-1(`51:700`): 친구 row 이후 `최근 공유된 게시물이 없어요.` empty state.
  - 홈2(`51:1240`): 친구 추가 화면의 카카오 친구 찾기/추천 친구/하단 CTA 고도화.
  - 피드(`51:1025`): 오늘 인증한 친구 story strip, meal 필터, compact card, AI 칼로리 chip, macro gram label.
  - 피드(`56:1392`): 날짜별 스토리 다시보기 변형. 기본 피드와 별도 라우트/API 검토 필요.
- 홈/피드 2차 기본 반영을 1차 구현했다.
  - `HomeScreen`에 상단 액션과 빈 게시물 상태를 추가했다.
  - `FeedScreen`에 v2 헤더, story strip, 회색 피드 배경, compact feed card, AI 칼로리 chip, macro gram label을 추가했다.
  - 390×844 widget test를 `app/test/figma_v2_home_feed_test.dart`에 추가했다.
- GitHub #79: `FriendSearchScreen`을 홈2(`51:1240`) 기준으로 고도화했다.
  - 연락처 카드 대신 카카오톡 친구 찾기 row를 표시한다.
  - 검색바/카카오 row/추천 친구 heading/하단 CTA spacing을 390×844 기준으로 조정했다.
  - 추가/추가됨 버튼의 폭과 icon gap을 시안에 맞췄다.
  - 390×844 widget test를 `app/test/friends_test.dart`에 추가했다.
- GitHub #78: 날짜별 스토리 다시보기 피드 UI/라우트를 1차 구현했다.
  - `/feed/story` 라우트와 `FeedStoryScreen`을 추가했다.
  - 날짜 앱바, `스토리 다시보기` strip, dashed 인증 ring, 나의 기록/친구 기록 칩을 반영했다.
  - 기본 feed card와 feed 데이터를 재사용한다.
  - 현재 feed API에 날짜 파라미터가 없어 실제 날짜별 조회/나의 기록 필터는 후속 API 계약 변경이 필요하다.
  - 390×844 widget test를 `app/test/figma_v2_home_feed_test.dart`에 추가했다.
- GitHub #78: 날짜별 스토리 다시보기 피드의 API 계약과 앱 연결을 보강했다.
  - `GET /feed`에 `date=YYYY-MM-DD`와 `scope=all|mine|friends` query를 추가했다.
  - `date`는 KST 로컬 날짜로 저장된 `eatenLocalDate` 기준으로 필터링한다.
  - `scope=mine`은 내 공개 글, `scope=friends`는 팔로위 공개 글만 조회한다.
  - `FeedStoryController`를 추가해 일반 피드와 별도 상태로 날짜별 스토리 피드를 조회한다.
  - `FeedStoryScreen`의 `나의 기록`/`친구 기록` 칩이 실제 API scope 전환을 수행하도록 연결했다.
  - 서버 feed route test와 앱 feed controller/widget test를 보강했다.
- 로그인/온보딩/프로필 2차 세부 토큰 diff 작업을 재개하려 했으나 Figma MCP가 재인증을 요구해 노드 조회가 차단됐다.
  - 대상 노드: 온보딩 `51:408`, `51:424`, 프로필 `51:1328`, `51:315`, `51:361`.
  - 정확한 Figma 치수/토큰 대조는 재인증 후 진행한다.
  - 재인증 전에도 유효한 회귀 보호를 위해 프로필 설정 3단계 390×844 widget test를 추가했다.
  - 테스트는 이름 입력 → STEP2 기본정보 입력 → STEP3 목표 화면 진입까지 주요 문구/필드를 검증한다.

## 다음 작업 순서

1. #74/#75 앱 구현을 실제 기기 또는 시뮬레이터에서 390×844 기준으로 캡처해 Figma와 대조한다.
   - 캘린더 통합 화면의 스크롤 높이, bottom nav 겹침, 월/연 선택 박스, 끼니 row 터치 영역 확인
   - 끼니 상세 화면의 hero image, item chip wrapping, macro/칼로리 영역, 닫기 CTA 확인
2. 로그인/온보딩/프로필 2차 시안의 세부 토큰 diff를 확인한다.
   - 현재 Figma MCP가 재인증을 요구한다. 재인증 후 `51:408`, `51:424`, `51:1328`, `51:315`, `51:361` 메타데이터/스크린샷부터 다시 조회한다.
   - 카카오 로그인 화면은 구현 흔적이 있으므로 에셋·간격·타이포 중심으로 점검한다.
3. 기존 열린 앱 이슈 `#24`, `#26`, `#28`, `#30`, `#32`를 병합 PR과 실제 구현 상태 기준으로 close/comment 대상 정리한다.
4. 변경 범위를 커밋 단위로 분리한다.
   - 이번 Figma 캘린더/끼니 상세 변경과 기존 auth/profile 미커밋 변경은 섞지 않는다.
   - 커밋 전 `git diff --stat`과 `git status --short --branch`로 범위 확인한다.

## Figma diff 표 형식

| 구분 | 1차/현재 구현 | 2차 Figma | 영향 범위 | 처리 |
|---|---|---|---|---|
| 화면/프레임 | 현재 화면명·파일 | Figma frame/nodeId | app/server/docs | 유지/수정/새 이슈 |
| 토큰 | 현재 색/타입/간격 | Figma 값 | design widgets/theme | 유지/수정 |
| 플로우 | 현재 route/API | Figma 의도 | app routing/API | 유지/수정 |
| 에셋 | 현재 asset | Figma 이미지/아이콘 | assets/pubspec | 추가/교체 |

## 현재 검증 로그

- `cd server && npm test -- --run src/modules/profile/profile.routes.test.ts src/middleware/auth.test.ts`
  - 결과: 통과, 2 files / 15 tests
- `cd server && npm run lint`
  - 결과: 통과
- `cd app && flutter test test/figma_v2_onboarding_profile_test.dart`
  - 결과: 통과, 1 test
- `cd app && HOME=/private/tmp DART_SUPPRESS_ANALYTICS=true FLUTTER_ALREADY_LOCKED=true flutter --no-version-check analyze`
  - 결과: 통과
- `cd app && flutter test`
  - 결과: 통과, 61 tests
- `cd server && npx tsc --noEmit`
  - 결과: 통과
- `cd app && flutter test`
  - 결과: 통과, 60 tests
- `cd server && npm run lint`
  - 결과: 통과
- `cd app && flutter analyze`
  - 첫 실행: `withOpacity` deprecation 4건으로 실패
  - 조치: `withValues(alpha: ...)`로 교체
  - 재실행 결과: 통과
- `cd server && npm test`
  - 결과: 통과, 19 files / 143 tests
- `HOME=/private/tmp DART_SUPPRESS_ANALYTICS=true FLUTTER_ALREADY_LOCKED=true flutter --no-version-check analyze`
  - 결과: 통과
- `HOME=/private/tmp DART_SUPPRESS_ANALYTICS=true FLUTTER_ALREADY_LOCKED=true flutter test`
  - 결과: 실패. Flutter SDK 캐시에 `bin/cache/artifacts/engine/darwin-x64/flutter_tester`가 없어 테스트 러너 로드 전 실패
- `git stash push -u -m "protect figma v2 sync before flutter cache repair"`
  - 결과: 실패. 현재 sandbox에서 `.git/index.lock` 생성 권한이 없어 Git stash를 만들 수 없음
- 안전 백업 생성
  - tracked patch: `/private/tmp/diet-setlog-safety-backup/tracked-changes.patch`
  - untracked archive: `/private/tmp/diet-setlog-safety-backup/untracked-files.tgz`
- `/private/tmp/flutter-sdk-test-20260702/flutter` 복사본 SDK에서 `flutter precache --force`
  - 결과: 성공. 복사본 SDK에는 `bin/cache/artifacts/engine/darwin-x64/flutter_tester` 생성됨
- `/private/tmp/flutter-sdk-test-20260702/flutter/bin/flutter --no-version-check test`
  - 결과: 실패. `flutter_tester` 실행 시 Dart VM `cpuinfo_macos.cc:42` assert로 SIGABRT
- `/private/tmp/flutter-sdk-test-20260702/flutter/bin/flutter upgrade`
  - 결과: 중단. 복사본 SDK에서도 Dart VM `cpuinfo_macos.cc:42` assert가 반복 발생해 upgrade tool build 단계가 진행되지 않음
- `cd app && flutter test`
  - 결과: 통과, 55 tests
- `cd app && flutter test test/calendar_test.dart`
  - 결과: 통과, 4 tests
- `cd app && HOME=/private/tmp DART_SUPPRESS_ANALYTICS=true FLUTTER_ALREADY_LOCKED=true flutter --no-version-check analyze`
  - 결과: 통과
- `cd app && flutter test test/figma_v2_home_feed_test.dart`
  - 결과: 통과, 2 tests
- `cd app && flutter test`
  - 결과: 통과, 57 tests
- `cd app && flutter test test/friends_test.dart`
  - 결과: 통과, 13 tests
- `cd app && flutter test`
  - 결과: 통과, 58 tests
- `cd app && flutter test test/figma_v2_home_feed_test.dart`
  - 결과: 통과, 3 tests
- `cd app && flutter test`
  - 결과: 통과, 59 tests
- `cd server && npm test -- --run src/modules/feed/feed.routes.test.ts`
  - 결과: 통과, 1 file / 17 tests
- `cd app && HOME=/private/tmp DART_SUPPRESS_ANALYTICS=true FLUTTER_ALREADY_LOCKED=true flutter --no-version-check analyze`
  - 결과: 통과
- `cd app && flutter test test/feed_test.dart test/figma_v2_home_feed_test.dart`
  - 결과: 통과, 20 tests
- `cd server && npx tsc --noEmit`
  - 결과: 통과

## 완료 조건

- Figma 2차 시안 diff 표가 문서화되어 있다.
- 새 구현 작업은 GitHub 이슈로 분리되어 있다.
- 기존 열린 앱 이슈 `#24`, `#26`, `#28`, `#30`, `#32`는 병합 PR과 실제 구현 상태 기준으로 close/comment 대상이 정리되어 있다.
- 관련 앱 변경은 `flutter analyze`와 `flutter test`를 통과한다.

## 현재 완료/미완성 요약

### 완료

- 보호 브랜치 `feat/73-figma-v2-sync`에서 작업 중이다.
- Figma MCP와 Linear 연결을 확인했다.
- 2차 섹션 `6/27 2차 시안`(`51:1655`)의 프레임 인벤토리를 만들었다.
- `51:767`이 대표 화면이 아니라 `음식 업로드` 내부 status bar 인스턴스임을 확인했다.
- 신규 GitHub 이슈를 분리했다.
  - #74: 끼니별 기록 상세 화면 추가
  - #75: 캘린더 2차 통합 화면 리프레시
- #74/#75 앱 구현을 1차 완료했다.
- #74/#75 캘린더/끼니 상세 widget test를 추가했다.
- 390×844 테스트에서 발견된 캘린더 화면 overflow를 수정했다.
- `flutter analyze`와 `flutter test`는 통과했다.
- 홈/피드 2차 상세 diff와 기본 홈/피드 구현을 1차 완료했다.
- 홈2 친구 추가 화면(`51:1240`) 기본 UI 고도화를 1차 완료했다.
- 날짜별 스토리 다시보기 피드(`56:1392`) UI/라우트 1차 구현을 완료했다.
- 날짜별 스토리 다시보기 피드(`56:1392`)의 `date`/`scope` API 계약과 앱 연결을 완료했다.
- 프로필 설정 3단계 390×844 widget test를 추가했다.

### 미완성

- 390×844 기준 실제 화면 캡처 검증은 아직 하지 못했다.
- 로그인/온보딩/프로필 2차 세부 토큰 diff는 Figma MCP 재인증 후 진행해야 한다.
- 기존 열린 앱 이슈 `#24`, `#26`, `#28`, `#30`, `#32` 정리는 아직 남아 있다.
- 기존 auth/profile 미커밋 변경과 이번 Figma 구현 변경이 같은 작업트리에 있어 커밋 단위 분리가 필요하다.
