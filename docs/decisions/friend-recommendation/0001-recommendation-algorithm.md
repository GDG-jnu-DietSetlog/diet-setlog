# 0001. 친구 추천 알고리즘 — 데이터 기반 단계별 설계

- **상태**: ✅ 확정 (가중치 수치는 데이터 쌓이며 튜닝)
- **날짜**: 2026-06-26
- **관련**: [../../api-db-design.md](../../api-db-design.md) §1.5·§2.2·§4.5~4.8·§9 · [리서치](../../research/friend-recommendation/README.md) (문서 01~05) · [README](./README.md) · 이슈 [#1](https://github.com/GDG-jnu-DietSetlog/diet-setlog/issues/1), [#2](https://github.com/GDG-jnu-DietSetlog/diet-setlog/issues/2)

## 맥락 (Context)

초기 친구 추천 초안([설계 §4.6](../../api-db-design.md))은 정렬을 **`친구수(friendCount)↓ → 활동수(postCount)↓`** 로 두었다. 그러나 [리서치](../../research/friend-recommendation/README.md)를 마친 뒤 두 가지 문제가 드러났다.

1. **1순위 신호 누락**: 모든 글로벌 서비스의 핵심 신호는 **공통 친구 수(mutual friends) / friends-of-friends(triangle closing)** 인데([02-알고리즘](../../research/friend-recommendation/02-algorithms-and-signals.md) §2.1, [01-글로벌](../../research/friend-recommendation/01-global-services-pymk.md)), 초안 정렬엔 이게 없다.
2. **카운터 의미 오류**: `friendCount` 를 "내가 follow한 수"(following)로 집계하면([설계 §4.7](../../api-db-design.md)) 정렬 1순위가 "남을 많이 follow한 사람"이 되어 인기도 신호와 어긋난다.

또한 **우리 상황(서비스 초기) + 가용 데이터**라는 제약이 결정적이다.

- **런칭 시점엔 그래프가 통째로 비어 있다**(글로벌 콜드 그래프) → 거의 모든 유저가 친구 0명 → FoF/공통친구가 대부분 빈 결과.
- **카카오 친구 매칭은 비즈앱 검수 전이라 v1에서 비활성**([설계 §6](../../api-db-design.md) 범위밖, [03-콜드스타트](../../research/friend-recommendation/03-cold-start.md) §8).
- 따라서 런칭 직후 **실제로 작동하는 신호는 활동량 + 프로필/목표 유사도뿐**이다.

이 문서는 "이상적 알고리즘"이 아니라 **우리가 실제로 손에 쥔 데이터에서 역산한** 친구 추천 알고리즘을 확정한다.

### 가용 데이터 인벤토리 (현 Prisma 스키마 기준)

| 데이터 | 출처 | 추천 신호 | 가용 시점 |
|---|---|---|---|
| `FriendRelation`(follower→following) | DB 있음 | FoF·공통친구수·follower/following 카운트 | 엣지 있어야 의미 |
| `postCount`(publishToFeed 시 +1) | DB 있음(denorm) | 활동량 | 즉시 |
| `FoodRecord.eatenAt/createdAt` | DB 있음 | 활동 최근성(최근 7일 등) | 즉시 |
| `User.createdAt` | DB 있음 | 가입 최근성 | 즉시 |
| `Profile.gender / birthYear` | DB 있음 | 나이대·성별 유사도 | 즉시(프로필 필수) |
| `Profile` 목표(현재/목표체중, `weeklyWeightDelta`, `dailyCalorieTarget`) | DB 있음 | **목표 유사도**(감량/증량/유지·강도) | 즉시(프로필 필수) |
| `AuthIdentity(kakao)` | DB 있음 | 카카오 친구 매칭 키 | 비즈앱 검수 후 |
| 관심사/운동 태그 | ❌ 없음 | content 유사도 강화 | 온보딩 1문항 추가 시 |
| 지역(시/도) | ❌ 없음 | 근접 추천 | opt-in 수집 시 |
| 연락처 업로드 | ❌ 없음 | 강력하나 프라이버시 무거움 | 보류 |

> 핵심: **`Profile` 이 앱 사용 필수 단계**라 모든 활성 유저가 나이·성별·다이어트 목표를 갖는다. 이건 그래프가 비어 있어도 작동하는 신호다.

## 선택지 (Options)

검토한 대안과 기각 이유.

- **(A) 초안 유지** — `friendCount↓ → postCount↓`. 기각: 공통친구 신호 없음 + 카운터 의미 오류(맥락 1·2).
- **(B) 공통친구 1순위만으로 재설계** — 리서치 표준엔 맞으나 **런칭기 그래프가 비어 거의 inert**. 빈 화면 발생. 단독으론 부족.
- **(C, 채택) 데이터 기반 2단계 깔때기 + 네트워크 성숙도별 가중치 블렌딩** — 공통친구를 1순위로 두되, 그래프가 빌 때는 **우리가 이미 가진 목표 유사도·활동성**이 주력이 되도록 가중치가 데이터 양에 따라 이동.
- 관계 모델: **단방향 follow**(채택) vs 상호 친구(수락). 후자는 pending 상태·수락 API가 필요해 v1 과투자.

## 결정 (Decision)

### 1. 전체 골격 — 2단계 깔때기 (rule-based, ML 없음)

[리서치 문서 02·05](../../research/friend-recommendation/02-algorithms-and-signals.md) 표준. v1은 ML 대신 결정론적 점수.

```
[후보 생성] 싸게 추림 (recall)  ── ① 친구의 친구 ② 카카오 친구 ③ 활동/목표 폴백
        ▼
[랭킹] 결정론적 점수 정렬 (precision)
        ▼
[가드] 본인·이미친구 제외 · 슈퍼노드 컷 · 이미본추천 디스카운트
```

### 2. 후보 생성 — 소스 3개 (union + 우선순위, 하드스위치 아님)

[문서 03 §7](../../research/friend-recommendation/03-cold-start.md)의 "엣지가 생기는 순간 외부신호→그래프신호로 무게 이동" 패턴. 초안의 0명/1명+ **하드 스위치를 폐기**하고 union으로 채운다.

| 우선 | 소스 | 조건 |
|---|---|---|
| 1 | 친구의 친구(FoF) | 내 친구 ≥1명 |
| 2 | 카카오 친구 중 앱 가입자 | 카카오 연동+동의(검수 후) |
| 3 | 활동/목표 유사도 폴백 | 위가 부족하면 채워 넣음 |

FoF가 목록을 충분히 채우면 ②③은 보강용. 부족하면 ②③으로 채워 **빈 화면을 막는다**.

### 3. 랭킹 — 통합 점수식

```
score(후보) =
    w1 · mutualFriendCount      // 그래프: P0엔 대부분 0, 그래프 자라면 지배
  + w2 · goalSimilarity         // Profile 기반: 런칭기 주력 (우리만의 도메인 신호)
  + w3 · activityRecency        // postCount + 최근 7일 활동 유무
  + w4 · followerCount          // 인기 (followingCount 아님)
  - w5 · alreadyShownPenalty    // 이미 본/거절 디스카운트 (impression discounting)
tie-break: id
```

`goalSimilarity(me, c) ∈ [0,1]` 정의(예시 가중, 튜닝 대상):

```
  0.40 · [목표 방향 동일?]                 // 감량/유지/증량 부호 일치=1, else 0
+ 0.25 · clamp(1 − |Δweekly_me − Δweekly_c| / NORM_w)   // 목표 강도 근접
+ 0.20 · [나이 버킷 동일?]                 // birthYear→10년 버킷
+ 0.15 · clamp(1 − |cal_me − cal_c| / NORM_cal)         // 일일 칼로리 목표 근접
```

- `gender` 는 v1 점수 **제외**(다이어트 동기 유사성에 약하고 동성 편향 우려). 추후 약가중 검토.
- 프라이버시: `goalSimilarity` 는 **랭킹 내부 계산에만** 쓰고, "왜 추천됐는지"에 상대의 체중/목표 수치는 노출하지 않는다.

### 4. 네트워크 성숙도별 가중치 (단계 = 데이터 양)

알고리즘은 하나, **가중치만 데이터 양에 따라 이동**([문서 03 §7](../../research/friend-recommendation/03-cold-start.md) 블렌딩).

| 단계 | 그래프 | 주력 신호 | mutual |
|---|---|---|---|
| P0 런칭 | 거의 빈 그래프 | **목표유사도 + 활동성**(+seed) | ≈0(자동 후순위) |
| P1 성장 | 엣지 생기기 시작 | FoF/공통친구 활성화, content와 블렌딩 | 일부 |
| P2 카카오 검수통과 | + 외부 부트스트랩 | 카카오 친구 매칭 추가 | — |
| P3 성숙 | 밀집 그래프 | **공통친구수 지배**, content 보조 | 지배 |

- 초기 구현은 가중합 대신 **정렬키 우선순위**로 단순화 가능: `mutual → goalSim → activityRecency → followerCount → id` (P0엔 mutual이 자동 0이라 goalSim이 사실상 1순위).
- 데이터가 쌓이면 가중합 `w1..w5` 로 전환·튜닝.

### 5. 관계 모델 — 단방향 follow 유지

[리서치 01](../../research/friend-recommendation/01-global-services-pymk.md)상 비대칭 follow는 표준(Instagram·X). 현재 `FriendRelation` 스키마 그대로, 수락 플로우 없음. **단, 카운터를 2개로 분리**:

- `followingCount` — 내가 follow한 수(FoF 탐색용)
- `followerCount` — 나를 follow한 수(**인기 정렬용**, 초안 `friendCount` 의미를 이걸로 교체)
- follow 시 **대상의 `followerCount +1`**(초안은 본인 friendCount만 +1이라 인기 신호가 틀렸음).

### 6. 콜드스타트 폴백 — 활동 + 목표 유사도

카카오 미연동/검수 전 구간은 ② 소스가 비므로, ③ **활동량 높은 가입자/seed + 목표 유사도**로 채워 빈 화면을 막는다([문서 03 §4·§6](../../research/friend-recommendation/03-cold-start.md)). "카카오 친구 연결하기" CTA 병행.

### 7. 로그인 — 게스트 폴백 유지, 카카오는 선택

이슈 #1 "로그인 없이 v1" 존중 + 진입장벽↓. 카카오 친구 매칭은 어차피 비즈앱 검수가 필요해 v1에 못 켜진다. 게스트로 시작하고 친구 기능 사용 시 카카오 유도, `AuthIdentity` 로 게스트→카카오 승격.

### 8. 효율적 구현 + 스케일 가드

**핵심 제약**: 랭킹 1·2순위(`mutualFriendCount`·`goalSimilarity`)는 **계산값**이라 DB 인덱스/keyset 정렬이 불가능하다. 따라서 "전역 `ORDER BY 점수`"가 아니라 **좁히기 → 점수 → 캐시 페이징** 구조로 구현한다([문서 05](../../research/friend-recommendation/05-architecture-and-scale.md) 단계 1~2 정합).

```
1) 후보 생성 — 인덱스로 싸게 좁힌다 (소스별 LIMIT)
     ① FoF self-join  (+statement_timeout, 슈퍼노드 degree cap)
     ② AuthIdentity(kakao) providerUserId IN (...)
     ③ goalDirection=me ∧ ageBucket=me   ← @@index([goalDirection,ageBucket]) 스캔, LIMIT
        (부족하면 lastPostedAt 최신 → @@index([lastPostedAt]))
2) 좁혀진 소수 후보에만 비싼 신호 계산
     mutualFriendCount · 정밀 goalSimilarity · followerCount · lastPostedAt 를 batch 조회 (N+1 금지)
3) 앱에서 score 정렬 → 정렬된 추천 리스트를 Redis 캐시 (수시간 TTL)
4) 페이징은 캐시된 정렬 리스트 기준 (DB keyset 아님)
     follow/unfollow·새 글 시 해당 유저 추천 캐시 무효화
```

**스케일 단계**([문서 05](../../research/friend-recommendation/05-architecture-and-scale.md)):
- **단계 1(현재)**: on-demand FoF self-join + 소스별 `LIMIT` + `statement_timeout`.
- **슈퍼노드 fan-out 가드**: degree 큰 친구는 2-hop 확장 제외 / top-N 컷(k² 폭발 방지).
- **단계 2**: 추천 결과 Redis TTL 캐시 + denormalized 카운터(`followerCount`/`followingCount`/`lastPostedAt`), 변경 시 무효화.
- **단계 3 트리거**: FoF self-join이 핫경로 p95 지연을 끌어올리면 → 야간 배치 precompute로 이행.

### 9. 추가 데이터 수집 방침

| 데이터 | 방침 | 이유 |
|---|---|---|
| 활동 최근성 | ✅ 즉시(수집 불필요) | 이미 `FoodRecord`에 있음, 계산만 |
| 관심사/운동 태그(온보딩 1문항) | 🟡 저비용 권장 | content 유사도 강화, 마찰 작음 |
| 지역(시/도, opt-in) | 🟡 P2+ 검토 | 근접 신호, 정확좌표 금지 |
| 카카오 친구 scope | 🟡 검수 후 필수급 | 한국 표준 부트스트랩 |
| 연락처 업로드 | ❌ 보류 | 역방향 노출 논란(카카오 2016 철회) |

## 근거 (Rationale)

- **공통친구 1순위**: [문서 01·02·03](../../research/friend-recommendation/02-algorithms-and-signals.md)의 일관된 결론. 단, 런칭기엔 자동 0이라 후순위로 밀리고 그래프가 자라며 자연히 전면으로.
- **목표 유사도를 런칭기 주력으로**: 일반 PYMK엔 없지만 우리에겐 `Profile`(필수 입력)이 있어 **그래프 0에서도 작동하는 유일한 개인화 신호**. 연락처·위치 같은 프라이버시 비용 없이 이미 가진 데이터로 콜드스타트를 푼다([문서 03 §6](../../research/friend-recommendation/03-cold-start.md) content/관심사 패턴의 도메인 특화).
- **단방향 follow**: 수락 플로우·pending 상태 없이 v1 가볍게. 스키마 변경 최소.
- **게스트 폴백·카카오 선택**: 검수 의존성을 v1 출시 경로에서 분리.

## 영향 (Consequences)

**바뀌는 것 — 스키마(데이터 대조 결과)**

원천 데이터(그래프·`Profile`·`postCount`)는 대부분 있으나, 효율적 후보 생성/랭킹을 위해 다음이 필요하다.

- `User.friendCount` → **`followerCount`(나를 follow, 인기) + `followingCount`(내가 follow, FoF) 분리**.
- `User.lastPostedAt DateTime?` 추가 — 활동 최근성 정렬/필터용(`publishToFeed` 시 갱신). *(기존엔 최근활동 timestamp가 없어 `FoodRecord` 집계 필요 → 비효율)*
- `User.goalDirection`(lose|maintain|gain) + `User.ageBucket`(birthYear→10년 버킷) **비정규화** — `Profile` 저장 시 갱신. `goalSimilarity` 자체는 계산값이라 인덱스 불가하나, **후보를 좁히는 거친 키**는 인덱스가 필요(P0 폴백이 풀스캔을 피하는 핵심).
- 인덱스: `@@index([followerCount, postCount])`, `@@index([goalDirection, ageBucket])`, `@@index([lastPostedAt])`.
- **신규 테이블 `FriendRecFeedback(userId, candidateId, action, createdAt)`** — 이미 본/숨김/거절 추천 저장(impression discounting). 없으면 `alreadyShownPenalty` 불가.

**바뀌는 것 — API / 구현**
- **API §4.6** `GET /v1/friends/search`: 정렬을 `mutualFriendCount → goalSimilarity → activityRecency → followerCount → id` 로 변경, `mutualFriendCount` 채움.
- **⚠️ 페이징 구조 변경**: 1·2순위(mutual·goalSimilarity)가 **계산값이라 DB keyset 커서 불가**. → "**인덱스로 후보 좁히기 → 소수에만 점수 계산 → 정렬 리스트 Redis 캐시 → 캐시 페이징**" 으로 전환(아래 §8). 초안의 `(friendCount, postCount, id)` keyset은 폐기.
- **API §4.7/§4.8** follow/unfollow: 카운터 증감을 **대상의 `followerCount`**(+ 본인 `followingCount`)로 정정.
- **계산 로직**: `goalSimilarity` 계산 추가(서버), 후보 배치 조회에 `Profile`/카운터 포함(N+1 금지).
- **설계 문서 동기화**: `api-db-design.md` §2.2·§4.5~4.8·§8·§9 갱신(이 ADR과 함께 반영).

**후속 작업**
- [ ] `api-db-design.md` 스키마/엔드포인트/열린질문 동기화.
- [ ] `goalSimilarity` `NORM_w`/`NORM_cal` 정규화 상수·버킷 경계 확정.
- [ ] seed 사용자(`prisma/seed.ts`) — 활동·다양한 목표 분포로 구성해 폴백이 의미 있게.
- [ ] 슈퍼노드 degree cap 임계값 결정.

**트레이드오프**
- 정렬키가 늘어 쿼리/계산이 초안보다 무겁다 → 캐시·denormalized 카운터로 상쇄(단계 2).
- `goalSimilarity` 는 "비슷한 사람"을 추천하므로 동질화(filter bubble) 우려 → 활동성·인기 신호로 다양성 일부 확보, P3에서 공통친구로 무게 이동하며 완화.

## 재검토 트리거 (Revisit when)

- 그래프가 자라 P0→P1→P3로 넘어갈 때마다 **가중치 `w1..w5` 재튜닝**(특히 mutual 비중 상향).
- FoF self-join이 핫경로 p95를 끌어올리거나 슈퍼노드 타임아웃 발생 → **배치 precompute로 이행**([문서 05](../../research/friend-recommendation/05-architecture-and-scale.md) 단계 3).
- 카카오 비즈앱 **친구 scope 검수 통과** → ② 소스 활성화 + 폴백 비중 조정.
- 추천 **수락률이 낮으면** → goalSimilarity 정의식·신호 가중 재검토, 관심사 태그 도입 검토.
- 연락처/위치 등 새 데이터 도입 시 → 프라이버시 best practice([문서 04](../../research/friend-recommendation/04-contacts-matching-and-privacy.md)) 전제 재검토.
