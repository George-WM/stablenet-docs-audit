# StableNet 문서 콘텐츠 로드맵

**생성일:** 2026-04-09
**목표:** 가중 총점 1.46 → 3.0+ (9위 → 4~5위 목표)
**총 예상 공수:** ~202시간 (문서 작업) + 외부 감사 예산

---

## 요약 타임라인

| 기간 | 단계 | 핵심 목표 | 예상 공수 |
|---|---|---|---|
| Week 1–2 | P1 Quick Wins | 테스트넷 접근 차단 해제, Changelog 시작, API 플레이그라운드 | ~12h |
| Week 3–4 | P1 핵심 개발자 콘텐츠 | Foundry 퀵스타트, EVM 호환성 레퍼런스 | ~24h |
| Week 5–8 | P2 깊이 & 기관 대응 | 준비금 투명성, KRW Hub, 수수료 위임 가이드, Hardhat | ~100h |
| Week 9–12 | P3 전략 & 폴리시 | 보안감사 *(별도 프로젝트)*, 한국어, 상태 페이지, 크로스체인 | ~66h+ |

---

## Week 1–2: P1 Quick Wins (총 ~12시간)

> **목표:** 코드 변경 없이 즉시 개발자 진입 차단 요소 제거 + 문서 신선도 신호 발송

---

### P1.1 — 테스트넷 네트워크 상세 페이지 신설

| 항목 | 내용 |
|---|---|
| **생성 페이지** | `/en/getting-started/testnet-network-details` |
| **콘텐츠** | 아래 5개 항목을 한 표에: Network Name (StableNet Testnet) / Chain ID (8283) / RPC URL (공개 엔드포인트) / Block Explorer URL / Faucet URL + MetaMask 추가 단계 (텍스트, 스크린샷 선택) |
| **벤치마크** | Circle Arc `Connect to Arc` 페이지 — RPC URL · Chain ID · Explorer · Faucet · MetaMask 5개 항목 단일 표 |
| **예상 공수** | **2h** |
| **의존성** | 엔지니어링팀이 공개 RPC URL 확인/제공 |
| **효과** | `testnet_accessibility` 2→4점. 모든 EVM 개발자의 진입 차단 즉시 해제 |

---

### P1.2 — Changelog 페이지 신설 + 기존 섹션 날짜 표기

| 항목 | 내용 |
|---|---|
| **생성 페이지** | `/en/changelog` (최상단 네비게이션 항목) |
| **콘텐츠** | 소급 항목 기재 (예: "2026-Q1: 거버넌스·수수료 위임·합의 문서 초기 공개") + 향후 파괴적 변경 30일 사전 고지 정책 선언. 기존 섹션 인덱스 페이지에 "최종 업데이트: YYYY-MM" 한 줄 추가 |
| **벤치마크** | Paxos Changelog (2023~2026 월별) + 90일 사전 고지 정책 |
| **예상 공수** | **3h** |
| **의존성** | 없음 |
| **효과** | `freshness` 0→2점 즉시. 정적 문서에서 관리되는 문서로 인식 전환 |

---

### P1.3 — Mintlify API 플레이그라운드 활성화

| 항목 | 내용 |
|---|---|
| **수정 파일** | `mint.json` (Mintlify 설정) |
| **콘텐츠** | Mintlify는 OpenAPI 스펙에서 대화형 API 플레이그라운드를 자동 생성. 기존 `/api-reference/openapi.json` 활용. `mint.json`에 `openapi` 설정 항목 추가만으로 완료 |
| **벤치마크** | M0 대화형 API 플레이그라운드, Circle Arc "Try it" 버튼 |
| **예상 공수** | **2h** |
| **의존성** | Mintlify 계정 설정 확인 |
| **효과** | `sdk_api_quality` 1→2점, `interactive_elements` 2→3점 |

---

### P1.4 — Faucet · Explorer 링크 온보딩 전체 삽입

| 항목 | 내용 |
|---|---|
| **수정 페이지** | `/en/getting-started/index` + P1.1 네트워크 상세 페이지 + RPC 섹션 |
| **콘텐츠** | faucet.stablenet.network, explorer.stablenet.network 직결 링크 + 한 줄 설명. 홈 카드 그리드에 "Faucet" · "Explorer" 카드 추가 |
| **벤치마크** | Circle Arc 네비게이션 바 상단 Explorer/Faucet 고정 |
| **예상 공수** | **1h** |
| **의존성** | P1.1 완료 후 |
| **효과** | `testnet_accessibility` 추가 기여. 개발자가 docs에서 faucet까지 클릭 1회로 도달 |

---

## Week 3–4: P1 핵심 개발자 콘텐츠 (총 ~24시간)

> **목표:** 개발자가 StableNet에서 첫 컨트랙트를 배포할 수 있게 만드는 핵심 두 페이지

---

### P1.5 — 개발자 퀵스타트: "첫 WKRC 결제 컨트랙트 배포"

| 항목 | 내용 |
|---|---|
| **생성 페이지** | `/en/getting-started/quickstart` |
| **콘텐츠** | Foundry 기반 10~12단계 튜토리얼: |
| | Step 1: Foundry 설치 (`foundryup`) |
| | Step 2: 프로젝트 스캐폴드 (`forge init stablenet-demo`) |
| | Step 3: `foundry.toml`에 StableNet testnet RPC 설정 (P1.1 참조) |
| | Step 4: `WKRCDemo.sol` 작성 — WKRC 수신, 결제 기록 저장, 이벤트 발생 |
| | Step 5: `WKRCDemoTest.sol` 작성 (forge-std 사용) |
| | Step 6: 테스트 실행 (`forge test`) |
| | Step 7: 지갑 생성 (`cast wallet new`) |
| | Step 8: Faucet에서 WKRC 충전 |
| | Step 9: 배포 (`forge create --rpc-url $STABLENET_RPC_URL`) |
| | Step 10: Explorer에서 검증 |
| | Step 11: WKRC 전송 + 이벤트 확인 (`cast send` / `cast call`) |
| | ※ 각 단계 후 예상 터미널 출력 포함. Solidity 코드 전체 인라인 |
| **벤치마크** | Circle Arc `Deploy on Arc` — 구조 그대로 차용 |
| **예상 공수** | **16h** (Solidity 코드 개발 + 터미널 출력 캡처 + 엔지니어링 검토) |
| **의존성** | P1.1 (공개 RPC URL), P1.4 (Faucet 링크), 엔지니어링 — 컨트랙트 테스트넷 동작 확인 |
| **효과** | `time_to_first_tx` 1→4점. `evm_tooling_support` 1→2점. **단일 페이지 최대 임팩트** |

---

### P1.6 — EVM 호환성 레퍼런스 페이지

| 항목 | 내용 |
|---|---|
| **생성 페이지** | `/en/development-tools/evm-compatibility` |
| **콘텐츠** | (1) JSON-RPC 메서드 지원 테이블 (`eth_*` 전체 ✅/❌ + 대안 설명) (2) Ethereum 메인넷 대비 차이점 표: 네이티브 토큰(WKRC vs ETH) / 수수료 모델(거버넌스 제어 vs EIP-1559) / 합의(Istanbul BFT vs PoS) / 수수료 위임 TX 타입 0x16 (StableNet 전용) / Chain ID (8283 vs 1) |
| **벤치마크** | Stable.xyz JSON-RPC 메서드 테이블 + Circle Arc EVM Differences 비교 표 |
| **예상 공수** | **8h** (엔지니어링 입력 필요 — 메서드 지원 여부 확인) |
| **의존성** | 엔지니어링팀 RPC 메서드 지원 목록 제공 |
| **효과** | `evm_tooling_support` 1→3점. 개발자 신뢰도 즉시 향상 |

---

## Week 5–8: P2 깊이 & 기관 대응 (총 ~100시간) ✅ 완료 (2026-04-21)

> **목표:** 기관 due diligence 통과 가능한 스테이블코인 문서 + KRW 포지셔닝 선점

---

### P2.1 — WKRC 준비금 투명성 페이지

| 항목 | 내용 |
|---|---|
| **생성 페이지** | `/en/stablecoin/wkrc-reserve-transparency` |
| **콘텐츠** | (1) 법정화폐 담보 구조 설명 (2) 4단계 민트 프루프 요약 + 다이어그램 (기존 5.6 문서 활용) (3) 소각 에스크로 프로세스 (4) 승인 보관기관 명시 (법무 검토 범위 내) (5) 증명 일정 선언 (분기 자체보고라도) (6) 최초 준비금 보고서 링크 (게시 시) |
| **벤치마크** | Tether 일별 투명성 페이지 구조, Paxos 스테이블코인별 투명성 페이지 형식 |
| **예상 공수** | **20h** (법무/비즈니스 입력 + 검토 포함) |
| **의존성** | 법무팀 — 보관기관 명시 범위, 준비금 공개 내용 승인 |
| **효과** | `reserve_transparency` 1→3점. 기관 구매자 due diligence 핵심 요건 |

---

### P2.2 — KRW Hub 섹션 신설

| 항목 | 내용 |
|---|---|
| **생성 페이지** | `/en/krw-hub/` (3~4 하위 페이지) |
| **하위 페이지** | `/en/krw-hub/overview` — "왜 StableNet에서 KRW 개발?" (WKRC 네이티브 가스 = FX 비용 없음, 수수료 위임 한국 결제 UX, KRW 네이티브 결제) |
| | `/en/krw-hub/token-reference` — WKRC 컨트랙트 주소, 소수점, 표준 인터페이스, 전송 코드 예제 |
| | `/en/krw-hub/onramp-offramp` — KRW 온/오프램프 파트너, 법정화폐 레일, 뱅킹 통합 (현황 또는 계획) |
| | `/en/krw-hub/regulatory-context` — 한국 FSC/VASP 프레임워크 맥락 (법무 검토 후) |
| **벤치마크** | Maroo KRW 포지셔닝 내러티브(차용) + Paxos 스테이블코인별 구조(형식 차용) |
| **예상 공수** | **32h** (리서치 + 법무/비즈니스 입력 + 규제 맥락 검토) |
| **의존성** | 비즈니스/법무 — 온/오프램프 파트너 현황, 규제 맥락 승인 |
| **효과** | `krw_specific` 2→4점. StableNet 유일 경쟁 모트의 문서화. Maroo 대비 우위 확보 |

---

### P2.3 — 컴플라이언스 아키텍처 문서

| 항목 | 내용 |
|---|---|
| **생성 페이지** | `/en/compliance/overview` + 하위 페이지 |
| **콘텐츠** | 이중 트랙 모델: (1) "오픈 경로" — KYC 없이 WKRC 보유·수신·전송 가능 (2) "규제 경로" — 민트/소각은 승인 민터 KYC + 법정화폐 예치 증명 + 거버넌스 정족수 필요 (3) 준수 제어 항목 명명: MintQuorum / BurnEscrow / ValidatorKYB / ReplayProtection / FeeGovernance (4) 거버넌스 컨트랙트가 온체인 컴플라이언스를 강제하는 방식 (5) FSC/VASP 맥락 (법무 검토 후) |
| **벤치마크** | Maroo 이중 트랙 아키텍처(내러티브) + Tokeny 컴플라이언스 모듈 디렉토리(형식) |
| **예상 공수** | **24h** (법무 검토 포함) |
| **의존성** | 법무 — 규제 진술 내용 승인 |
| **효과** | `compliance_docs` 0→3점. 기관 신뢰도 핵심 전환점 |
| **⚠️ 주의** | 규제 미확정 항목은 "계획 중" 표시로 처리. Axis 2 별도 프로젝트와 조율 필요 |

---

### P2.4 — 수수료 위임 엔터프라이즈 통합 가이드

| 항목 | 내용 |
|---|---|
| **생성 페이지** | `/en/enterprise/fee-delegation-integration` |
| **콘텐츠** | (1) 비즈니스 모델 설명 — 운영자가 사용자 대신 가스 부담 (2) 아키텍처 다이어그램 — 사용자 → 앱 → 수수료 위임자 → 블록체인 TX 타입 0x16 흐름 (3) ethers.js/web3.js 단계별 코드 통합 가이드 (4) 비용 모델링 — 운영자 수수료 위임 비용 계산법 (5) 유스케이스: 한국 결제 앱, 송금 서비스, 기업 트레저리 |
| **벤치마크** | Circle Arc 엔터프라이즈 통합 구조, Stable.xyz Gas Waiver API 패턴 |
| **예상 공수** | **16h** (JavaScript 코드 예제 + 아키텍처 다이어그램 + 테스트넷 검증) |
| **의존성** | 엔지니어링 — 수수료 위임 RPC 흐름 검토, 코드 예제 테스트넷 동작 확인 |
| **효과** | `enterprise_integration` 1→3점, `payment_use_cases` 2→3점 |

---

### P2.5 — Hardhat 통합 가이드

| 항목 | 내용 |
|---|---|
| **생성 페이지** | `/en/development-tools/hardhat-guide` |
| **콘텐츠** | `npx hardhat init` + `hardhat.config.js` (StableNet testnet RPC + Chain ID 8283) + 네트워크 설정 + 배포 스크립트 + ethers.js 수수료 위임 TX 예제 |
| **벤치마크** | Plume 병렬 툴 가이드 (Remix/Foundry/Hardhat 각 전체 페이지) |
| **예상 공수** | **8h** |
| **의존성** | P1.5 (Foundry 가이드가 패턴 및 Solidity 컨트랙트 제공), P1.1 (네트워크 상세) |
| **효과** | `evm_tooling_support` 2→3점 (P1.5 이후 기준) |

---

## Week 9–12: P3 전략 & 폴리시 (총 ~66시간 + 외부 비용)

> **목표:** 보안 신뢰, 한국어 시장 선점, 운영 인프라

---

### P3.1 — 보안 감사 보고서 게시 ⚠️ 별도 프로젝트

| 항목 | 내용 |
|---|---|
| **생성 페이지** | `/en/security/audits` (플레이스홀더 선 생성 가능: "감사 진행 중 — Q3 2026 예정") |
| **콘텐츠** | 감사 대상: GovMasterMinter, GovMinter, GovBase, NativeCoinAdapter, WKRCToken. 형식: 감사 회사명 + 날짜 + 범위 + PDF 링크 |
| **벤치마크** | Plume GitHub PDF 직링크, Frax 감사 타임라인 (2020~2025), M0 다중 회사 접근 |
| **예상 공수** | **4h** (문서 페이지) + **외부 감사 비용 및 4~8주** |
| **의존성** | 예산 승인, 감사 회사 선정 (Halborn/OtterSec/ChainSecurity 등), 스마트 컨트랙트 코드 프리즈 |
| **효과** | `security_audits` 0→3점. 기관 신뢰도 단일 최대 전환점 |

---

### P3.2 — 버그바운티 프로그램 론칭 ⚠️ 별도 프로젝트

| 항목 | 내용 |
|---|---|
| **생성 페이지** | `/en/security/bug-bounty` |
| **콘텐츠** | 프로그램 링크 + 범위 정의 + 보상 티어 + 공개 정책 |
| **벤치마크** | Frax $10M 최대 보상 (익스플로잇 가치의 10%) + Tether RP1-RP5 티어 구조 |
| **예상 공수** | **4h** (문서) + 외부 플랫폼 설정 (Immunefi/HackerOne) |
| **의존성** | P3.1 완료 권장 (감사 후 버그바운티 론칭이 표준 순서) |

---

### P3.3 — 한국어 현지화 (핵심 4페이지)

| 항목 | 내용 |
|---|---|
| **현지화 대상** | `/ko/getting-started/quickstart` + `/ko/getting-started/testnet-network-details` + `/ko/krw-hub/overview` + `/ko/stablecoin/wkrc-reserve-transparency` (최소 4페이지) |
| **콘텐츠** | 영어 원본 전문 번역, 한국어 기술문서 작성자 검토 필수 |
| **벤치마크** | Frax `/ko/` 섹션 — 경쟁사 중 유일한 의미있는 한국어 지원 |
| **예상 공수** | **24h** (영어 원본 확정 후, 한국어 기술문서 작성자 리소스 별도) |
| **의존성** | P1.5 (퀵스타트), P1.1 (네트워크 상세), P2.2 (KRW Hub) 완성 후. 한국어 기술문서 작성자 채용/외주 |
| **효과** | `localization` 2→4점. Maroo 테스트넷 출시 전 한국 개발자 선점 |

---

### P3.4 — 상태 페이지 + SLA 문서 ⚠️ 별도 프로젝트

| 항목 | 내용 |
|---|---|
| **생성 페이지** | `/en/operations/status` (상태 페이지 링크 + 운영 목표 명시) |
| **운영 인프라** | `status.stablenet.network` (Instatus/Freshstatus 등 추천) |
| **콘텐츠** | 현재 testnet/mainnet 상태 + 과거 가동률 + 비공식 목표 명시 ("업무시간 99% testnet 가동 목표") |
| **벤치마크** | Paxos status.paxos.com, Circle Arc status.arc.network |
| **예상 공수** | **2h** (문서) + **8~16h** (모니터링 인프라 구성) |
| **의존성** | 엔지니어링 — testnet 노드 헬스체크 계측 및 모니터링 도구 설정 |
| **효과** | `sla_uptime` 0→2점 |

---

### P3.5 — 크로스체인 로드맵 페이지

| 항목 | 내용 |
|---|---|
| **생성 페이지** | `/en/cross-chain/roadmap` |
| **콘텐츠** | Phase 1: StableNet 독립 테스트넷 (현재) / Phase 2: Ethereum WKRC 브릿지 (전략 확정 후) / Phase 3: 멀티체인 WKRC (인터롭 프로토콜 TBD). 플레이스홀더 컨트랙트 주소 포함 (배포 시 업데이트 예정) |
| **벤치마크** | Circle Arc CCTP v2 문서, M0 Hub-and-Spoke 아키텍처 다이어그램 |
| **예상 공수** | **4h** (비즈니스 전략 결정 후) |
| **의존성** | 비즈니스 — 크로스체인 전략 및 브릿지 프로토콜 선택 |
| **효과** | `cross_chain` 0→1점. 기관 기술 due diligence 대응 |

---

## 전체 로드맵 요약

| 기간 | 항목 | 예상 공수 | 핵심 결과물 |
|---|---|---|---|
| **Week 1–2** | P1.1 네트워크 상세, P1.2 Changelog, P1.3 API 플레이그라운드, P1.4 Faucet 링크 | **~12h** | 테스트넷 접근 가능, Changelog 개설, API 플레이그라운드 활성화 |
| **Week 3–4** | P1.5 Foundry 퀵스타트, P1.6 EVM 호환성 | **~24h** | 개발자 첫 TX 완전 가이드, EVM 차이점 레퍼런스 |
| **Week 5–8** | P2.1 준비금 투명성, P2.2 KRW Hub, P2.3 컴플라이언스, P2.4 수수료 위임 가이드, P2.5 Hardhat | **~100h** | 기관 due diligence 대응, KRW 포지셔닝 선점 |
| **Week 9–12** | P3.1 보안감사*, P3.2 버그바운티*, P3.3 한국어, P3.4 상태 페이지*, P3.5 크로스체인 | **~66h** + 외부 | 보안 신뢰, 한국어 시장 선점, 운영 투명성 |
| **합계** | **14개 항목** | **~202h** (문서) + 외부 감사 예산 | |

> *별도 프로젝트 항목 (예산·법무·외부 의존성 필요)

---

## 예상 점수 변화

| 축 | 현재 | Week 1–2 후 | Week 3–4 후 | Week 5–8 후 | Week 9–12 후 |
|---|:---:|:---:|:---:|:---:|:---:|
| Axis 1 개발자 온보딩 | 1.40 | ~1.80 | ~2.80 | ~3.00 | ~3.20 |
| Axis 2 기관 신뢰도 | 0.80 | 0.80 | 0.80 | ~1.40 | ~2.00+ |
| Axis 3 스테이블코인 깊이 | 1.60 | 1.60 | 1.60 | ~2.60 | ~3.00 |
| Axis 4 문서 품질 | 1.80 | ~2.20 | ~2.40 | ~2.60 | ~3.00 |
| **가중 총점** | **1.46** | **~1.75** | **~2.30** | **~2.70** | **~3.00+** |
| **추정 순위** | 9위 | 8위 | 6~7위 | 5위 | **4~5위** |

---

## KRW 선점 긴급도

> Maroo 테스트넷 출시 예상: 2026 Q2/Q3. **Window: 6~12개월.**

P1.5 (퀵스타트) + P2.2 (KRW Hub)를 Maroo 테스트넷 출시 전에 완료하면:
- KRW 특화 지표: StableNet 4점 vs Maroo 3점 (현재 역전 → 우위)
- 결제 사례: StableNet 3점 vs Maroo 1점
- 첫 TX 시간: StableNet 4점 vs Maroo 0점

**실제 작동하는 인프라 + 선점 문서 = Maroo 대비 영구적 포지셔닝 우위**

---

*로드맵 기준: Phase 3 종합 리포트 (raw_output.md) | 2026-04-09*
