# 친구 추천(PYMK) 리서치 — 인덱스

> 주제: **해외/글로벌 서비스는 친구 추천(People You May Know, PYMK)을 어떻게 구현하는가**, 그리고 그것이
> diet-setlog의 친구 추천 설계([../../plans/api-db-design.md](../../plans/api-db-design.md))에 주는 시사점.
> 상위 조사 카탈로그: [../README.md](../README.md)
> 작성 기준: 2026-06. 각 문서는 공식 문서·엔지니어링 블로그·논문을 직접 조사해 출처를 달았다.
> ⚠️ 주의: 각 사의 **정확한 내부 알고리즘/가중치는 비공개**다. 문서의 일부 서술은 공개 자료 기반 추정이며, 해당 부분은 본문에 명시했다.

## 문서 목록 (읽는 순서 권장)

| # | 문서 | 한 줄 요약 |
|---|------|-----------|
| 01 | [글로벌 서비스 PYMK 비교](01-global-services-pymk.md) | Facebook·LinkedIn·Instagram·X·TikTok·Snapchat이 쓰는 신호와 접근 비교 |
| 02 | [알고리즘 & 시그널](02-algorithms-and-signals.md) | 링크 예측 휴리스틱(공통이웃·Adamic-Adar 등), 임베딩/GNN, candidate→ranking 2단계 |
| 03 | [콜드스타트 (친구 0명)](03-cold-start.md) | 그래프가 빈 신규 유저 추천: 연락처·소셜로그인·인기·위치·온보딩 |
| 04 | [연락처 매칭 & 프라이버시/법규](04-contacts-matching-and-privacy.md) | 해시 매칭 메커니즘, 내 번호 자동취득 가능성, 카카오/구글/FB 친구 API, GDPR·PIPA |
| 05 | [아키텍처 & 스케일](05-architecture-and-scale.md) | 대규모 offline batch + online ranking, 그래프 저장(TAO/LIquid), FoF 비용, 소규모 앱 단계별 가이드 |

## 가로지르는 핵심 결론 (TL;DR)

1. **공통 1순위 신호는 "friends-of-friends / 공통 친구 수(mutual friends, triangle closing)"** 다. 거의 모든 서비스가 이걸 핵심으로 쓴다. → 우리 설계의 "친구 1명+ → 친구의 친구" 분기와 일치.
2. **콜드스타트(친구 0명)는 그래프 밖 신호로 첫 엣지를 만든다.** 가장 강력한 건 **연락처/소셜 로그인 친구 임포트**, 폴백은 인기·활동·위치·관심사 온보딩. → 우리 설계의 "친구 0명 → 카카오 친구" 분기와 일치.
3. **연락처 매칭은 양쪽 모두 매칭키(전화번호/이메일)가 있어야** 동작하고, **단순 해시는 프라이버시 보호로 약하다**(전화번호는 enumeration/역산이 쉬움). 명시적 동의·평문 미저장·레이트리밋·삭제 경로가 필수.
4. **내 전화번호를 동의 없이 자동 취득하는 방법은 사실상 없다** (iOS 불가, Android `getLine1Number` 신뢰불가). 친구 매칭은 "읽기"가 아니라 "검증"이 본질.
5. **구조는 거의 항상 2단계: candidate generation(싸게 후보 추림) → ranking(비싸게 정밀 정렬).** 대규모는 후보를 **precompute해 KV(Redis류)에 저장**하고 서빙 시 조회만 한다.
6. **friends-of-friends는 k² fan-out 폭발 위험**이 있다(슈퍼노드/멱법칙). 완화: degree cap, top-N, 캐시, precompute, random walk 근사.
7. **소규모 앱(단일 Postgres+Redis)은 대규모 인프라가 필요 없다.** on-demand self-join + `LIMIT` → Redis TTL 캐시 + denormalized counter → (필요해지면) 배치 precompute 순으로 단계적 진화.

## diet-setlog 설계와의 연결

현재 우리 설계([../../plans/api-db-design.md](../../plans/api-db-design.md) §4.6, §1.5)는 다음과 같고, 리서치가 이를 뒷받침한다:

- **친구 0명 → 카카오톡 친구 기반 / 친구 1명+ → 친구의 친구 기반**: 업계 표준 패턴(콜드스타트 외부소스 → 그래프 전환)과 정확히 일치(문서 03).
- **정렬: 친구수↓ → 활동수(글수)↓**: "공통 친구 수 + 활동/인기" 랭킹 신호의 단순화 버전(문서 01·02). v1에 ML은 불필요.
- **카카오 친구목록은 비즈앱 검수 + 친구 scope 동의 필요, "동의한 친구만" 반환**: 문서 04에서 확인된 제약 → 콜드스타트가 빈 화면이 될 수 있으니 seed 폴백 필요.
- **denormalized `friendCount`/`postCount` + cursor 무한스크롤**: 소규모 앱 권장 패턴(문서 05 단계 1~2)과 일치. 핫 경로에서 self-join 반복 대신 카운터/캐시.
- **프라이버시**: 카카오 기반이라 연락처 업로드는 당장 안 하지만, 추후 도입 시 문서 04의 best practice(명시 동의·평문 미저장·삭제)를 전제로.

### 향후 검토거리 (리서치가 시사하는 것)
- 카카오 친구목록 미연동/미동의 구간의 **seed·인기·활동 기반 폴백** 구체화(문서 03).
- friends-of-friends 쿼리의 **슈퍼노드 fan-out 가드**(degree cap / `statement_timeout` / top-N)(문서 05).
- 추천 결과 **Redis TTL 캐시** + 친구 추가/삭제 시 무효화(문서 05).
- 사용자 규모가 커지면 **배치 precompute로 이행하는 트리거** 기준 정하기(문서 05 단계 3).
