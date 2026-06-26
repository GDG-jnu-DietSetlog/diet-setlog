# 친구 추천의 Cold-Start 문제: 친구가 0명인 신규 유저에게 어떻게 친구를 추천하는가

## 1. 들어가며 — 왜 Cold-Start가 어려운가

소셜 서비스의 친구 추천은 대부분 **그래프 기반(graph-based)** 으로 동작한다. 핵심 알고리즘은 **friends-of-friends(FoF, 친구의 친구)** 와 **mutual friends(공통 친구 수)** 다. "A의 친구인 B가, B의 친구인 C를 알고 있다 → C를 A에게 추천"하는 식이다. Facebook의 "People You May Know(PYMK)"도 *"the estimated strength of the connections between the suggested person and their current and former friends"* 와 mutual friends 비율을 핵심 신호로 쓴다 ([Meta Transparency](https://transparency.meta.com/features/explaining-ranking/fb-people-you-may-know/)).

문제는 **신규 유저(brand-new user)는 친구가 0명**이라는 점이다. 그래프에 노드(node)만 있고 엣지(edge)가 하나도 없으면:

- FoF가 성립하지 않는다. "친구의 친구"를 계산하려면 친구가 최소 1명은 있어야 한다.
- 공통 친구(mutual friends) 신호가 전부 0이다.
- collaborative filtering(협업 필터링)도 *"item history will be null"* 상태라 유사 유저를 찾을 근거가 없다 ([Express Analytics](https://www.expressanalytics.com/blog/cold-start-problem)).

이것이 추천 시스템 전반의 **cold-start problem(콜드스타트 문제)** 이며, 신규 유저에 대한 버전을 특히 **(pure) new-user cold-start** 라고 부른다. 따라서 서비스들은 그래프가 비어 있는 초기 단계에서는 **그래프 외부의 신호(external signals)** 와 **휴리스틱(heuristics)** 에 의존해 첫 연결을 만들어낸다. 아래에서 기법별로 정리한다.

---

## 2. 연락처/주소록 임포트 (Contact / Address-book Import)

### 어떻게 / 어디서
가장 강력하고 보편적인 부트스트랩 기법. 가입 시 유저의 **휴대폰 연락처, 이메일 주소록**을 (동의를 받아) 업로드하고, 그 안의 전화번호/이메일을 서비스 내 기존 유저와 매칭한다. 매칭되면 즉시 "당신이 알 수도 있는 사람"으로 제시한다.

- **Facebook PYMK**: 연락처 동기화를 허용하면 프로필을 연락처와 매칭해 추천하며, 추가로 *"whether or not your contact was uploaded by the person being suggested"* — 즉 **상대방이 당신을 연락처에 저장해 업로드했는지(역방향 신호)** 까지 본다.
- **KakaoTalk(카카오톡)**: "연락처로 친구 추가(Add from Contacts)"로 전화번호를 동기화해, 내 연락처에 있는 사람 중 카카오톡 사용자를 친구로 보여준다. 한국 앱들이 이 카카오 기반 전화번호 매칭 모델을 사실상의 표준으로 따른다(아래 8절 참고).
- **WhatsApp / Telegram**: 주소록에 번호가 있으면 자동으로 상대를 노출하는 contact-first 모델.

### 트레이드오프
- **장점**: 실제 오프라인 인맥(real-world ties)을 그대로 가져오므로 추천 정확도와 수락률이 매우 높다. 친구가 0명이어도 단번에 수십 명의 후보를 만든다.
- **단점/리스크**:
  - **프라이버시**. 양방향 연락처 매칭은 "내가 모르는데 나를 아는 사람" 또는 "스토킹성 노출"을 만든다.
  - 카카오의 "추천 친구(Recommended Friends)" 기능은 2016년 10월 도입 하루 만에 *"낯선 사람이 내 번호를 안다"* 는 불쾌감·공포 논란으로 철회됐다 ([Korea Bizwire](http://koreabizwire.com/kakaotalks-recommended-friends-service-under-fire/68519)).
  - 그래서 대부분 서비스가 **전화번호로 친구 추가 허용** 같은 옵트아웃/옵트인 설정을 제공한다.

---

## 3. 소셜 로그인 제공자의 친구 그래프 임포트 (Social Login Graph Import)

### 어떻게 / 어디서
**Facebook / Google / Kakao로 가입(소셜 로그인, OAuth)** 할 때, 그 제공자의 친구 목록·연락처를 권한 스코프로 받아 새 서비스의 초기 그래프로 이식한다. 학술적으로는 **cross-platform transfer learning**(타 플랫폼의 social knowledge를 random walk 등으로 이식)으로도 연구된다.

### 트레이드오프 / 중요한 현실적 제약
- **Facebook 친구 목록 임포트는 사실상 막혔다.** Graph API v2.0 이후 `user_friends` 스코프는 **앱을 함께 사용 중이고 권한을 부여한 친구만** 반환한다. 즉 전체 페이스북 친구 목록을 통째로 가져올 수 없다 ([Auth0: Facebook Graph API Changes](https://auth0.com/docs/troubleshoot/product-lifecycle/past-migrations/facebook-graph-api-changes)).
- **Google**은 People API 등으로 contacts를 받을 수 있으나 민감 스코프라 OAuth 검증이 엄격하다.
- 따라서 **2절의 연락처 임포트가 소셜 로그인 친구 그래프 임포트보다 현재 더 신뢰할 만한 부트스트랩 채널**이라는 점을 설계 시 유의해야 한다. (이 변화는 플랫폼 정책에 따라 계속 바뀌므로, 실제 구현 전 최신 스코프 정책을 재확인할 것 — 불확실성 있음.)

---

## 4. 인기 기반 / 활동 기반 추천 (Popularity & Activity-based)

### 어떻게 / 어디서
연락처도 소셜 그래프도 없을 때의 **폴백(fallback)**. 개인화 없이 **전역적으로 인기 있는/활발한 계정**을 보여준다.

- **Popularity model**: 유저 히스토리가 null이라 일반적으로 인기 있는 항목을 추천. *"the very first step is to apply a popularity based strategy"*.
- **Activity / quality 신호**: Facebook PYMK도 후보의 **최근 활동성**(최근 7~30일 engagement, 활동 일수), **프로필 조회 비율**, **친구 요청 수락률**, 보유 게시물/사진 수 같은 "활발하고 품질 좋은 계정" 신호를 랭킹에 쓴다.
- **Instagram**: 초기 연결이 없으면 phone contacts / Facebook 친구와 함께 **general trends와 popular accounts**에 의존한다.

### 트레이드오프
- **장점**: 항상 보여줄 무언가가 있고, 구현이 단순(전역 카운트/랭킹)하며 캐시하기 쉽다.
- **단점**: 개인화가 0에 가까워 관련성이 낮다. **rich-get-richer(인기 편중)** 와 **filter bubble/낮은 다양성**을 강화한다. 실제 관계로 전환되는 비율(수락률)이 연락처 기반보다 낮다.

> **diet-setlog 적용 메모**: v1에서 "친구 0명인데 카카오 친구목록도 비어있/미동의" 구간의 폴백이 바로 이것이다. seed/mock + 활동수(postCount) 기반 정렬로 빈 화면을 피한다.

---

## 5. 위치/근접 기반 추천 (Location / Proximity-based)

### 어떻게 / 어디서
지리적 근접성으로 후보를 만든다. 같은 장소·이벤트에 있었거나, 같은 IP/네트워크에서 접속한 사람 등.

- **Facebook**: 위치 서비스가 켜져 있으면 같은 위치·이벤트를 자주 가는 사람을 교차참조해 추천에 쓴다는 보도. 다만 위치 데이터를 PYMK에 쓰는지에 대해 Facebook은 처음엔 사용한다고 했다가 이후 사용하지 않는다고 입장을 바꾼 적이 있어 **확실하지 않다** ([CBC News](https://www.cbc.ca/news/trending/facebook-gps-location-data-new-friends-people-you-may-know-1.3656555)).
- **Facebook "Nearby Friends"**(2014, opt-in): 정확한 좌표가 아니라 **근접(proximity)** 을 양방향 동의 하에 공유 — 새 사람 발굴보다는 기존 친구 만남 보조에 가깝다.
- **Nextdoor**: 동네(neighborhood) 단위로 묶는 위치 기반 소셜 네트워크.

### 트레이드오프
- **장점**: 그래프가 없어도 "동네/같은 학교/같은 행사" 같은 현실 맥락을 제공.
- **단점**: **프라이버시 민감도가 가장 높다**. 정확 좌표 노출은 위험하므로 대부분 **근사 위치(approximate)·거리 반경(radius)** 만 노출하고 opt-in을 둔다.

---

## 6. 온보딩 플로우 — 관심사 질문 / 시드 계정 팔로우 (Onboarding: Interests & Seed Accounts)

### 어떻게 / 어디서
가입 직후 **명시적으로 관심사를 묻거나, 팔로우할 시드(seed) 계정·토픽을 고르게** 해서 빈 그래프를 직접 채운다. 이는 *친구* 그래프 대신 *관심사/팔로우* 그래프를 먼저 만드는 전략으로, 특히 비대칭 팔로우(asymmetric follow) 기반 서비스(X/Twitter, Instagram)에서 핵심이다.

- **X (구 Twitter)**: 온보딩에서 관심사를 고르게 하고, 거의 유일하게 **"누군가 한 명을 팔로우하는 것"을 필수**로 만들어 타임라인을 채운다. 또한 *"친구 찾기도 중요하지만, 리텐션엔 올바른 interest 기반 계정으로 그래프를 시딩하는 게 더 중요"* 하다고 본다.

### 트레이드오프
- **장점**: 유저의 explicit signal(직접 입력한 관심사)을 얻어 첫 추천 관련성을 크게 높이고, content-based 추천과 결합 가능.
- **단점**: 온보딩 마찰(friction) 증가 → 가입 이탈 위험. 유저가 고른 관심사가 실제 행동과 다를 수 있다. 친구 그래프 자체를 만들어주진 못한다(팔로우 ≠ 상호 친구).

---

## 7. Cold-Start 휴리스틱 → 그래프 기반(FoF)으로의 전환

핵심 패턴은 **"엣지가 생기는 순간 외부 신호에서 그래프 신호로 무게중심을 옮긴다"** 이다.

- **친구 0명**: 위 2~6절의 **그래프 외부 소스**에만 의존 — 연락처/소셜 로그인 임포트(가장 강력) → 인기·활동·위치·관심사(폴백).
- **친구 ≥ 1명**: 즉시 **friends-of-friends / mutual friends** 가 동작하기 시작한다. 한 명만 연결돼도 그 친구의 친구들이 후보가 되고, mutual count로 랭킹된다.
- **친구가 많아질수록**: mutual friends 수가 지배적 신호가 되고, collaborative filtering·graph embedding이 풍부한 historical preference로 정밀해진다. Facebook은 유저의 **친구 수·사용 빈도·지역에 따라 이 신호들을 다르게 적용**한다고 밝힌다 — 즉 적응형(adaptive)으로 cold-start 단계와 graph 단계를 섞는다.

이 전환은 보통 **하드 스위치가 아니라 가중치 블렌딩(blending)** 이다. 신규 유저는 외부 신호 가중치를 높게, 그래프가 자라면 점진적으로 그래프 신호 가중치를 높인다.

> **요약 패턴**
> **0 friends → external source(연락처/소셜 로그인) + 폴백(인기·위치·관심사 온보딩)**
> **≥1 friend → friends-of-friends / mutual-friends(그래프 기반)로 점진 전환(weight blending)**
>
> → diet-setlog의 §4.6 분기("0명=카카오 친구 / 1명+=친구의 친구")가 정확히 이 패턴이다. 단 우리는 v1에서 하드 스위치로 단순화했고, 추후 blending으로 발전 가능.

---

## 8. 한국 맥락 — KakaoTalk 기반 친구 추천

한국 앱 생태계에서는 **카카오톡이 사실상의 소셜 그래프 + 신원 레이어**라, 신규 소셜/커뮤니티 앱이 cold-start를 풀 때 **카카오톡 친구 목록·전화번호 매칭**을 표준 부트스트랩으로 쓴다.

- KakaoTalk 자체가 **전화번호 기반 매칭**(연락처로 친구 추가)으로 그래프를 만든다.
- 카카오 로그인(Kakao OAuth)으로 가입하면 카카오 친구 목록(동의 항목)을 받아 초기 추천에 쓰는 패턴이 흔하다. (단, 친구 목록 제공은 카카오의 동의/검수 정책에 따르므로 실제 가용 범위는 앱 심사 시점에 확인 필요 — 불확실성 있음.)
- 프라이버시 민감도가 높아, 카카오의 "추천 친구"는 2016년 논란 후 철회됐고 **전화번호로 친구 추가 허용 옵션**이 기본 안전장치로 자리잡았다.

**설계 시사점**: 한국 타깃 앱이라면 (1) 카카오 로그인 + 전화번호/연락처 매칭을 1차 부트스트랩으로, (2) 명시적 옵트인과 "전화번호로 찾기 허용" 설정을 반드시 함께 제공하는 것이 안전하다.

---

## 9. 정리

| 단계 | 주 신호 | 대표 사례 | 핵심 리스크 |
|---|---|---|---|
| 친구 0명 | 연락처/이메일 임포트 | KakaoTalk, WhatsApp, FB PYMK | 프라이버시(역방향 노출) |
| 친구 0명 | 소셜 로그인 친구 그래프 | (구) Facebook `user_friends`, Kakao | API 제한·정책 변경 |
| 친구 0명 | 인기/활동 기반 | Instagram, popularity model | 인기 편중·낮은 관련성 |
| 친구 0명 | 위치/근접 | FB Nearby Friends, Nextdoor | 위치 프라이버시 |
| 친구 0명 | 관심사/시드 팔로우 온보딩 | X(Twitter), 토픽 팔로우 | 온보딩 마찰 |
| 친구 ≥1명 | FoF / mutual friends | FB PYMK, KakaoTalk | (그래프 기반으로 정밀화) |

신규 유저에겐 **그래프가 없으니 FoF가 불가능**하다는 게 본질적 어려움이고, 해법은 일관되게 **"그래프 외부 소스로 첫 엣지를 만든 뒤, 엣지가 생기는 즉시 그래프 기반으로 무게를 옮긴다"** 이다.

---

## 출처 (Sources)

- [Meta — People You May Know (Transparency Center)](https://transparency.meta.com/features/explaining-ranking/fb-people-you-may-know/)
- [Auth0 — Facebook Graph API Changes (`user_friends` 제한)](https://auth0.com/docs/troubleshoot/product-lifecycle/past-migrations/facebook-graph-api-changes)
- [KakaoTalk Safety Guide — Add Friends with Phone Number Settings](https://talksafety.kakao.com/en/toolandguide/unwanted/addfriendssettings)
- [Korea Bizwire — KakaoTalk's "Recommended Friends" Service Under Fire](http://koreabizwire.com/kakaotalks-recommended-friends-service-under-fire/68519)
- [X (Twitter) — Account Recommendations (Help Center)](https://help.x.com/en/resources/recommender-systems/account-recommendations)
- [HackerNoon (A. Taub) — How Twitter Can Solve Its Onboarding Problem](https://medium.com/hackernoon/how-twitter-can-solve-its-onboarding-problem-7f46bd5b3ce2)
- [TechCrunch — Facebook Launches "Nearby Friends"](https://techcrunch.com/2014/04/17/facebook-nearby-friends/)
- [CBC News — Is Facebook using your location data to suggest 'people you may know'?](https://www.cbc.ca/news/trending/facebook-gps-location-data-new-friends-people-you-may-know-1.3656555)
- [freeCodeCamp — What is the Cold Start Problem in Recommender Systems?](https://www.freecodecamp.org/news/cold-start-problem-in-recommender-systems/)
- [Express Analytics — How machine learning solves the cold start problem](https://www.expressanalytics.com/blog/cold-start-problem)
- [Things Solver — How to solve the cold start problem](https://thingsolver.com/blog/the-cold-start-problem/)
- [Hindawi (2020) — Pure New User Cold-Start Problem](https://www.hindawi.com/journals/misy/2020/8912065/)
- [ACM RecSys — Social collaborative filtering for cold-start recommendations](https://dl.acm.org/doi/abs/10.1145/2645710.2645772)

> **불확실성 / 주의**: (1) Facebook이 PYMK에 위치 데이터를 실제로 쓰는지는 회사 입장이 번복된 적이 있어 단정할 수 없다. (2) 소셜 로그인을 통한 *친구 목록 통째 임포트*는 Facebook(`user_friends`) 등에서 정책상 크게 제한되었고, 카카오 등도 친구 목록 제공 범위가 심사·동의 정책에 따라 달라지므로 구현 전 최신 플랫폼 정책을 반드시 재확인해야 한다.
