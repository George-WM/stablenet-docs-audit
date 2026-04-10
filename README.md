# StableNet Developer Docs Audit

StableNet Developer Docs의 현재 상태를 진단하고, 9개 경쟁사와 ICP 기반 비교 분석을 수행하여 개선 로드맵을 수립합니다.

## 실행 현황

| 기간 | 단계 | 상태 |
|------|------|------|
| Week 1–2 | P1 Quick Wins (P1.1~P1.4) | ✅ 완료 (2026-04-10) |
| Week 3–4 | P1 핵심 개발자 콘텐츠 (P1.5~P1.6) | 진행 예정 |
| Week 5–8 | P2 깊이 & 기관 대응 | 대기 |
| Week 9–12 | P3 전략 & 폴리시 | 대기 |

---

## Prerequisites

- **Claude Code CLI** (`claude` command available)
- **Python 3** with PyYAML (`pip install pyyaml`)
- **curl** (pre-flight URL checks)

## Quick Start

```bash
# 1. Pre-flight: URL 접근성 확인
./preflight.sh

# 2. Phase 1 (StableNet) + Maroo 파일럿
./orchestrator.sh all

# 3. 파일럿 결과 검토
cat outputs/phase1/stablenet.json | python3 -m json.tool
cat outputs/phase2/maroo.json | python3 -m json.tool

# 4. (필요 시) 스키마 보정 후 나머지 경쟁사 실행
./orchestrator.sh phase2

# 5. 종합 분석
./orchestrator.sh phase3
```

## Project Structure

```
stablenet-docs-audit/
├── schema/
│   └── evaluation.yaml       # Gate 1: 평가 스키마 (4축 × 5지표)
├── config/
│   └── competitors.yaml      # 9개 경쟁사 URL + 메타데이터
├── prompts/
│   ├── system.md              # 공통 시스템 프롬프트 (ICP, 규칙)
│   ├── phase1_self_audit.md   # StableNet 자체 진단
│   ├── phase2_competitor.md   # 경쟁사 분석 템플릿 ({{변수}} 치환)
│   └── phase3_synthesis.md    # 종합 분석
├── outputs/
│   ├── phase1/stablenet.json
│   ├── phase2/{competitor}.json
│   ├── phase3/
│   │   ├── matrix.md          # 비교 매트릭스
│   │   ├── gap_analysis.md    # Gap 분석
│   │   ├── content_roadmap.md # 콘텐츠 로드맵
│   │   └── summary.json       # 머신 리더블 요약
│   └── phase3_5/              # 시각화/프레젠테이션 (TBD)
├── logs/                      # 에이전트 로그, 실패 기록
├── preflight.sh               # URL 접근성 사전 체크
├── orchestrator.sh            # 멀티 에이전트 오케스트레이터
└── README.md
```

## Architecture

**Fan-out / Fan-in 패턴** with sequential execution:

```
Phase 1 (1 agent)  →  Phase 2 (9 agents, sequential)  →  Phase 3 (1 agent)
   StableNet             Maroo (pilot) → 나머지 8곳          종합 분석
```

### Key Design Decisions

| 결정 | 선택 | 이유 |
|------|------|------|
| 실행 순서 | 순차 | 디버깅 용이성, 파일럿 보정 |
| 파일럿 | Maroo 먼저 | 스키마/프롬프트 검증 후 나머지 실행 |
| YAML 파서 | python3 yaml | yq 설치 불필요 |
| 실패 감지 | exit code + JSON 검증 | 이중 체크 |
| Phase 3 진입 | 5/9 임계값 | 불완전 데이터 방지 |
| 스키마 버전 | evaluation.yaml + output JSON | 파일럿 보정 추적 |

## Evaluation Framework

4개 축, ICP 의사결정 여정 기반:

| 축 | 가중치 | 대상 ICP |
|----|--------|----------|
| Developer Onboarding | 0.35 | Primary (개발자) |
| Institutional Confidence | 0.15 | Secondary (금융기관) |
| Stablecoin Depth | 0.25 | Both |
| Docs Quality | 0.25 | Both |

각 축 5개 지표, 0-5점 채점. 상세 루브릭은 `schema/evaluation.yaml` 참조.

## Competitors (9)

| 이름 | 유형 | Docs URL |
|------|------|----------|
| Maroo | stablecoin_infra | docs.maroo.io |
| Paxos | stablecoin_infra | docs.paxos.com |
| M0 | stablecoin_infra | docs.m0.org |
| Circle Arc | distribution | developers.circle.com |
| Stable.xyz | stablechain | docs.stable.xyz |
| Plume | rwa_chain | docs.plumenetwork.xyz |
| Tokeny | compliance_platform | docs.tokeny.com |
| Frax | defi_protocol | docs.frax.finance |
| Tether | stablecoin_infra | docs.tether.to |

## Estimated Cost

~$1.5-2 USD (Claude Sonnet 4.6, 11 agent calls)
