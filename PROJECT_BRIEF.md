# StableNet Developer Docs Audit — Project Brief

## 목적
StableNet Developer Docs(https://docs.stablenet.network/)의 현재 상태를 진단하고, 
8개 경쟁사와 ICP 기반 비교 분석을 수행하여 개선 로드맵을 수립한다.

## 배경
- StableNet: KRW 스테이블코인 특화 블록체인 생태계
- 현재 Testnet 단계 (Faucet, Explorer 운영 중)
- Developer Docs: Mintlify 기반, GitHub repo 연동
- 담당자가 직접 docs 유지보수 + GitHub Actions 자동화 설계 중

## Ideal Customer Profile (ICP)

### Primary: Blockchain Developer / Technical Founder
- KRW 결제 앱, DeFi 프로토콜, 핀테크 제품 개발
- EVM 툴링, ERC-20, 오픈소스 SDK에 익숙
- 범용 체인의 컴플라이언스 오버헤드에 불만
- GitHub, docs 탐색, 한국 Web3 이벤트 참석

### Secondary: Fintech / Financial Institution Decision-Maker
- 한국 은행, 결제사, 전자금융업자
- 규제 대응 인프라 필요 (KYC/AML 내장)
- 송금, B2B 정산, 급여 지급용 스테이블코인 레일 평가 중
- 리스크 회피적, 거버넌스 통제와 법정화폐 담보 안정성 중시

## 경쟁사 벤치마크 대상 (8곳)
| 경쟁사 | 카테고리 |
|--------|----------|
| Maroo (maroo.io) | KRW 스테이블코인 |
| Paxos (paxos.com) | 스테이블코인 발행 인프라 |
| M0 (m0.org) | 프로토콜 레벨 스테이블코인 |
| Circle Arc | 스테이블코인 유통/파트너 |
| Tether (USDT) | 발행사 개발자 리소스 |
| Plume | RWA 특화 체인 |
| Tokeny | 토큰화 컴플라이언스 플랫폼 |
| Frax | 스테이블코인+DeFi 프로토콜 |

## 실행 계획: 멀티 에이전트 오케스트레이션

### 아키텍처: Fan-out / Fan-in 패턴
- Phase 1: StableNet 자체 진단 (Agent 1개)
- Phase 2: 경쟁사 분석 (Agent 8개, 순차 실행)
- Phase 3: 종합 분석 (Agent 1개, Phase 1+2 결과 합성)

### 하네스 엔지니어링
- 모든 에이전트가 동일한 평가 스키마(YAML)로 출력
- orchestrator.sh가 실행 순서와 데이터 흐름 관리
- 에이전트 간 소통은 파일(JSON)을 통해 수행

### 컨텍스트 관리 전략
- Phase 1: ~30K 토큰 (StableNet docs만)
- Phase 2: 각 ~25K 토큰 (경쟁사 1곳씩)
- Phase 3: ~27K 토큰 (9개 구조화 JSON)
- 어떤 단계에서도 컨텍스트 한계 미도달

### 평가 프레임워크 (4개 축)
1. Developer Onboarding (Primary ICP) — time_to_first_tx, evm_tooling, code_examples, testnet, sdk_api
2. Institutional Confidence (Secondary ICP) — compliance, governance, security, sla, enterprise
3. Stablecoin-Specific Depth — minting, reserve, cross_chain, krw_specific, payment
4. Docs Quality (UX) — IA, search, freshness, localization, interactive

### 산출물
- 비교 매트릭스 (경쟁사 유형별 그룹핑)
- Gap 분석 (StableNet vs 카테고리별 최고 점수)
- Content Roadmap (우선순위화된 개선 계획)
- 유지보수 프로세스 (GitHub Actions + Claude API 자동화 연결)