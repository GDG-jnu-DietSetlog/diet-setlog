# 글로벌 소셜 서비스의 친구 추천(PYMK / "People You May Know") 구현 리서치

## PYMK란 무엇인가

**PYMK(People You May Know)** 는 소셜 서비스가 "당신이 알 수도 있는 사람"을 자동으로 찾아 추천하는 기능군의 통칭이다. 서비스별 명칭은 다르다 — Facebook은 "People You May Know", LinkedIn도 같은 명칭, Instagram은 "Suggested for you / 추천", X(Twitter)는 "Who to follow", TikTok은 "Find Friends / 추천 계정", Snapchat은 "Quick Add"로 부른다.

기술적으로 PYMK는 **"두 사람이 서로 아는 사이인가"를 예측하는 이진 분류(binary classification) 문제**로 정식화되는 경우가 많고, 보통 다음 2단계 파이프라인으로 구현된다.

1. **후보 생성(Candidate Generation)** — 소셜 그래프 탐색(friends-of-friends), 연락처 매칭, 임베딩 기반 유사도 검색 등으로 수백~수천 명의 후보를 뽑는다.
2. **랭킹(Ranking)** — 머신러닝 모델(과거에는 로지스틱 회귀, 현재는 신경망/Two-Tower 등)로 "친구 요청을 보낼/수락할 확률"을 점수화해 상위 N명을 노출한다.

공통적으로 활용되는 신호(signal)는 (a) **상호 친구/친구의 친구(mutual friends, triangle closing)**, (b) **연락처·전화번호·이메일 업로드(address book import)**, (c) **프로필 중첩(직장·학교·지역)**, (d) **상호작용 신호(like/comment/방문)**, (e) **위치(location)** 등이다. 아래 각 서비스별로 공개된 내용을 정리한다.

> 주의: 추천 알고리즘은 각 사 모두 "자주 바뀐다"고 명시한다. 아래 내용은 공개된 공식 문서/엔지니어링 블로그/언론 보도 기준이며, 일부는 시점이 오래되었거나 추정이 섞일 수 있어 해당 부분은 명시했다.

---

## 1. Facebook / Meta — "People You May Know" (PYMK)

Meta가 운영하는 공식 투명성(Transparency) 문서가 가장 신뢰할 수 있는 1차 출처다. PYMK는 **여러 ML 모델의 조합**이며, 후보 생성 → 랭킹 → Community Standards 필터링의 3단계로 동작한다.

- **후보 출처**: 기존 친구의 친구(friends-of-friends), 같은 그룹 소속, 그리고 **연락처(이메일·전화번호) 업로드 매칭** — 본인 또는 상대방이 업로드한 연락처에 당신 정보가 포함되면 후보가 될 수 있음.
- **핵심 개념 — Triangle closing**: Alice–Bob, Bob–Carol이 연결돼 있으면 Alice–Carol을 후보로 본다. 여기에 직장/학교 중첩, 나이 차, 지리적 거리 등을 feature로 사용 (engineering 자료 기준).
- **랭킹 신호** (Meta Transparency 문서 명시):
  - 상호 친구 수 / **전체 친구 대비 상호 친구 비율(mutual friend ratio)**
  - 최근 7일/30일간의 전환(conversion: like, comment, share) 등 의미 있는 상호작용
  - 추천 대상이 받은 **대기 중 친구 요청 수(pending requests)**, 과거 요청 거절 이력
  - 기존/과거 친구들과의 **추정 연결 강도(estimated strength of connections)**
  - 프로필 활동 최신성, 과거 친구 요청 수락률
  - 사용자 활성도에 따라 모델을 분기(활성 사용자 60명+ vs 비활성 사용자 등)
- **규모**: 엔지니어링 보도에 따르면 하루 수백 TB, 수천억 개의 잠재 연결을 처리(2차 네트워크 탐색으로 데이터가 서비스 규모보다 빠르게 증가).
- **논란/공개 발언**: PYMK는 10년 넘게 프라이버시 논란의 중심이었다. Gizmodo 보도("How Facebook Figures Out Everyone You've Ever Met", 2017)에 따르면 **섀도우 컨택트(shadow contacts), 연락처 업로드를 통한 간접 매칭**으로 환자–정신과 의사, 성매매 종사자와 고객, 절연한 가족 등 "예상치 못한 사람"이 추천돼 비판받았다. Facebook은 정확한 신호 목록을 완전히 공개한 적이 없어 "블랙박스"라는 비판이 있다.

---

## 2. LinkedIn — "People You May Know" (PYMK)

LinkedIn 엔지니어링 블로그가 비교적 상세하게 기술적 구조를 공개한 편이다. PYMK를 **"두 사람이 서로 아는가"의 이진 분류**로 정의한다.

- **후보 생성 3가지 방식** (공식 블로그 "Candidate Generation in a Large Scale Graph Recommendation System"):
  1. **N-hop 이웃 (그래프 워크)**: 뷰어의 2-hop, 3-hop 이웃을 결정론적으로 탐색하고 **공통 연결(common connections) 수**로 점수화 → friends-of-friends / triangle closing.
  2. **Personalized PageRank (PPR)**: 확률적 랜덤 워크를 근접 이웃에 "soft-confine"해 5~6 hop까지 더 깊게 탐색하면서 개인화 유지.
  3. **임베딩 유사도 검색**: **Two-Tower 신경망**으로 학습한 member embedding(학교·회사·geo·activity 등 feature)에 대해 nearest-neighbor 검색. 노출(impressed) 후보를 positive로 사용해 비활성 사용자 편향을 줄임.
  4. (보조) **휴리스틱 필터**: 최근 피드에서 상호작용했거나 프로필을 본 사람.
- **feature/신호**: 직장·학교 중첩, 나이 차, 지리적 거리, 공통 연결 수, activity 등.
- **모델**: (과거) 수백 개 feature를 결합한 **로지스틱 회귀** + 자체 오픈소스 대규모 ML 라이브러리로 수십억 샘플 학습. 후보 생성 기법을 1-hot 인코딩한 categorical feature를 랭킹의 bias term으로 추가.
- **인프라**: 일부 자료는 그래프 탐색에 **LIquid** 그래프 DB, 피처 저장에 Venice, 분석에 Pinot을 사용한다고 언급. (단, candidate-generation 글 본문에는 LIquid 언급이 없었음 — LIquid는 별도의 "How LIquid Connects Everything" 글에서 다뤄짐. 두 글이 별개라는 점 유의.)
- **공개 발언/특이점**: LinkedIn은 "Optimizing PYMK for equity in network creation" 블로그에서 추천이 활성/인기 사용자에게 쏠리는 **불균형(equity) 문제**를 인지하고 보정한다고 공개. 규모는 Facebook과 유사하게 하루 수백 TB·수천억 잠재 연결.

---

## 3. Instagram — "Suggested for you" / 추천 계정

Meta Transparency 문서가 1차 출처. 관심사·상호작용 기반의 개인화 추천이며, 후보 생성 → ML 랭킹 구조다.

- **후보 출처** (공식 문서 명시):
  - 당신이 팔로우하는 계정의 **팔로워들(followers of accounts you follow)**
  - **지역(geographical region) 내 인기 계정**
  - 최근 engage한 **토픽·상품 관련 계정**
- **랭킹 신호**:
  - 상호 친구/팔로워 수 (가장 강한 신호 중 하나)
  - 추천 계정의 팔로워 수, 인기 팔로워 수, 팔로잉 수
  - 상대가 당신을 팔로우한 지 얼마나 됐는지, 상대가 이미 당신을 팔로우 중인지(맞팔 가능성)
  - 최근 28일간 당신의 팔로우 수, 추천 계정과의 친밀도(closeness)
  - 비공개 계정 여부
- **연락처 관련**: 공식 랭킹 문서는 **랭킹 단계에서 연락처 데이터 사용을 명시하지 않으며**, 연락처 동기화/해제는 별도 기능으로 언급된다. 다만 외부/서드파티 가이드는 **연락처 동기화 시 전화번호 매칭으로 후보가 된다**고 설명하므로, 연락처는 (랭킹보다는) 후보 생성/별도 경로로 쓰인다고 보는 것이 안전하다. (서드파티 정보는 비공식이므로 주의.)
- **명시적 부인**: 일부 서드파티 글은 "**프로필 방문·검색은 추천 신호로 쓰이지 않는다**"고 주장하나, 이는 비공식 출처 기반이라 단정하기 어렵다.

---

## 4. Twitter / X — "Who to follow"

X는 2023년 추천 알고리즘 일부를 오픈소스로 공개했으나, "Who to follow"(팔로우 추천) 자체에 대한 1차 상세 문서는 제한적이다. 아래는 X 도움말 및 서드파티 분석 기반.

- **연락처 기반**: 당신이 업로드한 연락처, 또는 **당신의 연락처 정보가 타인의 주소록에 있는 경우** 서로를 추천할 수 있음.
- **그래프/관심사 신호**: 이미 팔로우한 계정, 상호작용한 토픽을 바탕으로 추천.
- **SimClusters**: X가 공개한 핵심 개념으로, **비슷한 토픽을 논하는 사용자 커뮤니티(community)** 를 군집화해 관련성을 판단하고 계정/콘텐츠를 추천. (오픈소스 알고리즘에서 확인되는 실제 컴포넌트.)
- **위치(location)**: 비슷한 지역/콘텐츠 기반 추천 가능.
- **광고**: "Who to follow"에는 **Promoted Accounts(광고 계정)** 가 섞여 노출될 수 있음.
- **프라이버시 제어**: 사용자가 설정에서 연락처 기반 추천을 끌 수 있음.
- 주의: 위 SimClusters를 제외한 세부 신호 상당수는 Sprout Social·SocialBee 등 **서드파티 분석(비공식)** 에 의존하므로, 정확한 가중치/전체 신호 목록은 확정적이지 않다.

---

## 5. TikTok — "Find Friends" / 추천 계정

TikTok 공식 프라이버시 블로그("Contact Synching, Find Friends and Suggested Accounts")가 1차 출처. 연락처 접근은 **항상 명시적 동의 기반**임을 강조한다.

- **연락처 동기화(Contact Syncing)**: 사용자가 **명시적으로 동기화에 동의**하면, 연락처의 전화번호·이메일에 해당하는 TikTok 계정을 추천. 언제든 철회 가능. 자동 접근은 하지 않음.
- **소셜 미디어 연동**: **Facebook 등 외부 계정 연결** 시, 양측이 모두 연결했다면 Facebook 친구 중 TikTok 사용자를 추천.
- **상호 연결(Mutual connections)**: 공통으로 아는 사람(공통 팔로잉)을 통한 "디지털 입소문" 방식 추천.
- **공유 상호작용(Shared interactions)**: 같은 영상에 좋아요/유사 콘텐츠에 댓글 등 engagement 패턴이 겹치면 추천.
- **프라이버시 보호 기술**: 연락처 매칭에 **PSI(Private Set Intersection), 해싱·암호화, 보안 다자간 연산(MPC)** 을 적용해 원본 연락처 노출을 줄인다고 공식 명시 — 이 부분이 타 서비스 대비 기술적으로 두드러짐.

---

## 6. Snapchat — "Quick Add"

Snapchat의 공식 설명은 비교적 간단하다: "이미 친구인 사람, 구독하는 사람, 그리고 기타 요인을 기반으로 한다." 세부는 주로 서드파티(ScreenRant 등) 분석.

- **상호 친구(Mutual friends)**: 가장 흔한 요인 — 친구의 친구. 추천 시 **공통 친구 수**를 함께 표시.
- **구독(Subscriptions)**: 구독 중인 크리에이터/계정 관계.
- **전화 연락처(Phone contacts)**: 주소록에 있는 사람이 Snapchat 계정을 가지고 있으면 Quick Add에 뜰 가능성이 높음.
- **위치 및 그룹 활동(Location)**: 위치 공유 기능과 연동되어 같은 지역 사용자, 같은 그룹 활동 사용자가 노출될 수 있음. (서드파티 분석 기반.)
- **제어**: 사용자가 Quick Add 노출을 끌 수 있음(특히 미성년자 보호 관련 정책 변경 이력 있음 — 단, 이 정책 변경 세부는 본 리서치에서 1차 확인하지 않음).
- 주의: 위치/그룹 활동 등은 **서드파티 출처(비공식)** 기반이므로 정확도에 한계가 있다.

---

## 비교표 (서비스 × 사용 신호)

| 신호 / 서비스 | Facebook | LinkedIn | Instagram | X (Twitter) | TikTok | Snapchat |
|---|---|---|---|---|---|---|
| **상호 친구 / friends-of-friends (triangle closing)** | ✅ 핵심 | ✅ 핵심 (2~3-hop, PPR) | ✅ (상호 팔로워) | ✅ | ✅ (공통 팔로잉) | ✅ 핵심 |
| **연락처/전화·이메일 업로드 매칭** | ✅ | △ (직접 명시 약함) | △ (비공식, 동기화 시) | ✅ | ✅ (명시적 동의) | ✅ |
| **프로필 중첩 (직장·학교·지역)** | ✅ | ✅ 핵심 | △ | △ | ✗ (주력 아님) | ✗ |
| **상호작용 신호 (like/comment/방문/engagement)** | ✅ (7·30일) | ✅ (피드/프로필) | ✅ | ✅ (토픽) | ✅ | △ |
| **임베딩/유사도 기반 (Two-Tower 등)** | △ (ML 다수) | ✅ 명시 | ✅ (ML 랭킹) | ✅ (SimClusters) | △ | ✗ (불명) |
| **위치(location)** | △ (거리 feature) | ✅ (geo feature) | ✅ (지역 인기) | △ | △ | △ (비공식) |
| **외부 소셜 연동** | ✗ | ✗ | ✗ | ✗ | ✅ (Facebook 등) | △ (구독) |
| **광고 계정 혼합** | ✗ | △ | △ | ✅ (Promoted) | △ | ✗ |

> 범례: ✅ 공식/명확히 확인 · △ 부분적/추정/비공식 · ✗ 해당 없음 또는 미확인. △·비공식 항목은 서드파티 출처 기반이라 단정할 수 없음.

### 핵심 시사점 (우리 앱 설계 관점)
- 모든 서비스의 **공통 1순위 신호는 "상호 친구 / friends-of-friends(triangle closing)"** 와 **연락처 매칭**이다. 초기 콜드 스타트(cold start)는 연락처 import가 가장 강력하지만, **프라이버시 논란(Facebook 사례)** 의 핵심이기도 하므로 명시적 동의·철회·PSI 같은 프라이버시 보호 매칭(TikTok 사례)을 기본 전제로 설계해야 한다.
- 구조는 대체로 **후보 생성(그래프/연락처/임베딩) → ML 랭킹** 2단계. 그래프 탐색은 2차 네트워크라 데이터가 폭증하므로(Facebook/LinkedIn 모두 언급), 우리 백엔드의 "트래픽 스파이크/N+1 금지/페이지네이션" 원칙과 직결된다.

---

## 출처 (Sources)

실제로 fetch하여 내용을 확인한 1차 출처:

- [Facebook People You May Know AI system — Meta Transparency Center](https://transparency.meta.com/features/explaining-ranking/fb-people-you-may-know/)
- [Instagram Suggested Accounts AI system — Meta Transparency Center](https://transparency.meta.com/features/explaining-ranking/ig-suggested-accounts/)
- [Candidate Generation in a Large Scale Graph Recommendation System: People You May Know — LinkedIn Engineering Blog](https://www.linkedin.com/blog/engineering/recommendations/candidate-generation-in-a-large-scale-graph-recommendation-system-people-you-may-know)
- [Contact Synching, Find Friends and Suggested Accounts — TikTok Privacy Blog](https://www.tiktok.com/privacy/blog/contact-synching-findfriends/en)

검색 결과로 참조했으나 본문 전체를 fetch하지는 않은 보조 출처(내용 정확도는 위 1차 대비 낮음):

- [People You May Know — LinkedIn Engineering (팀 페이지)](https://engineering.linkedin.com/teams/data/artificial-intelligence/people-you-may-know)
- [Optimizing People You May Know (PYMK) for equity in network creation — LinkedIn Engineering](https://engineering.linkedin.com/blog/2021/optimizing-pymk-for-equity-in-network-creation)
- [How Facebook Figures Out Everyone You've Ever Met — Gizmodo (2017)](https://gizmodo.com/how-facebook-figures-out-everyone-youve-ever-met-1819822691)
- ['People You May Know': A Controversial Facebook Feature's 10-Year History — Gizmodo](https://gizmodo.com/people-you-may-know-a-controversial-facebook-features-1827981959)
- [How the Twitter (X) Algorithm Works — Sprout Social](https://sproutsocial.com/insights/twitter-algorithm/) (서드파티)
- [Understanding how the X (Twitter) algorithm works — SocialBee](https://socialbee.com/blog/twitter-algorithm/) (서드파티)
- [Suggested accounts — TikTok Support](https://support.tiktok.com/en/account-and-privacy/account-privacy-settings/suggested-accounts)
- [How Does Quick Add Work On Snapchat — ScreenRant](https://screenrant.com/snapchat-quick-add-work-how-turn-it-off-can/) (서드파티)

> 정확도 메모: Meta(Facebook/Instagram)·LinkedIn·TikTok 섹션은 공식 문서를 직접 fetch해 작성했다. X(Twitter)와 Snapchat 섹션은 **공식 1차 문서를 직접 fetch하지 못해 서드파티 분석에 더 의존**했으므로, 신호의 정확한 가중치·전체 목록은 확정적이지 않다. SimClusters(X)와 PSI/MPC(TikTok)는 각 사가 공개한 실제 컴포넌트로 신뢰도가 높다.
