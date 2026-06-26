# 친구 추천(Friend Recommendation) 알고리즘과 시그널 — Link Prediction & Candidate Generation/Ranking

## 1. 들어가며: 친구 추천 = 링크 예측 + 후보 생성/랭킹 문제

소셜 네트워크의 친구 추천("People You May Know", "팔로우 추천" 등)은 본질적으로 두 가지 정형 문제의 결합으로 볼 수 있다.

- **Link Prediction(링크 예측)**: 그래프 G = (V, E)에서 현재 연결되어 있지 않은 두 노드 쌍 (u, v)이 *미래에 또는 잠재적으로* 엣지를 가질 확률을 추정하는 문제. 친구 관계 그래프에서 "아직 친구가 아닌데 친구가 될 법한" 쌍을 점수화하는 것이 곧 친구 추천이다.
- **산업적 추천 패턴(Candidate Generation → Ranking)**: 수억 명 규모에서 모든 노드 쌍을 평가하는 것은 불가능하므로, 실무에서는 (1) 저렴한 휴리스틱/임베딩으로 소수의 **후보(candidate)** 를 빠르게 뽑고 (2) 무거운 ML 모델로 **랭킹(ranking)** 하는 2단계 깔때기(funnel) 구조를 쓴다. 이 2단계 패턴은 YouTube의 *Deep Neural Networks for YouTube Recommendations*(2016)에서 정식화되어 사실상 업계 표준이 되었다.

아래에서 (A) 고전 그래프 휴리스틱, (B) 임베딩 & GNN, (C) 2단계 파이프라인과 랭킹 시그널 순서로 정리한다.

> 주의: Facebook/Meta, LinkedIn 등 실제 서비스의 정확한 내부 알고리즘은 비공개이며, 공개 자료는 대부분 학술 논문·엔지니어링 블로그·관찰 기반 추정이다. 본문에서 "지배적 시그널"·"실무 관행"이라고 표현한 부분은 공개 문헌과 업계 통설에 근거한 것으로, 특정 회사의 구현을 단정하지 않는다.

---

## 2. 휴리스틱 (Graph Heuristics for Link Prediction)

가장 오래되고 가장 견고한 접근은 그래프 구조만으로 노드 쌍의 유사도 점수 s(u, v)를 계산하는 휴리스틱이다. 학습이 거의 필요 없고 해석 가능하며, 여러 벤치마크에서 GNN과 경쟁할 만큼 강력하다 (이웃 중첩(neighborhood overlap) 기반 휴리스틱은 단순하지만 매우 효과적이라는 보고가 많다).

표기: Γ(x) = 노드 x의 이웃 집합, k_x = |Γ(x)| = x의 차수(degree).

| 이름 | 직관 | 수식 |
|------|------|------|
| **Common Neighbors (공통 이웃)** | 공통 친구가 많을수록 둘이 알 가능성이 높다 | s(x,y) = \|Γ(x) ∩ Γ(y)\| |
| **Jaccard Coefficient** | 공통 이웃 수를 전체 이웃 규모로 정규화 (차수 큰 노드 편향 완화) | s(x,y) = \|Γ(x) ∩ Γ(y)\| / \|Γ(x) ∪ Γ(y)\| |
| **Adamic-Adar (AA)** | 공통 이웃이 "희귀한(차수 낮은)" 친구일수록 가중치를 더 준다 (모두와 연결된 허브는 정보가 적다) | s(x,y) = Σ_{z ∈ Γ(x)∩Γ(y)} 1 / log(k_z) |
| **Resource Allocation (RA)** | AA와 동일한 직관이나 log 없이 차수의 역수로 더 강하게 페널티 | s(x,y) = Σ_{z ∈ Γ(x)∩Γ(y)} 1 / k_z |
| **Preferential Attachment (PA)** | 차수가 큰 노드끼리 새 엣지를 더 잘 만든다 (부익부). 공통 이웃 불필요 | s(x,y) = k_x · k_y |
| **Katz Index** | 두 노드 사이 *모든 길이의 경로* 를 세되, 긴 경로일수록 지수적으로 감쇠 | s(x,y) = Σ_{l=1}^{∞} β^l · \|paths_{x,y}^{⟨l⟩}\| (β: 감쇠계수, 0<β<1) |
| **SimRank** | "비슷한 노드에 의해 참조되면 비슷하다" — 재귀적 구조적 유사도 | s(a,b) = (C / (\|I(a)\|·\|I(b)\|)) · Σ_{i∈I(a)} Σ_{j∈I(b)} s(i,j), s(a,a)=1 |

**해석 가이드**
- **Common Neighbors / Jaccard / AA / RA** 는 모두 *지역적 이웃 중첩(local neighborhood overlap)* 계열이다. 사실상 "공통 친구 수"의 변형이며, AA/RA는 흔한 허브 친구를 깎고 희귀한 공통 친구를 강조한다.
- **Preferential Attachment** 은 공통 이웃을 보지 않는 *전역 인기도* 시그널이라 결이 다르다.
- **Katz / SimRank** 는 직접 공통 이웃이 없어도 경로/구조로 연결될 수 있는 *전역 경로 기반(global)* 지표이며 계산 비용이 크다(행렬 연산/반복 수렴).

### 2.1 Friends-of-Friends(FoF) 순회와 "공통 친구 수"가 지배적인 이유

실무 후보 생성의 출발점은 거의 항상 **Friends-of-Friends(2-hop) 순회**다. 사용자 u의 친구들의 친구들을 모은 뒤, 각 후보 v가 u와 **몇 명의 공통 친구(mutual friends)** 를 갖는지 센다. 이는 위 표의 Common Neighbors와 정확히 같다.

왜 mutual-friend count가 실전에서 가장 강한 단일 시그널인가:

1. **계산 효율** — FoF는 이미 보유한 인접 리스트로 2-hop 그래프 순회만 하면 되어 수억 노드에서도 분산 처리(예: 그래프 DB, MapReduce/Pregel류)로 감당된다. 전역 휴리스틱(Katz/SimRank)이나 GNN 추론보다 훨씬 싸다.
2. **사회학적 타당성(triadic closure)** — "내 친구 둘이 서로 친구가 되는 경향(삼각 닫힘)"은 소셜 네트워크의 가장 강한 경험 법칙 중 하나다. 공통 친구가 5명이면 1명일 때보다 실제로 아는 사람일 확률이 급격히 높아진다.
3. **희소성/효율의 균형** — FoF는 후보 공간을 "이미 사회적으로 가까운" 영역으로 좁혀, 정밀도 높은 후보를 적은 비용으로 만든다.

Facebook의 "People You May Know"도 공개 추정상 mutual friends를 핵심 순위 시그널로 두고, 그 위에 같은 그룹/학교/직장, 연락처 업로드, 사진 태그, 프로필 조회·상호작용 등을 더한다고 알려져 있다(정확한 가중치는 비공개).

---

## 3. 임베딩 & GNN (Embeddings and Graph Neural Networks)

휴리스틱은 손으로 만든 고정 점수다. 임베딩/GNN은 노드를 저차원 벡터로 *학습* 해, 두 벡터의 근접도(내적/코사인)로 링크 가능성을 추정한다. 이를 통해 직접 공통 이웃이 없어도 "구조·특성이 비슷한" 노드를 잡아낼 수 있고, ANN(근사 최근접 탐색)으로 대규모 후보 생성이 가능해진다.

### 3.1 Random-walk 기반 그래프 임베딩

- **DeepWalk** (Perozzi, Al-Rfou, Skiena, KDD 2014, *Online Learning of Social Representations*): 각 노드에서 고정 길이 **무작위 보행(random walk)** 을 다수 생성해 이를 "문장"처럼 보고, NLP의 **Skip-Gram(word2vec)** 으로 노드 임베딩을 학습한다. 보행에서 자주 함께 등장하는 노드들이 임베딩 공간에서 가까워진다.
- **node2vec** (Grover, Leskovec, KDD 2016, *Scalable Feature Learning for Networks*): DeepWalk의 보행을 **편향된 2차 무작위 보행** 으로 일반화. return 파라미터 *p* 와 in-out 파라미터 *q* 로 BFS적(국소 구조/구조적 역할)과 DFS적(커뮤니티/동질성) 탐색을 조절한다.
- **LINE** (Tang 외, WWW 2015, *Large-scale Information Network Embedding*): 무작위 보행 대신 **1차 근접도(직접 연결)** 와 **2차 근접도(이웃 분포의 유사성)** 를 명시적 목적함수로 보존하도록 학습. 수백만 노드급 대형 네트워크를 겨냥했다.

참고로 *NetMF*(Qiu 외, WSDM 2018)는 DeepWalk, LINE, PTE, node2vec이 모두 **암묵적 행렬 분해(matrix factorization)** 로 통일됨을 보였다 — 즉 이들은 본질적으로 같은 수학적 골격을 공유한다.

이들 임베딩의 한계: **transductive(전이적)** 하다. 학습 시점에 존재한 노드에만 임베딩이 있어, 새로 가입한 사용자(콜드 스타트)나 끊임없이 변하는 그래프에 자연스럽게 일반화되지 않는다.

### 3.2 Graph Neural Networks (추천용)

- **GraphSAGE** (Hamilton, Ying, Leskovec, NeurIPS 2017, *Inductive Representation Learning on Large Graphs*): 이름은 **SA**mple and aggre**GAtE**. 노드의 *지역 이웃을 샘플링* 하고 **집계 함수(mean / max-pooling / LSTM)** 로 임베딩을 *계산하는 방법* 자체를 학습한다. 이웃의 특성(feature)을 쓰기 때문에 **inductive** — 학습에 없던 새 노드도 그 이웃만 보면 임베딩을 만들 수 있어 콜드 스타트와 동적 그래프에 강하다.

- **PinSage** (Ying 외, KDD 2018; Pinterest): GraphSAGE를 **웹 스케일(수십억 객체의 Pin–Board 이분 그래프)** 로 끌어올린 GCN. 핵심 기법은 (1) **랜덤워크 기반 중요도 샘플링** — 모든 이웃이 아니라 무작위 보행 방문 횟수가 높은 상위 이웃만 고정 개수로 골라 집계, (2) MapReduce/미니배치/하드 네거티브 샘플링 등 프로덕션 최적화. Pinterest는 PinSage로 학습한 Pin 임베딩을 ANN으로 조회해 후보 생성에 쓰며, 오프라인 지표·사용자 스터디·A/B 테스트 모두에서 개선을 보고했다.

### 3.3 대기업이 임베딩/GNN을 쓰는 방식 (요지)

큰 회사들은 보통 임베딩/GNN을 **후보 생성(candidate generation) 단계** 에 쓴다. 사용자/아이템(또는 사용자/사용자)을 같은 벡터 공간에 두고, 질의 벡터로 **ANN 검색**(예: HNSW류)을 돌려 수억 후보 중 수백~수천 개를 밀리초 단위로 회수한다. GraphSAGE/PinSage의 inductive 성질은 신규 사용자·신규 아이템을 즉시 임베딩할 수 있게 해 콜드 스타트 문제를 완화한다. 친구 추천 맥락에서는 친구 그래프 임베딩이 "구조적으로 가까운 사람"을 FoF 너머까지 끌어오는 보강 후보원으로 쓰인다.

---

## 4. 2단계 산업 파이프라인 (Candidate Generation → Ranking)

### 4.1 패턴 개요

YouTube의 *Deep Neural Networks for YouTube Recommendations*(Covington, Adams, Sargin, RecSys 2016)가 표준화한 깔때기 구조:

1. **Candidate Generation (회수, recall 중심)**
   - 수억(코퍼스 전체) → 수백~수천 후보로 빠르게 축소.
   - 저렴한 소스들의 합집합: **FoF/공통 친구 휴리스틱**, **임베딩 ANN 검색**, 같은 그룹·학교·직장·연락처·지역 등 규칙 기반 소스.
   - 정밀도보다 "놓치지 않기(recall)"가 목표.

2. **Ranking (정밀 순위, precision 중심)**
   - 후보 수백~수천 개에 대해 풍부한 피처를 넣은 **무거운 ML 모델**(GBDT/DNN, 종종 multi-task)로 점수화해 최종 정렬.
   - 후보가 적으므로 쌍별(pairwise) 피처 등 비싼 신호도 계산 가능.

이 분리의 이유는 **확장성과 품질의 트레이드오프**다: 모든 노드 쌍에 무거운 모델을 돌릴 수 없으니, 싼 모델로 좁히고 비싼 모델로 정밀하게 줄 세운다. (diet-setlog의 트래픽 스파이크 대응 관점에서도, 후보 생성은 캐시·사전계산(precompute)하고, 랭킹은 후보가 적을 때만 호출하는 구조가 핫 경로 비용을 낮춘다.)

### 4.2 랭킹 단계에서 흔히 쓰는 시그널 (Friend Recommendation 맥락)

랭킹 모델은 보통 다음 류의 피처를 학습된 가중치로 결합한다(가중치/정확한 셋은 회사별 비공개):

- **공통 친구 수 / 공통 이웃 구조** — 단순 카운트뿐 아니라 AA/RA처럼 공통 친구의 차수로 가중한 변형, 공통 그룹·페이지 수 등. 여전히 가장 강한 단일 피처군.
- **프로필 유사도(profile similarity)** — 같은 학교·직장·지역·나이대·관심사, 연락처 일치 여부.
- **상호작용/참여 이력(interaction history)** — 프로필 조회, 상대 게시물에 좋아요/댓글, 같은 사진 태그, 메시지 등 *친밀함의 행동 증거*.
- **최근성/활동성(recency & activity)** — 최근 가입/로그인, 활동량 — 활성 사용자가 추천을 수락할 확률이 높다.
- **프로필 완성도(profile completeness)** — 사진·정보가 채워진 계정이 더 신뢰·수락된다.
- **참여 가능성(engagement / acceptance likelihood)** — 최종 최적화 대상은 보통 "친구 요청 수락(또는 팔로우/클릭) 확률".

요약하면, **휴리스틱(공통 친구)은 후보를 만들고 1차 정렬을 주는 골격**, **임베딩/GNN은 후보를 넓히고 구조적 유사성을 더하며**, **랭킹 ML 모델은 다양한 시그널을 결합해 "이 사람을 추천하면 실제로 수락할 확률"로 최종 정렬**한다.

> **diet-setlog 적용 메모**: v1의 "친구수↓ → 활동수(글수)↓" 정렬은 위 랭킹 신호 중 (공통/연결 인기도) + (활동성)을 ML 없이 단순 규칙으로 근사한 것이다. 데이터가 쌓이면 공통 친구 수(Common Neighbors)를 1차 정렬 신호로 추가하는 것이 자연스러운 다음 단계다.

---

## 출처 (Sources)

**고전 휴리스틱 / 링크 예측**
- [Proximity-based Methods for Link Prediction — CRAN `linkprediction` vignette](https://cran.r-project.org/web/packages/linkprediction/vignettes/proxfun.html)
- [Link Prediction with NetworKit](https://networkit.github.io/dev-docs/notebooks/LinkPrediction.html)
- [Neo-GNNs: Neighborhood Overlap-aware Graph Neural Networks for Link Prediction (arXiv:2206.04216)](https://arxiv.org/pdf/2206.04216)
- [Systematic Biases in Link Prediction (arXiv:1811.12159)](https://arxiv.org/pdf/1811.12159)
- [SimRank: A Measure of Structural-Context Similarity — Jeh & Widom, KDD 2002](https://dl.acm.org/doi/10.1145/775047.775126)

**그래프 임베딩**
- [DeepWalk: Online Learning of Social Representations — KDD 2014](https://dl.acm.org/doi/10.1145/2623330.2623732)
- [node2vec: Scalable Feature Learning for Networks — KDD 2016](https://arxiv.org/abs/1607.00653)
- [LINE: Large-scale Information Network Embedding — WWW 2015](https://arxiv.org/abs/1503.03578)
- [Network Embedding as Matrix Factorization (NetMF, WSDM 2018)](https://arxiv.org/abs/1710.02971)

**GNN 추천**
- [GraphSAGE: Inductive Representation Learning on Large Graphs — NeurIPS 2017](https://cs.stanford.edu/people/jure/pubs/graphsage-nips17.pdf)
- [PinSage — KDD 2018 (Pinterest Engineering 소개글)](https://medium.com/pinterest-engineering/pinsage-a-new-graph-convolutional-neural-network-for-web-scale-recommender-systems-88795a107f48)
- [Related Pins at Pinterest (arXiv:1702.07969)](https://arxiv.org/pdf/1702.07969)

**2단계 파이프라인**
- [Deep Neural Networks for YouTube Recommendations — RecSys 2016](https://research.google/pubs/deep-neural-networks-for-youtube-recommendations/)

**Friend Recommendation 해설(내부 알고리즘은 비공개)**
- [Facebook Suggesting People You May Know — Cornell INFO 2040](https://blogs.cornell.edu/info2040/2018/10/16/facebook-suggesting-people-you-may-know/)
- [GNN Architectures for Recommendation Systems — Towards Data Science](https://towardsdatascience.com/graph-neural-network-gnn-architectures-for-recommendation-systems-7b9dd0de0856/)

> 신뢰도 메모: 수식·논문 저자/발표처는 1차 자료(논문 PDF, CRAN vignette)로 교차 확인했다. 반면 "Facebook이 공통 친구를 핵심 시그널로 쓴다" 등 *특정 서비스의 내부 동작* 은 공개 해설·업계 통설 기반 추정이며, 정확한 피처 집합과 가중치는 해당 기업이 공개하지 않았다.
