# diet-setlog — 디자인 시스템 (토큰 & 공통 컴포넌트)

> 출처: Figma "프롭 팀" 파일([[figma-design-url]] · fileKey `WgmQmy0thsZO3mJ5gcO5zH`, Page 1 / `완성`).
> ⚠️ **이 Figma 파일은 읽기 전용이다 — 절대 수정하지 않는다.** 값은 Dev Mode 측정값을 옮긴 것.
> 화면별 레이아웃은 [screens.md](./screens.md), 구현 범위/플로우는 [dietsetlog-wireframe-plan.md](./dietsetlog-wireframe-plan.md), API는 [api-db-design.md](./api-db-design.md).
> Figma 예시 코드는 웹/React 기준이라, 아래는 **토큰·치수만 추출해 Flutter 기준**으로 재작성했다.

---

## 0. 기본 전제
- **프레임**: 390 × 844 (iPhone 390pt 기준). 피드만 390 × 1381(스크롤).
- **폰트**: **Pretendard** (전 화면 공통). weight: Bold(700) / SemiBold(600) / Medium(500) / Regular(400).
- **공통 좌우 패딩**: **24px** → 본문 콘텐츠 폭 **342px**.
- **시각 QA 기준**: 390×844 캡처 후 Figma와 대조(이슈 #1 Test Plan).

---

## 1. 색상 토큰

### 1.1 Figma 변수(명명된 토큰)
| Figma 변수명 | hex | 비고 |
|---|---|---|
| 블루 1 | `#1B68FF` | **Primary** |
| 블루2 | `#E9F2FF` | 연한 파랑 배경(카드/칩) |
| 그린2 | `#00741E` | 단백질 값 텍스트 |
| 그린3 | `#26CF51` | 캘린더 기록 점(있음) |
| 블랙1 | `#000000` | 본문 |
| 블랙3 | `#CACACB` | 캘린더 점(없음)·약한 회색 |
| 블랙4 | `#82878F` | 보조 회색 |
| 화이트 | `#FFFFFF` | 배경/카드 |
| tx/default_3 | `#D5D6E1` | "나" 라벨 등 약한 텍스트 |
| bg/default | `#202540` | 다크 배경 토큰(현재 화면 미사용) |

> ⚠️ Figma 변수는 일부만 바인딩돼 있고 **대부분의 색은 raw hex**로 들어가 있다. 아래 1.2가 실제 사용 팔레트(권장 토큰화 대상).

### 1.2 실사용 팔레트 (권장 시맨틱 토큰)
| 시맨틱 | hex | 용도 |
|---|---|---|
| `primary` | `#1B68FF` | 버튼·활성 탭·선택 테두리·강조 텍스트·진행바 |
| `primaryTint` | `#E9F2FF` | AI 카드·연락처 카드·끼니 카드·선택 토글 배경 |
| `onPrimary` | `#FFFFFF` | primary 위 텍스트 |
| `bgSheet` | `#F7F7F8` | 화면 하단 시트/패널 배경 |
| `bgInput` | `#F4F4F5` | 입력칩·검색바·아바타 배경 |
| `bgNavInactive` | `#EDEDED` | bottom nav 비활성 아이콘 배경 |
| `border` | `#E0E0E2` | 카드/박스 일반 테두리 |
| `borderField` | `#EFF0F1` | 입력 필드 기본 테두리 |
| `borderFocus` | `#1B68FF` | 입력 필드 활성/포커스 테두리 |
| `skeleton` | `#F2F2F3` | 로딩 스켈레톤 바 |
| **영양 — 단백질** | `#007D2F` / `#00741E` / `#01D225` | 텍스트(녹) / 칩값 / 막대 |
| **영양 — 탄수화물** | `#1B68FF` / `#4583FF` | 값/막대(파) |
| **영양 — 지방** | `#252525` / `#FDDA08` | 값(흑) / 막대(노) |
| `success` | `#00C321` | 저장 성공 체크 |
| `successText` | `#007016` · `#00991B` | "남음"·"AI 분석 완료" 텍스트 |
| `verifyRing` | `#00B31D` | 피드 인증 아바타 링 |

### 1.3 텍스트 그레이 스케일 (강 → 약)
`#000000` → `#171717` → `#48484C`·`#4D4E51`·`#515255` → `#585858`·`#6B6B6B` → `#858588`·`#878789`·`#8F9092` → `#C7C8C9`·`#CACACB`·`#D5D6E1`·`#D8D8D9`

### 1.4 그라데이션
- **AI 배지 그라데이션** (분석·칼로리칩 공통):
  `linear-gradient(146.728deg, #1B68FF 18.6%, #83FFC4 87.7%)`
- **진행바 채움(완료 화면)**: `linear-gradient(175.7deg, #1B68FF 40.2%, #01D225 84.3%)`

### 1.5 아바타 칩 색 세트 (이니셜 아바타, bg / 글자)
| # | bg | 글자 |
|---|---|---|
| 1 | `#FFE7C6` | `#BB6C2C` |
| 2 | `#D3E5FF` | `#305CB7` |
| 3 | `#FFDFEE` | `#D03A81` |
| 4 | `#C6F4DE` | `#008C4C` |
| 5 | `#E7DCFF` | `#7959BD` |

---

## 2. 타이포그래피 (Pretendard)
| 스타일 | size | weight | lineHeight | 용도 |
|---|---|---|---|---|
| Display | 34 | Bold | 32 | 대형 kcal 수치(권장칼로리·오늘섭취) |
| Title | 20 | Bold | 32 | 화면 제목·칼로리칩 "420" |
| Value | 17~18 | Bold | — | 입력값·영양소 값 |
| AppBar | 16 | Bold | 24 | 앱바 타이틀·CTA 버튼·음식명 |
| Body | 14 | Medium/Bold | 21~24 | 본문·카드 제목·필드 라벨 |
| Caption | 13 | SemiBold | 21 | 단위·"수정" 링크 |
| Label | 12 | Medium/SemiBold | 21~24 | 보조 라벨·메타·뱃지 |
| Micro | 10~11 | SemiBold | — | 피드 영양 라벨·끼니 뱃지 |

- 상태바 시간: 14 SemiBold `#000`, letter-spacing −0.28.

---

## 3. 간격 · 모서리(radius)
- **좌우 마진**: 24 (콘텐츠 342). 검색바만 343.
- **radius 스케일**:
  - `12` — 버튼·카드·입력 필드·칩(끼니/영양/검색바) **표준**
  - `10` — 캘린더 요약 카드
  - `4` — "자세히 보기" 미니 칩
  - 원형: 아바타 46→`23` / 54→`27` / 일러스트 98→`49`
  - bottom nav 바 `52`, nav 아이콘칩 `25`
  - 뱃지(끼니/현재대비) `20`/`26`, 칼로리칩 `46`, 필터칩 `38`, 진행바 `9`
- **공통 gap**: 라벨↔필드 8, 입력 그룹 세로 36, 친구 행 피치 66, 캘린더 날짜열 피치 51·행 gap 13, 끼니 타임라인 행 피치 85, bottom nav gap 15.

---

## 4. 공통 컴포넌트

### 4.1 Primary 버튼 (CTA)
- 규격: **342 × 56**, fill `#1B68FF`, radius **12**, padding V16 / H80.
- 텍스트: 16 Bold `#FFFFFF` 중앙. 아이콘 동반 시 gap 10.
- 위치 관례: 온보딩/기록 화면에서 `x24 y730`.
- 변형: 작은 Primary(홈 빈 상태 "친구 추가하기") 158 × 50, radius 12, + 아이콘 gap 8.

### 4.2 입력 필드
- 규격: **342 × 48**, radius **12**, 흰 배경.
- 테두리: 기본 `#EFF0F1` 1px / **활성·포커스 `#1B68FF` 1px**.
- 값 텍스트 18 Bold `#000`(좌, x15), 단위 13 SemiBold `#C9C9CA`(우). 내부 행 space-between.
- placeholder 14 Medium `#C5C5C6`. 글자수 카운터 "0/50자" 14 Medium `#CACACB` 우측.

### 4.3 토글/세그먼트 (성별 등 택1)
- 칩 radius 12, padding V14. 칩 간 gap 10. 폭은 텍스트에 hug.
- **선택**: bg `#E9F2FF`, 텍스트 `#1B68FF` Bold.
- **미선택**: bg `#F4F4F5`, 텍스트 `#C5C5C6` Medium.

### 4.4 검색 바
- 343 × 48, bg `#F4F4F5`, radius 12, padding L12. 돋보기 24 + gap8 + placeholder 14 Regular `#BFC0C1`.

### 4.5 영양소 표시(탄단지)
- **편집 박스형**(기록 작성): 각 ~103×56, 흰 배경 border `#E0E0E2` radius12. 라벨 12 SemiBold `#858588` + 값 17 Bold(단백질 녹/탄수 파/지방 흑).
- **막대형**(피드/캘린더): 막대 높이 5~6, radius 9, 트랙 `#D9D9D9`, 채움 단백질 `#01D225`/탄수 `#1B68FF`/지방 `#FDDA08`.
- **칩형**(캘린더 요약): 56×56 border `#1B68FF` radius12, 라벨 12 + 값 14 Bold.

### 4.6 칼로리 칩 (사진 위 오버레이)
- 120 × 42, 흰 배경, radius 46, padding ~6/8. AI 그라데이션 배지 30×30(radius15) + 수치(Bold) + "kcal" 12 SemiBold `#6B6B6B`. 하위에 "✓ AI 분석 완료" 8~12 SemiBold `#00991B`.

### 4.7 Bottom Navigation (탭바)
- 컨테이너: 가로 중앙, `y≈760`, 흰 배경, radius **52**, padding 4, gap 15, 그림자 `0 0 4.851 0 rgba(0,0,0,0.25)`, overflow clip.
- 탭 4개(각 50×50, 좌→우): **홈 / 카메라 / 캘린더 / 프로필**. ⚠️ **v1에서 "프로필" 탭은 렌더만 하고 탭 동작 no-op**(프로필 화면 미스펙 — [spec-lock §2-8](./spec-lock.md)).
- **활성 탭**: 파란 원 `#1B68FF` 채움, 흰 아이콘 24.
- **비활성 탭**: 배경 `#EDEDED`, 회색 아이콘 24.
- 아이콘 출처(Figma): 카메라 `solar:camera-linear`, 캘린더 `uit:calender`, 프로필 `iconamoon:profile-fill`.

### 4.8 카드
- 표준 카드: 흰 배경, border `#E0E0E2`(또는 `#EFF0F1`) 1px, radius 12, padding V8 + H12 내외, 내부 gap 12.
- 연파랑 정보 카드(AI/연락처/끼니): bg `#E9F2FF`, radius 12.

### 4.9 진행 인디케이터
- **온보딩 진행바**: y100, 높이 4, radius 9, 활성 `#1B68FF` / 비활성 `#D9D9D9`. STEP1=⅓, STEP2=⅔, STEP3=전체 폭.
- **분석/완료 진행바**: 높이 6~8, radius 9, 채움 그라데이션(1.4).

---

## 5. 앱바
- 규격: 390 × 60 @ y44. 타이틀 중앙 16 Bold `#000`. 뒤로가기 `weui:back` 44×44 @ x24. (닫기 화면은 X 버튼 — 카메라 화면 참조.)

---

## 6. 다크 화면(카메라/분석) 토큰
- 배경/패널: `#0C0C0D`, 보조 버튼: `#2E2E2F`.
- 사진 오버레이: `rgba(0,0,0,0.43)`. 분석 배경 blur ~3px.
- 토스트: `rgba(30,30,28,0.59)` + backdrop-blur, radius 26.
- 인식 태그: 확정 `rgba(158,158,158,0.51)` 흰 텍스트 / 미확정 `rgba(158,158,158,0.25)` `rgba(255,255,255,0.58)`.

---

## 7. ✅ 디자인 ↔ API/플랜 정합 (해소 완료)
> Figma는 수정하지 않는다. 아래 6개 불일치는 **[spec-lock.md §2](./spec-lock.md)에서 전부 확정**됐다. "디자인 추가 슬롯"은 Figma 미반영 상태로 구현 측 합의값(추후 보드 동기화).

1. **년생(birthYear) 입력** — ✅ **STEP2에 "출생연도" 필드 추가**(디자인 추가 슬롯, 보드 노트 #5 일치). 매핑 [spec-lock §3](./spec-lock.md). BMR 계산에 사용.
2. **프로필 STEP1 = 이름(displayName)** — ✅ **`PUT /v1/me/profile` 바디에 `displayName` 포함** → `User.displayName` 갱신([spec-lock §3·§5.3](./spec-lock.md)).
3. **메모(memo) 필드** — ✅ **`FoodRecord.memo`(≤200자) 추가**, `POST /v1/food-records` 바디에 `memo?` 포함([spec-lock §4·§5.3](./spec-lock.md)).
4. **피드 화면(좋아요/댓글)** — ✅ **v1 범위 포함**. `PostLike`/`PostComment` 모델 + `/v1/feed`·like·comment 엔드포인트 신설([spec-lock §4·§5.2](./spec-lock.md)).
5. **캘린더 친구추가 UI** — ✅ **제거 확정**(보드 노트 일치). 월간 달력 우상단 친구추가 아이콘·팝업·타인 달력 보기 미구현([spec-lock §2-7](./spec-lock.md)).
6. **끼니 칩** — ✅ **4종 확정**(아침/점심/저녁/간식). 기록작성 화면에 **간식 칩 추가**(디자인 추가 슬롯)([spec-lock §2-5](./spec-lock.md)).
