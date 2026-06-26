# Research — 조사 문서 모음

diet-setlog 개발 중 수행한 **조사(research)** 들을 주제별로 모아둔 디렉터리.
각 조사는 **자기 폴더 하나**를 가지며, 폴더 안에 `README.md`(그 조사의 인덱스/요약) + 세부 문서들을 둔다.

## 조사 목록

| 조사 | 폴더 | 한 줄 요약 | 상태 |
|------|------|-----------|------|
| GitHub Actions CI 검사 | [`github-actions-ci/`](github-actions-ci/README.md) | 유명 OSS의 CI 검사 패턴(컨벤션·lint·빌드·커버리지·보안·라벨·모노레포·릴리스)과 diet-setlog 도입안 | ✅ 1차 완료 (2026-06) |

> 새 조사가 생기면 위 표에 한 줄 추가한다.

## 폴더 구조 규칙

```
docs/research/
├── README.md                      # ← 이 파일(조사 카탈로그)
└── <조사-주제-kebab-case>/         # 조사 1개 = 폴더 1개
    ├── README.md                  # 그 조사의 인덱스/요약/시사점
    ├── 01-<소주제>.md
    ├── 02-<소주제>.md
    └── ...
```

규칙:
- **폴더명**: 조사 주제를 kebab-case로 (예: `friend-recommendation`, `image-analysis-gemini`).
- **폴더 README.md**: 그 조사의 TL;DR + 소문서 목록 + diet-setlog 설계와의 연결(시사점)을 담는다.
- **세부 문서**: `01-`, `02-` … 숫자 프리픽스로 읽는 순서를 고정.
- **출처 명시**: 조사 문서는 공식 문서/논문/엔지니어링 블로그 출처를 달고, 추정·불확실한 부분은 본문에 표시한다.
- 설계 문서([../api-db-design.md](../api-db-design.md))는 research가 아니라 `docs/` 직속에 둔다 — research는 "조사·근거", `docs/`는 "결정·설계".
