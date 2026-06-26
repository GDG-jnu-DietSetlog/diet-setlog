# 친구 추천(PYMK) 시스템의 아키텍처와 스케일

> 수억 명 규모 소셜 서비스가 "알 수도 있는 사람(People You May Know, PYMK)"을 어떻게 계산·서빙하는지 조사하고, 이를 초기 단계 소규모 앱(단일 Postgres + Redis)에 어떻게 적용할지 정리한 문서.

## 1. 대규모 서비스의 파이프라인 — offline batch + online ranking

대규모 친구 추천의 핵심 패턴은 **무거운 계산을 미리(offline/batch)** 해두고, **요청 시점(online)에는 가벼운 조회·랭킹만** 하는 분리다.

### 후보 생성(candidate generation) vs 온라인 랭킹(ranking) 분리

현대 추천 시스템은 보통 **multi-stage funnel** 구조다.

- **Candidate generation(후보 생성)**: 수백만~수십억 후보 풀을 빠르고 거칠게 수백~수천 개로 좁힌다. 메타데이터 필터, k-NN, friends-of-friends 그래프 탐색 등을 사용한다. 정확도보다 **recall과 속도**가 우선.
- **Ranking(랭킹)**: 좁혀진 후보를 수백 개 feature를 쓰는 무거운 모델(L1/L2)로 정밀 점수화한다.

이 분리 덕분에 비싼 모델을 전체 사용자×전체 후보가 아니라 **소수 후보에만** 적용할 수 있다.

### LinkedIn PYMK — Hadoop 정밀 배치에서 시작한 역사

LinkedIn PYMK는 이 패턴의 교과서적 사례다.

- **초기**: 커넥션 그래프를 Oracle에 두고 SQL 스크립트로 추천을 생성, 결과를 다시 SQL에 저장해 조회했다. 멤버가 늘면서 한 번의 PYMK 계산에 **약 6개월**이 걸리는 지경이 됐다고 전해진다.
- **Hadoop 전환**: PYMK는 사실상 **LinkedIn이 Hadoop을 도입한 첫 이유**였다. 12노드 Hadoop 클러스터로 같은 계산을 **약 2주**로 단축했고, SQL 스크립트 대신 MapReduce 잡으로 후보를 **미리 계산(precompute)** 했다.
- **핵심 신호 — friends-of-friends(triangle closing)**: Alice—Bob, Bob—Carol이면 Alice—Carol을 닫는다(삼각형 닫기). 닫힌 삼각형 후보를 같은 회사/학교 여부, 나이 차이, 지리적 거리 등 feature로 점수화한다.
- **랭킹/인프라**: 수백 feature를 합치는 logistic regression(이진 분류), 수십억 샘플 학습. 주변 인프라로 **Voldemort**(key-value store), **Azkaban**(Hadoop 워크플로), **Apache Kafka**(스트리밍)가 등장한다. 무시된 추천의 순위를 낮추는 **impression discounting**도 적용.
- **규모**: PYMK는 LinkedIn 직업 그래프의 50% 이상을 만들었고, 매일 수백 TB 데이터·수천억 잠재 커넥션을 처리해 결과를 갱신했다고 한다.

### LinkedIn의 현대 아키텍처 — 배치에서 near-real-time으로

순수 배치 precompute의 약점은 **staleness(신선도)** 다. 기존 precompute 기반은 1~2일 지연이 있었다. 이를 줄이기 위해 LinkedIn은 두 시스템 중심으로 재설계했다(InfoQ 발표 기준).

- **Gaia**: 실시간 그래프 컴퓨팅 계층. **on-demand로 그래프를 walk** 하여 후보 생성을 담당하고, "두 사람의 공통 커넥션 수" 같은 그래프 feature도 제공한다. **off-memory(메모리상)** 로 동작해 공통 커넥션을 수십 ms에 계산.
- **Venice**: read-heavy 워크로드용 오픈소스 분산 **key-value store**. derived data 서빙에 최적화. PYMK는 Gaia에서 후보+그래프 feature를 받고, **Venice에서 나머지 feature와 일부의 partial scoring** 을 받은 뒤, **최종 scoring** 을 PYMK 서비스가 수행한다.
- **효과**: staleness가 1~2일에서 **초~분 단위** 로 감소.

> 참고: 위 Gaia/Venice 세부는 LinkedIn 엔지니어의 InfoQ 발표 요약에 근거하며, 공개 발표 시점 이후 내부 구조는 달라졌을 수 있다(불확실성 명시).

### Facebook / 일반 패턴

Facebook의 공개 자료는 PYMK 알고리즘 자체보다 **그래프 저장 계층**(아래 TAO)에 집중돼 있다. 다만 일반화된 multi-stage funnel(two-tower retrieval → L1/L2 ranking → 비즈니스 가드레일 재랭킹)은 Netflix·YouTube·Amazon 등 대규모 서비스가 공유하는 표준 골격이다. 오프라인에서 **item/embedding을 precompute해 색인**하고, 서빙 시 user tower만 온라인으로 돌려 nearest neighbor를 조회하는 식이며, 결과는 Redis 같은 **key-value store**에 저장해 near-real-time으로 읽는다.

### 실시간/증분 업데이트 vs 야간 배치

순수 배치(야간 갱신)는 단순하지만 신선하지 않다. 그 반대편 극단이 **요청 순간 그래프를 실시간 탐색**하는 방식이다.

- **Twitter GraphJet**: user-tweet 상호작용의 실시간 bipartite 그래프를 메모리에 유지하며, 최근 n시간 edge만 보관하고 오래된 edge는 버려 메모리 무한 증가를 막는다. personalized SALSA 기반 random walk로 out-of-network 추천을 생성.
- **Pinterest Pixie**: 전날 밤 배치 대신, **사용자가 앱을 여는 순간** 밀집 그래프 위에서 random walk(약 10만 step, 매 step 랜덤 이웃 방문·방문 카운트 증가)를 실시간 수행.

실무에서는 보통 **하이브리드**다: 비싼 후보·feature는 배치로 미리 만들고, 최근 활동/엣지 변화는 nearline(준실시간) 또는 on-demand로 보강한다.

## 2. 그래프 저장/탐색 at scale

수억 노드 그래프에서 친구 추천을 하려면 **그래프 자체를 빠르게 읽고 탐색**할 수 있어야 한다. 관계형 조인만으로는 high-degree 탐색이 버겁다.

### Facebook TAO — 소셜 그래프 저장소

TAO("The Associations and Objects")는 Facebook의 소셜 그래프 전용 분산 데이터 스토어다(USENIX ATC 2013).

- **데이터 모델**: **objects(노드)** + **associations(엣지)** 의 단순 그래프 모델. 복잡한 관계형 쿼리 대신 고정된 소수의 쿼리 패턴에 최적화.
- **read-heavy 최적화**: 2단 캐싱(leaders + followers). leader가 쓰기를 처리·전파하고 follower가 읽기를 서빙. 지리적으로 분산.
- **스케일**: 변화하는 페타바이트 규모 데이터셋에서 **초당 10억 건 읽기** 지속. 많은 데이터 타입에서 memcache를 대체.

### 전용 그래프 저장소의 일반 패턴

LinkedIn도 멤버 930M+ 규모에서 실시간 그래프 접근을 위해 **LIquid** 같은 전용 그래프 DB로 이동했다. 공통점은 **인접 리스트(adjacency)를 메모리/캐시 친화적으로 저장**하고, 고정된 탐색 쿼리(이웃, 공통 이웃, 2-hop)를 ms 단위로 답하도록 특화한다는 점이다.

## 3. friends-of-friends의 비용 문제와 완화책

friends-of-friends(2-hop)는 직관적이지만 **fan-out 폭발(quadratic blowup)** 위험이 크다.

### 왜 폭발하는가

- 친구가 k명인 사용자의 friends-of-friends는 (중복 포함) 대략 **k²** 규모. 실제로는 이미 친구인 경우가 많아 약간 줄지만, 여전히 제곱 스케일이다.
- 소셜 그래프는 **power-law(멱법칙) degree 분포** 다. 소수의 **high-degree 노드(슈퍼노드)** 가 존재하고, **friendship paradox** 때문에 임의 엣지의 끝은 high-degree 노드일 확률이 높다. 즉 2-hop 탐색은 자연스럽게 슈퍼노드를 거치며 후보가 폭증한다.

### 완화책

- **Degree cap / 슈퍼노드 제외**: degree가 매우 큰 노드는 2-hop 확장에서 제외하거나 상한을 둔다(이런 노드는 신호가 약함 — "유명인의 친구"라는 사실은 정보량이 적다).
- **Sampling**: 모든 이웃을 펼치지 않고 이웃의 일부만 샘플링해 탐색.
- **Top-N / 점수 기반 가지치기**: 공통 친구 수, 상호작용 등으로 후보를 **top-N만** 남긴다.
- **Precompute + KV 저장**: 2-hop 결과(또는 공통 친구 수)를 배치로 계산해 key-value store에 저장하고 서빙 시 조회만 한다(LinkedIn의 Voldemort/Venice 패턴).
- **Random walk로 대체**: 전수 2-hop 대신 random walk(Pixie/GraphJet)로 "사실상의 friends-of-friends"를 확률적으로 근사 — 슈퍼노드를 자연스럽게 덜 방문하도록 가중치 조절 가능.
- **캐싱**: 공통 친구 수처럼 반복 조회되는 값은 TTL 캐시.

## 4. 소규모 앱을 위한 실용 가이드 (Postgres + Redis 단계별)

초기 앱(수천~수십만 사용자, 단일 Postgres + Redis)은 위 대규모 인프라가 **필요 없다**. 과도한 선반영(over-engineering)을 피하고 단계적으로 올린다. diet-setlog처럼 트래픽 스파이크가 있는 서비스라면, 핫 경로의 DB 부하만 우선 관리하면 된다.

### 단계 0 — 그래프는 그냥 테이블

```
friendships(user_id, friend_id)   -- 양방향이면 (a,b),(b,a) 둘 다 저장 권장
```

`(user_id, friend_id)`에 인덱스. 양방향을 둘 다 저장하면 "내 친구 목록" 조회가 단일 인덱스 스캔으로 끝난다(N+1 회피).

> diet-setlog 메모: 우리 `FriendRelation`은 단방향(follower→following) + `@@unique(followerId, followingId)`라 followerId 프리픽스 인덱스로 "내 친구 목록"을 커버한다. 친구를 상호관계로 정의한다면 양방향 저장도 고려.

### 단계 1 — on-demand friends-of-friends (이때까지는 충분)

2-hop은 한 번의 self-join으로 충분하다(재귀 CTE까지 갈 필요 없음).

```sql
SELECT f2.friend_id AS candidate, COUNT(*) AS mutuals
FROM friendships f1
JOIN friendships f2 ON f1.friend_id = f2.user_id
WHERE f1.user_id = :me
  AND f2.friend_id <> :me
  AND f2.friend_id NOT IN (SELECT friend_id FROM friendships WHERE user_id = :me)
GROUP BY f2.friend_id
ORDER BY mutuals DESC
LIMIT 20;
```

- **공통 친구 수(`mutuals`)를 그대로 랭킹 신호로** 쓴다 — 초기엔 ML 불필요.
- **주의(fan-out)**: 위 쿼리도 슈퍼노드가 끼면 폭발한다. 완화: degree가 너무 큰 친구 제외, `LIMIT`/타임아웃, `statement_timeout` 설정. 결과는 `LIMIT N`으로 항상 제한.

### 단계 2 — Redis로 캐싱 + denormalized counter

- **추천 결과 캐시**: 사용자별 추천 리스트를 Redis에 **TTL(예: 수 시간)** 로 저장. 추천은 매 요청 새로 계산할 필요가 없다(친구 관계는 자주 안 변함).
- **denormalized counter**: `friend_count`, (선택) 자주 쓰는 쌍의 `mutual_count`를 컬럼/캐시로 비정규화해 랭킹·표시를 O(1)로. 친구 추가/삭제 시에만 갱신.
- **N+1 금지**: 추천 카드에 보여줄 프로필/공통 친구 수는 **목록 응답에 batch로** 합쳐 내려준다. 목록은 `?cursor=&limit=` 페이지네이션.

> diet-setlog 메모: 우리 설계의 `friendCount`/`postCount` denormalized 카운터 + cursor 무한스크롤이 정확히 이 단계다.

### 단계 3 — precompute로 이동하는 시점

다음 신호가 보이면 on-demand에서 **배치 precompute**로 옮긴다.

- 친구 추천 쿼리가 핫 경로 p95 지연을 끌어올린다.
- 슈퍼노드 때문에 일부 사용자 쿼리가 타임아웃 난다.
- DB CPU가 추천 self-join에 과하게 쓰인다.

이행 방법(여전히 Postgres + Redis로 가능):

1. **야간/주기 배치 잡**으로 활성 사용자에 대해 friends-of-friends + 공통 친구 수를 미리 계산.
2. 결과를 **Redis(또는 Postgres의 추천 테이블)** 에 `user_id -> [추천 리스트]` 형태로 저장.
3. 서빙은 **조회만**(LinkedIn 초기 Hadoop→Voldemort 패턴의 축소판).
4. 최근에 생긴 친구 관계는 nearline으로 보강(엣지 추가 이벤트 시 해당 사용자 추천만 무효화/재계산).

이 단계에서 **stateless 서빙, DB 커넥션 풀링, 레이트 리미팅**(스파이크 보호)을 함께 챙긴다 — diet-setlog 백엔드 가이드라인과 일치.

### 단계 4 — 이때 비로소 전용 인프라 고려

수백만+ 사용자, 실시간성·복잡 feature가 필요해지면 그때 graph DB(또는 TAO/LIquid류 패턴), 별도 candidate-generation/ranking 분리, 전용 KV feature store를 검토한다. **그 전에 도입하면 과투자**다.

### 요약 결정 표

| 규모/증상 | 권장 방식 |
|---|---|
| ~수만 사용자, 추천 호출 적음 | 단계 1: on-demand self-join + `LIMIT` |
| 반복 호출/표시 부하 | 단계 2: Redis TTL 캐시 + denormalized counter |
| 핫 경로 지연/슈퍼노드 타임아웃 | 단계 3: 배치 precompute → KV 조회 |
| 수백만+·실시간·복잡 feature | 단계 4: 전용 graph DB + candidate/ranking 분리 |

---

## 출처 (Sources)

- [LinkedIn Engineering — People You May Know](https://engineering.linkedin.com/teams/data/artificial-intelligence/people-you-may-know)
- [InfoQ — People You May Know: Fast Recommendations over Massive Data](https://www.infoq.com/presentations/recommendation-massive-data/)
- [InfoQ — Lessons Learned from Building LinkedIn's AI Data Platform (Venice)](https://www.infoq.com/presentations/ai-venice/)
- [LinkedIn Engineering — How LIquid Connects Everything](https://engineering.linkedin.com/blog/2023/how-liquid-connects-everything-so-our-members-can-do-anything) / [InfoQ — LinkedIn's LIquid Graph Database](https://www.infoq.com/news/2023/06/linkedin-liquid-graph-database/)
- [TAO: Facebook's Distributed Data Store for the Social Graph (USENIX ATC 2013, PDF)](https://www.usenix.org/system/files/conference/atc13/atc13-bronson.pdf)
- [GraphJet: Real-Time Content Recommendations at Twitter (VLDB, PDF)](https://www.vldb.org/pvldb/vol9/p1281-sharma.pdf)
- [Pixie: A System for Recommending 3+ Billion Items in Real-Time (arXiv)](https://arxiv.org/pdf/1711.07601) / [Pinterest Engineering — Introducing Pixie](https://medium.com/pinterest-engineering/introducing-pixie-an-advanced-graph-based-recommendation-system-e7b4229b664b)
- [Estimating Exposure to Information on Social Networks (arXiv:2207.05980)](https://arxiv.org/pdf/2207.05980) — friends-of-friends ≈ k²
- [The Anatomy of the Facebook Social Graph (arXiv:1111.4503)](https://arxiv.org/pdf/1111.4503) — power-law degree 분포
- [eugeneyan — System Design for Recommendations and Search](https://eugeneyan.com/writing/system-design-for-discovery/) / [Databricks — Building an Online Recommendation System](https://www.databricks.com/blog/guide-to-building-online-recommendation-system)
- [PostgreSQL Documentation — WITH Queries (CTE)](https://www.postgresql.org/docs/current/queries-with.html)

> 불확실성 메모: LinkedIn Gaia/Venice·InfoQ 발표 기반 세부 수치(수십 ms, staleness 초·분 등)는 발표 시점의 공개 정보이며 이후 내부 구조는 변경됐을 수 있다. Pixie의 step 수(~10만), TAO의 초당 read 수치는 각 논문/발표 기준 공개값이다.
