# 연락처/소셜그래프 매칭 & 친구 추천 — 메커니즘과 프라이버시/법규 리서치

> 작성 기준: 2026-06. 기술 용어는 영문 유지. 불확실한 부분은 본문에 명시함.

## 1. 연락처/소셜그래프 매칭 메커니즘

### 1.1 기본 흐름 ("find friends from contacts")

"연락처에서 친구 찾기" 기능은 거의 모든 서비스가 동일한 골격을 따른다.

1. **연락처 읽기 권한 획득** — OS 권한(iOS `Contacts`, Android `READ_CONTACTS`)으로 기기 주소록을 읽는다.
2. **식별자 정규화(normalization)** — 전화번호를 **E.164** 국제 표준 형식(`+82101234567`)으로 변환한다. E.164는 ITU가 정의한 국제 표준으로 국가코드 포함 **최대 15자리**다. 정규화가 핵심인 이유: `010-1234-5678`, `01012345678`, `+82 10 1234 5678`이 모두 같은 사람을 가리켜야 매칭이 성립하기 때문. 이메일은 소문자화/trim 등으로 정규화한다.
3. **해싱(hashing)** — 정규화된 식별자를 서버로 그대로 올리지 않고 **암호학적 해시**(예: SHA-256)로 변환해 업로드하는 것이 일반적이다. 평문 번호를 저장하지 않기 위함.
4. **서버 측 매칭** — 서버는 (이미 가입자들의 식별자 해시를 보관) 업로드된 해시 집합과 **교집합(set intersection)**을 구해, 양쪽 모두 매칭 가능한 식별자를 가진 사용자를 친구 후보로 반환한다.

실제 사례:
- **Discord** — "Find Your Friends" 활성화 시 기기의 전화번호를 주기적으로 서버에 동기화해 매칭한다.
- **Tinder** — 누군가 당신의 번호를 업로드하면 그 번호는 "읽을 수 없고 되돌릴 수 없는(irreversible)" 암호 해시로 변환된다고 설명한다.

### 1.2 왜 양쪽 모두 "매칭 가능한 식별자(phone/email)"가 필요한가

매칭은 **공통 식별자의 교집합**이다. A의 주소록에 B의 번호가 있고, B도 그 번호로 가입(검증)되어 있어야 "A와 B가 서로 아는 사이"라는 엣지가 생긴다. 따라서:
- **내 쪽**: 상대방의 식별자(주소록의 번호/이메일)를 가지고 있어야 한다.
- **상대 쪽**: 같은 식별자로 가입/검증되어 서버 인덱스에 등록돼 있어야 한다.

한쪽만 식별자를 가지고 있으면 매칭이 성립하지 않는다(단방향). 그래서 이런 기능은 보통 **전화번호 가입/검증을 전제**로 설계된다.

> **diet-setlog 적용 메모**: 우리 v1은 카카오 로그인 기반이라 "우리 DB의 사용자에 매칭키(전화번호)가 없을 수" 있다. 즉 연락처 매칭을 도입하려면 별도의 전화번호 수집/검증이 전제다. 그래서 v1 추천은 카카오 친구목록(카카오가 매칭키 역할)으로 가는 것이 합리적이다.

### 1.3 해싱의 한계 — "해시했으니 안전하다"는 착각 (중요)

단순 해시는 프라이버시 보호 수단으로 **취약**하다. 전화번호의 정보 엔트로피가 낮기 때문이다.

- 전 세계 휴대폰 번호 공간은 한정적이라, GPU로 **전체 번호 공간을 수십~150초 내**에 무차별 해시 역산할 수 있다(IACR 2022/875, encrypto.de 논문).
- 비균일 입력(전화번호)에 특화된 **rainbow table**로 대량 해시 역산이 commodity hardware로 실용화됨.
- **열거 공격(enumeration)**: friend-finder에 특정 국가의 전화번호를 전수 입력해 (번호↔온라인 신원) 매핑을 대량으로 만드는 브루트포스 사례가 보도됨.

**완화책**:
- bcrypt/Argon2 등 **계산 비용이 큰 해시**로 해시당 시간을 늘림(완전한 해결은 아님).
- **레이트 리밋 / 업로드 가능한 연락처 수 제한**으로 enumeration 방어.
- **Signal식 Private Contact Discovery**: 암호화된 식별자를 **SGX secure enclave** 안에서만 매칭하고 결과를 암호화해 돌려줌 — 서버 운영자조차 평문을 못 보게 설계.

> 시사점: 단순 SHA-256 해시 업로드는 "평문 저장보다는 낫다" 수준이지, 강한 프라이버시 보장이 아니다. 설계 시 enumeration/역산 위협을 전제로 해야 한다.

---

## 2. "내 전화번호 자동 취득" 가능성 (iOS / Android 사실관계)

### 2.1 iOS — 공개 API 없음 (취득 불가)

- Apple은 프라이버시 정책상 앱이 **기기 자신의 전화번호에 접근하는 것을 차단**한다. 사용자에게 권한을 물어보더라도 가져올 수 없다.
- 과거 private API로 우회는 가능했으나 **App Store 심사에서 리젝**된다.
- `CTTelephonyNetworkInfo`(CoreTelephony)는 캐리어/네트워크 정보용이며, **자기 번호를 노출하는 public 메서드가 없다**.
- 결론: iOS에서는 **사용자가 직접 번호를 입력**하거나 SMS OTP 검증으로 받는 방식이 사실상 유일하다.

### 2.2 Android — `getLine1Number()`는 신뢰 불가 + 권한 필요

- `TelephonyManager.getLine1Number()`는 line 1 번호(GSM의 MSISDN)를 반환하지만, **많은 기기/통신사에서 빈 문자열 또는 null**을 반환한다. 값이 있어도 유효하지 않을 수 있다(잘 알려진 문제).
- **권한**: `READ_PHONE_NUMBERS` 또는 `READ_PHONE_STATE`(target SDK에 따라 다름)가 필요.
- 이 메서드는 **deprecated**. Google은 `SubscriptionManager.getPhoneNumber(int)` 사용을 권장하지만, 이 역시 통신사가 SIM에 번호를 기록하지 않으면 빈 값일 수 있어 **근본적으로 신뢰 불가**.

### 2.3 Android — Phone Number Hint API (권장)

- **Google Identity Services**의 Phone Number Hint API는 **런타임 권한 없이** 기기의 전화번호를 가져오는 보안 흐름을 제공한다.
- 동작: `GetPhoneNumberHintIntentRequest` 생성 → `SignInClient.getPhoneNumberHintIntent()`로 `PendingIntent` 획득 → activity result launcher로 실행 → `getPhoneNumberFromIntent`로 번호 추출.
- 의존성: `com.google.android.gms:play-services-auth`(Google Play services 필요).
- 핵심: **사용자가 UI에서 자기 번호를 선택**하는 방식이라 권한 없이도 동작하고, 자동 취득이 아니라 **사용자 동의 기반 1탭 선택**에 가깝다. 따라서 "몰래 자동 취득"은 불가하고, UX상 입력 마찰만 줄여주는 도구다.

> 정리: **자동·무동의로 내 번호를 읽는 건 양 플랫폼 모두 사실상 불가**. iOS는 직접 입력 + OTP, Android는 Phone Number Hint(사용자 선택) + OTP가 현실적인 정답.

---

## 3. Provider 친구 API 요약 + 제약

### 3.1 Facebook Graph API — friends (2014 이후 강력 제약)

- **2014년 4월 Graph API v2.0**부터 친구 목록 접근이 대폭 제한됨. `user_friends` scope가 있어도, 반환되는 친구는 **"같은 앱을 이미 사용 중인(앱에 로그인하고 권한을 부여한) 친구"로 한정**된다. 즉 전체 친구 그래프 부트스트랩 용도로는 못 쓴다.
- `taggable_friends` / `invitable_friends`(승인된 게임 한정) 같은 우회 엣지가 있었으나, **`taggable_friends`는 2018-04-04 deprecate되어 빈 데이터 반환**.
- 사실상 오늘날 Facebook을 통한 "친구 자동 임포트"는 **신규 소셜 그래프 구축 수단으로 부적합**.

### 3.2 Google People API — contacts

- 사용자 연락처는 People API(`people.connections.list` 등)로 접근.
- **OAuth scope**: `https://www.googleapis.com/auth/contacts.readonly`(또는 `contacts`). 이는 **민감(sensitive)~제한(restricted)** 범주로, Google **OAuth 검증**이 필요.
- 제한/민감 scope를 요청하면 **CASA(Cloud Application Security Assessment) 보안 평가**(Tier 2/3)를 통과해야 프로덕션에서 일반 사용자에게 scope를 요청할 수 있다. (정확한 등급은 사용 패턴/데이터 범위에 따라 다름 — 본인 앱 케이스로 Google 분류 확인 필요.)
- 즉, 출시 전 **앱 검증 + 보안 평가**라는 게이트가 있다.

### 3.3 Kakao 친구 목록 API (카카오톡 친구)

- **카카오싱크/카카오톡 소셜 API**의 친구 목록 조회는 **친구 scope 동의** + **비즈앱(Business App) 전환** + **친구 API 사용 신청(검수)**를 거쳐야 한다.
- 신청 경로: `내 애플리케이션 > 앱 설정 > 비즈니스 > 비즈앱 정보 > 사업자 등록`. 출시/배포 전에 검수 신청 권장.
- **반환 범위 제약**: 응답에는 앱 연결 시 **"카카오 서비스 내 친구 목록 제공" 동의항목에 동의한 친구만** 포함된다. (Facebook과 유사하게, 동의·연결된 친구만 보이는 구조)
- **캐싱**: 친구 목록 조회 응답은 **약 10분 캐시**됨 — 같은 호출을 10분 내 반복하면 변경이 있어도 동일 결과.
- 용도: "앱/웹 회원 간 소셜 활동(메시지, 피커 등)" 지원이 목적이며, 무분별한 그래프 수집용이 아님.

> 공통 패턴: 세 provider 모두 **"이미 동의/가입한 친구만"** 노출하도록 좁혀져 있어, 콜드스타트 소셜 그래프를 통째로 가져오는 용도로는 제한적이다. → diet-setlog의 "0명 추천이 빈 화면이 될 수 있으니 seed 폴백 필요" 결정의 근거.

---

## 4. 프라이버시 / 법규

### 4.1 대표 논란 사례

- **Facebook PYMK — shadow contacts**: 사용자가 주소록을 공유하면 Facebook은 그 데이터로 "아무리 약한 연결이라도" 사람들 사이의 관계를 찾고, 사용자는 그 과정을 볼 수 없다. 이렇게 본인이 직접 공유하지 않은 정보로 만들어진 프로필을 **shadow profile**이라 부른다.
  - **정신과 의사 사례**(Gizmodo, 2017): 한 환자가 PYMK에 자기 다른 환자로 보이는 낯선 사람들이 추천된다고 호소. **민감한(의료) 관계가 의도치 않게 노출**되는 위험을 단적으로 보여줌.
  - PYMK는 알고리즘이 불투명하고 사용자가 **끌 수 없는** 점이 지속적으로 비판받음.
- **Facebook 이메일 연락처 무단 업로드(2019)**: 약 **150만 명의 이메일 연락처를 동의 없이 "비의도적으로" 업로드**한 사실이 드러남.
- **FTC consent decree 위반 → 50억 달러 벌금(2019)**: 위 사건들을 포함한 데이터 처리 위반으로 FTC 역사상 최대 민사 벌금 부과.

### 4.2 GDPR — 연락처 업로드와 동의

- 개인정보 처리는 원칙적으로 **Art. 6 적법근거** 중 하나(동의, 계약, 법적의무, 정당한 이익 등)가 필요.
- **동의**는 자유롭게 주어지고(freely given), 구체적·정보에 입각하며, 명백(unambiguous)해야 함.
- **핵심 쟁점 — 비가입자(non-user)의 데이터**: 내 주소록에는 그 앱을 쓰지 않는 제3자의 번호/이메일이 들어있다. 이들은 **본인이 직접 제공하지 않은(indirect collection)** 데이터이므로 **Art. 14 고지 의무**가 발생하고, 이 경우 동의를 적법근거로 쓰기 어려워 보통 **legitimate interest** + **Legitimate Interest Assessment(LIA)** 문서화에 의존한다. 그조차도 비가입자 권리(접근/삭제)와 충돌 소지가 크다.

### 4.3 한국 PIPA (개인정보보호법) 고려사항

- **제3자 제공/수집 동의**: 수집 목적 외로 제3자에게 제공하거나, 연락처 등 개인정보를 수집할 때는 **정보주체의 동의**가 원칙. 수집·이용 시 **처리 목적, 보유·이용 기간, 제3자 제공에 관한 사항**을 개인정보 처리방침에 포함·공개해야 함.
- **거부권 보장**: 정보주체가 (필수가 아닌) 제3자 제공에 동의하지 않는다고 해서 **재화·서비스 제공을 거부할 수 없음**(부당한 동의 강요 금지) — 친구찾기를 "필수 동의"로 묶는 설계는 위험.
- **연락처 명시**: 고객의 전화번호·이메일 등 연락처를 플랫폼에 올려 처리하는 경우 그 사실을 **명시**해야 함.
- **비가입 제3자 문제**: 주소록 속 비가입자의 번호를 서버에 올리는 것은 그 제3자에 대한 별도의 적법근거/고지 이슈를 야기 — 국내에서도 GDPR과 유사한 민감 지점. (정확한 적용은 처리 형태에 따라 PIPC 가이드/법률 자문 확인 필요.)

### 4.4 Best Practice (권장 설계)

1. **명시적·분리된 동의(explicit, granular consent)** — "친구 찾기"를 별도 옵트인으로. 필수 가입 조건과 묶지 않기(PIPA 거부권 보장과도 연결).
2. **평문 미저장(no raw contacts)** — 매칭 후 **원본 연락처는 저장하지 않음**. 매칭에 쓴 식별자도 보관 최소화.
3. **강한 해싱 + enumeration 방어** — bcrypt/Argon2, 업로드 수 제한, 레이트 리밋. 가능하면 Signal식 enclave/PSI(private set intersection) 검토.
4. **비가입자 데이터 최소화** — 매칭 안 된 비가입자 식별자는 즉시 폐기, 비가입자 대상 "shadow graph" 축적 금지.
5. **삭제/철회(deletion & revocation)** — 동의 철회 시 업로드된 식별자·도출된 추천 엣지 삭제 경로 제공.
6. **투명성** — 무엇을, 왜, 어디로 업로드하는지 고지. PYMK식 불투명 추천 지양, 추천 끄기 옵션 제공.
7. **제3자 노출 방지** — 민감한 관계(의료·법률 등)가 추천으로 역추론되지 않도록, 단일 공통 연락처만으로 강한 추천을 만들지 않는 등 안전장치.

---

## 출처(Sources)

**메커니즘 / 해싱**
- [What is E.164? — Twilio](https://www.twilio.com/docs/glossary/what-e164)
- [Find Your Friends FAQ — Discord](https://support.discord.com/hc/en-us/articles/360061878534-Find-Your-Friends-FAQ)
- [Friends in Common — Tinder Help](https://www.help.tinder.com/hc/en-us/articles/7511247800333-Friends-in-Common)
- [Contact Discovery in Mobile Messengers: Low-cost Attacks (IACR ePrint 2022/875, PDF)](https://eprint.iacr.org/2022/875.pdf)
- [Breaking & Fixing Mobile (Private) Contact Discovery](https://contact-discovery.github.io/)
- [Technology preview: Private contact discovery for Signal (SGX enclave)](https://signal.org/blog/private-contact-discovery/)

**내 전화번호 취득 (iOS/Android)**
- [Apple Developer Forums — get phone number from SIM (no public API)](https://developer.apple.com/forums/thread/9171)
- [TelephonyManager.Line1Number — Microsoft Learn (deprecated, requires READ_PHONE_NUMBERS/READ_PHONE_STATE)](https://learn.microsoft.com/en-us/dotnet/api/android.telephony.telephonymanager.line1number?view=net-android-35.0)
- [Phone Number Hint — Android Developers (official)](https://developer.android.com/identity/phone-number-hint)
- [GetPhoneNumberHintIntentRequest — Google Play services reference](https://developers.google.com/android/reference/com/google/android/gms/auth/api/identity/GetPhoneNumberHintIntentRequest)

**Provider 친구 API**
- [user/taggable_friends — Meta Graph API reference (v2.0)](https://developers.facebook.com/docs/graph-api/reference/v2.0/user/taggable_friends)
- [OAuth 2.0 Scopes for Google APIs — Google for Developers](https://developers.google.com/identity/protocols/oauth2/scopes)
- [Restricted scope verification — Google for Developers](https://developers.google.com/identity/protocols/oauth2/production-readiness/restricted-scope-verification)
- [카카오톡 소셜 — 이해하기 (Kakao Developers 문서)](https://developers.kakao.com/docs/latest/ko/kakaotalk-social/common)
- [친구 API와 피커, 메시지 API 사용을 위한 체크리스트 — 카카오 데브톡 FAQ](https://devtalk.kakao.com/t/api-api/116052)

**프라이버시 / 법규**
- [How Facebook Figures Out Everyone You've Ever Met — Gizmodo (psychiatrist case, shadow contacts)](https://gizmodo.com/how-facebook-figures-out-everyone-youve-ever-met-1819822691)
- [Facebook, Inc., In the Matter of — FTC (consent decree / $5B penalty)](https://www.ftc.gov/legal-library/browse/cases-proceedings/092-3184-182-3109-c-4365-facebook-inc-matter)
- [Art. 13 GDPR — Information to be provided (gdpr-info.eu)](https://gdpr-info.eu/art-13-gdpr/)
- [What are the GDPR consent requirements? — GDPR.eu](https://gdpr.eu/gdpr-consent-requirements/)
- [개인정보의 수집·이용 — 찾기 쉬운 생활법령정보(easylaw.go.kr)](https://www.easylaw.go.kr/CSP/CnpClsMainBtr.laf?csmSeq=1257&ccfNo=2&cciNo=1&cnpClsNo=1)
- [개인정보보호위원회(PIPC) 법령·안내서](https://www.pipc.go.kr/np/cop/bbs/selectBoardList.do?bbsId=BS217&mCode=D010030000)

> **불확실성 명시**: (1) `contacts.readonly`의 Google 분류(sensitive vs restricted)와 요구 CASA Tier는 앱의 구체적 사용 패턴에 따라 달라지므로 본인 앱 기준 Google 콘솔/검증 통지 확인 필요. (2) Kakao 친구 API 캐시 시간·동의항목 명칭 등 세부는 카카오 정책 변경 가능성 있어 최신 공식 문서 재확인 권장. (3) 한국 PIPA의 비가입 제3자 연락처 업로드에 대한 정확한 적용은 처리 형태별로 달라 PIPC 가이드/법률 자문이 필요하다.
