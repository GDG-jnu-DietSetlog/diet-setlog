# 03. 보안 / 라이선스(DCO·CLA) 검사

> 인덱스: [README.md](README.md) · 상위 카탈로그: [../README.md](../README.md)

머지 전에 **공급망·취약 의존성·시크릿 유출**을 막고(보안), 기여 코드의 **법적 권리**를 명확히 하는(DCO/CLA) 카테고리.
CLAUDE.md의 "시크릿 절대 커밋 금지" 원칙을 기계적으로 강제하는 부분이다.

---

## A. 보안 검사

### (1) 무엇을 검사하는가
- **CodeQL**: 소스의 취약 패턴(SQLi, XSS, 하드코딩 자격증명 등) SAST.
- **Dependabot**: 의존성의 알려진 CVE 탐지 + 자동 업데이트 PR.
- **Secret scanning / push protection**: 커밋된 API 키·토큰 탐지/차단.
- **Trivy/Grype**: 컨테이너 이미지·파일시스템·IaC 취약점 스캔.

### (2) 왜 도입했는가
공급망 공격·취약 의존성·유출된 시크릿이 **프로덕션에 들어가기 전에 차단**. CLAUDE.md의 "시크릿 절대 커밋 금지" 원칙을 자동 강제.

### (3) 어떻게 동작하는가
- CodeQL: `github/codeql-action`(`init` → `analyze`)을 `pull_request` + `schedule`로 돌려 결과를 **SARIF**로 보안 탭에 보고.
- Dependabot: `.github/dependabot.yml`로 생태계(npm, pub, github-actions)별 업데이트 주기 설정 → 자동 PR.
- Secret scanning/push protection: 저장소 설정에서 활성화(Actions 불필요), 푸시 단계에서 차단.
- Trivy: `aquasecurity/trivy-action`으로 이미지/`fs` 스캔, 심각도 임계치 초과 시 실패.

```yaml
# CodeQL (JS/TS)
- uses: github/codeql-action/init@v3
  with: { languages: javascript-typescript }
- uses: github/codeql-action/analyze@v3
```
```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: npm        # server
    directory: "/server"
    schedule: { interval: weekly }
  - package-ecosystem: pub        # Flutter app
    directory: "/app"
    schedule: { interval: weekly }
  - package-ecosystem: github-actions
    directory: "/"
    schedule: { interval: weekly }
```

### (4) 실제 사용하는 프로젝트 예시
- **Kubernetes** — Trivy/취약점 스캔과 다층 보안 게이트.
- **GitHub Advanced Security를 쓰는 다수 OSS** — CodeQL + Dependabot + secret scanning 조합.
- 대표 액션: `github/codeql-action`, `aquasecurity/trivy-action`, `dependabot`(네이티브).

> 출처: [CodeQL code scanning 문서](https://docs.github.com/code-security/code-scanning/introduction-to-code-scanning/about-code-scanning-with-codeql),
> [aquasecurity/trivy-action](https://github.com/aquasecurity/trivy-action),
> [GitHub Advanced Security 개요](https://docs.github.com/en/get-started/learning-about-github/about-github-advanced-security),
> [Dependabot 문서](https://docs.github.com/code-security/dependabot).

---

## B. 라이선스 / DCO / CLA 검사

### (1) 무엇을 검사하는가
- **DCO(Developer Certificate of Origin)**: 모든 커밋에 `Signed-off-by:` 라인이 있는지.
- **CLA(Contributor License Agreement)**: 기여자가 CLA에 서명했는지(PR 코멘트로 서명).
- (보조) 새로 추가된 파일의 **라이선스 헤더**·의존성 라이선스 호환성.

### (2) 왜 도입했는가
기여 코드의 **법적 권리(저작권/라이선스)** 를 명확히 해 프로젝트를 보호. 대기업/재단 프로젝트의 머지 전제 조건.

### (3) 어떻게 동작하는가
- DCO: GitHub 공식 **DCO App** 또는 `pull_request`에서 커밋 trailer를 검사하는 액션이 `Signed-off-by` 없으면 실패 체크 생성.
  개발자는 `git commit -s`로 서명.
- CLA: `contributor-assistant/github-action`이 `issue_comment` + `pull_request_target`을 듣고, 미서명 PR에 봇이 코멘트로 서명을 요청·기록.

```yaml
# CLA Assistant
on:
  issue_comment: { types: [created] }
  pull_request_target: { types: [opened, synchronize] }
jobs:
  cla:
    runs-on: ubuntu-latest
    steps:
      - uses: contributor-assistant/github-action@v2
        env: { GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }} }
        with:
          path-to-signatures: 'signatures/cla.json'
          path-to-document: 'https://github.com/org/repo/blob/main/CLA.md'
```

### (4) 실제 사용하는 프로젝트 예시
- **Kubernetes / CNCF 프로젝트** — DCO sign-off 필수.
- **Node.js, 다수 Linux Foundation 프로젝트** — DCO.
- **Google/Meta 계열 OSS** — CLA(예: Flutter/Angular/React는 CLA 봇 사용).
- 대표 액션/앱: `dcoapp/app`, `contributor-assistant/github-action`, `cla-assistant`.

> 출처: [dcoapp/app](https://github.com/dcoapp/app),
> [contributor-assistant/github-action](https://github.com/contributor-assistant/github-action),
> [cla-assistant.io](https://cla-assistant.io/).

> 💡 diet-setlog 관점: DCO/CLA는 **외부 기여자가 늘기 전엔 과하다**. 지금은 보안(Dependabot + secret scanning)에 집중하고
> DCO/CLA는 보류 권장([README 우선순위표](README.md#우선순위-표) 참고).
