# TODOS — StableNet Docs Audit

## GATE 1 (Must complete before any execution)

- [ ] `schema/evaluation.yaml` 생성 (4개 축, 가중치, 지표 목록, confidence scoring, schema_version: "1.0")
  - **Why:** 이 파일 없이는 에이전트들이 제각각 다른 기준으로 평가함. Phase 2 프롬프트, Phase 3 스키마, P5 인풋 형식 모두 이 파일에 의존.
  - **Context:** 4개 축: developer_onboarding (0.35), stablecoin_depth (0.35), docs_quality_ux (0.20), institutional_confidence (0.10). 각 축 5개 지표, 0-5점 채점 기준과 예시 증거 포함.

## Pre-execution (Gate 1 완료 후)

- [ ] `config/competitors.yaml` 생성 (9개 경쟁사: name, url, category, 순서: Maroo 첫 번째)
  - **Why:** orchestrator.sh가 여기서 경쟁사 목록을 읽음. Maroo가 첫 번째여야 pilot pause가 의도대로 동작.
  - **Context:** Maroo, Paxos, M0, Circle, Tether, Plume, Tokeny, Frax, Stable.xyz (docs.stable.xyz). --only maroo 플래그가 name 필드 기준으로 동작.

- [ ] `prompts/phase1.md` 작성 (StableNet self-audit 프롬프트)
  - **Why:** schema.yaml 확정 후 작성 가능. 4개 축 기준으로 docs.stablenet.network 분석, outputs/phase1/stablenet.json 출력.
  - **Context:** 출력 형식: schema_version: "1.0", 각 지표에 score(0-5) + confidence(observed/inferred/no-data) + evidence(URL/인용).

- [ ] `prompts/phase2.md` 작성 (경쟁사 분석 템플릿)
  - **Why:** `{{COMPETITOR_NAME}}`과 `{{COMPETITOR_URL}}` 플레이스홀더 포함. orchestrator.sh가 sed로 치환.
  - **Context:** Phase 1과 동일한 출력 스키마. outputs/phase2/{{COMPETITOR_NAME}}.json 기록.

- [ ] `prompts/phase3.md` 작성 (합성 에이전트 프롬프트)
  - **Why:** outputs/phase1/stablenet.json + outputs/phase2/*.json 읽어 비교 매트릭스 + gap 분석 + content roadmap 생성.
  - **Context:** outputs/phase3/에 matrix.md, gap_analysis.md, content_roadmap.md, summary.json 생성. schema_version 불일치 파일 무시 지시 포함.

- [ ] `prompts/phase3_5.md` 작성 (Gap→Draft 자동 드래프트 프롬프트)
  - **Why:** gap_analysis.md Top 5 항목을 실제 docs 콘텐츠 초안으로 변환.
  - **Context:** outputs/phase3_5/draft_{topic}.md × 5 생성. Mintlify MDX 형식 고려.

- [ ] `preflight.sh` 작성
  - **Why:** Phase 2 시작 전 9개 경쟁사 URL browse 접근성 확인. 로그인 게이트 사이트 조기 식별.
  - **Context:** 출력: logs/preflight.json ({name, url, accessible: true/false, note}). accessible: false면 phase2에서 confidence: no-data로 처리.

- [ ] `orchestrator.sh` 작성
  - **Why:** 핵심 실행 엔진. 아래 세부 사항 반드시 포함.
  - **Context (구현 체크리스트):**
    - `which claude || { echo "ERROR: claude CLI not found"; exit 1; }`
    - `python3 --version || { echo "ERROR: python3 required"; exit 1; }`
    - `[ -f schema/evaluation.yaml ] || { echo "ERROR: Gate 1 — schema/evaluation.yaml missing"; exit 1; }`
    - `mkdir -p outputs/phase1 outputs/phase2 outputs/phase3 outputs/phase3_5 logs`
    - `run_agent()` 함수: idempotency 체크 → 실행 → exit code 체크 → JSON 유효성 → mv .tmp
    - Phase 2: `--only NAME` / `--skip NAME` 플래그 지원
    - Phase 2: python3 yaml 파서로 competitors.yaml 읽기 (yq 불필요)
    - Phase 2: sed로 `{{COMPETITOR_NAME}}`과 `{{COMPETITOR_URL}}` 치환
    - Phase 2: 치환 후 `{{`가 남아있으면 abort ("template substitution failed")
    - Phase 2: 에이전트 간 `sleep 30` (rate limiting 방지)
    - Phase 3 진입 전: outputs/phase2/*.json 파일 수 ≥ 5 확인, 미달 시 exit 1
    - Phase 3.5: gap_analysis.md 파싱, Top 5 없으면 skip + 로그

## Post-Maroo Pilot

- [ ] Type-differentiated prompt templates (KRW / infra / RWA chain / DeFi)
  - **Why:** 경쟁사 카테고리마다 평가 중점이 다를 수 있음 (KRW 스테이블코인 vs RWA 체인 vs DeFi 프로토콜).
  - **Context:** Maroo 결과 검토 후 카테고리 컨텍스트가 점수에 유의미한 차이를 내는지 판단. 차이 없으면 SKIP.
  - **Depends on:** Maroo pilot 완료 및 수동 검토

## Operational

- [ ] Rate limiting: 에이전트 간 sleep 30 추가 (orchestrator.sh 구현 시)
- [ ] P5 팀과 outputs/phase3/summary.json 스키마 사전 합의 (Gate 1 완료 후)
  - **Why:** P5 GitHub Actions 파이프라인이 이 파일을 인풋으로 사용. 형식 불일치 시 P5 파이프라인 수정 필요.
  - **Depends on:** schema/evaluation.yaml 확정

## Path Corrections (from Eng Review)

- [ ] CEO plan의 Phase 3 output 경로 수정: `outputs/` 루트 → `outputs/phase3/`
  - **Why:** design doc과 일치시킴. idempotency 체크가 outputs/phase3/summary.json으로 단순화.
  - **Status:** CEO plan은 gstack artifact (수정 필요), orchestrator.sh 구현 시 `outputs/phase3/` 기준으로.

## Future (Post-regulation)

- [ ] EUREKA: KRW 규제 확정 시 Axis 2 (Institutional Confidence) 가중치 상향 + compliance docs 분석 프로젝트 분리
  - **Why:** 현재 스키마에 Axis 2 이미 포함 (가중치 0.10). 규제 확정 시 스키마 수정 후 재실행 가능.
  - **Depends on:** 한국 KRW 스테이블코인 규제 확정
