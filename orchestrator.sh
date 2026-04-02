#!/usr/bin/env bash
# orchestrator.sh — StableNet Docs Audit Multi-Agent Orchestrator
#
# Usage:
#   ./orchestrator.sh phase1                    # StableNet 자체 진단
#   ./orchestrator.sh phase2 --only maroo       # Maroo 파일럿만 실행
#   ./orchestrator.sh phase2                    # 나머지 경쟁사 (완료 skip)
#   ./orchestrator.sh phase3                    # 종합 분석
#   ./orchestrator.sh all                       # Phase 1 → Maroo 파일럿 → 멈춤

set -uo pipefail

CONFIG="config/competitors.yaml"
SCHEMA="schema/evaluation.yaml"
SYSTEM_PROMPT="prompts/system.md"
PHASE1_PROMPT="prompts/phase1_self_audit.md"
PHASE2_TEMPLATE="prompts/phase2_competitor.md"
PHASE3_PROMPT="prompts/phase3_synthesis.md"
MIN_THRESHOLD=5

log() { echo "[$(date '+%H:%M:%S')] $*"; }
err() { echo "[$(date '+%H:%M:%S')] ❌ $*" >&2; }

check_gate1() {
    if [ ! -f "$SCHEMA" ]; then
        err "GATE 1 BLOCKED: $SCHEMA not found. 스키마를 먼저 확정하세요."
        exit 1
    fi
    if [ ! -f "$SYSTEM_PROMPT" ]; then
        err "System prompt not found: $SYSTEM_PROMPT"
        exit 1
    fi
}

run_agent() {
    local name=$1 prompt=$2 out=$3

    if [ -f "$out" ]; then
        log "[SKIP] $name: output already exists at $out"
        return 0
    fi

    mkdir -p "$(dirname "$out")" logs

    log "[RUN] $name..."

    local full_prompt
    full_prompt="$(cat "$SYSTEM_PROMPT")

---
## Evaluation Schema
$(cat "$SCHEMA")

---
$prompt"

    if ! claude --dangerously-skip-permissions \
        -p "$full_prompt" > "${out}.tmp" 2>> "logs/${name}.log"; then
        local exit_code=$?
        err "$name: claude exited with code $exit_code"
        echo "$name: exit_code=$exit_code" >> logs/failed.txt
        rm -f "${out}.tmp"
        return 1
    fi

    if ! python3 -c "import json,sys; json.load(sys.stdin)" < "${out}.tmp" 2>/dev/null; then
        if python3 << 'PYEOF' < "${out}.tmp" > "${out}.extracted" 2>/dev/null
import sys, json, re
text = sys.stdin.read()
match = re.search(r'```json\s*\n(.*?)\n\s*```', text, re.DOTALL)
if match:
    json.loads(match.group(1))
    print(match.group(1))
    sys.exit(0)
start = text.find('{')
end = text.rfind('}')
if start >= 0 and end > start:
    json.loads(text[start:end+1])
    print(text[start:end+1])
    sys.exit(0)
sys.exit(1)
PYEOF
        then
            log "[WARN] $name: extracted JSON from mixed output"
            mv "${out}.extracted" "${out}.tmp"
        else
            err "$name: invalid JSON output"
            echo "$name: invalid_json" >> logs/failed.txt
            rm -f "${out}.tmp" "${out}.extracted"
            return 1
        fi
    fi

    local sv
    sv=$(python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('schema_version','MISSING'))" < "${out}.tmp" 2>/dev/null || echo "PARSE_ERROR")
    if [ "$sv" = "MISSING" ] || [ "$sv" = "PARSE_ERROR" ]; then
        log "[WARN] $name: schema_version missing in output (non-blocking)"
    fi

    mv "${out}.tmp" "$out"
    log "[DONE] $name → $out"
    return 0
}

run_phase1() {
    log "═══ Phase 1: StableNet Self-Audit ═══"
    local prompt
    prompt=$(cat "$PHASE1_PROMPT")
    run_agent "stablenet" "$prompt" "outputs/phase1/stablenet.json"
}

run_phase2() {
    local only_target="${1:-}"
    log "═══ Phase 2: Competitor Analysis ═══"

    if [ -n "$only_target" ]; then
        log "Pilot mode: only running $only_target"
    fi

    local count=0 success=0 failed=0

    while IFS= read -r line; do
        local name display url website type category
        name=$(echo "$line" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['name'])")
        display=$(echo "$line" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['display_name'])")
        url=$(echo "$line" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['docs_url'])")
        website=$(echo "$line" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['website'])")
        type=$(echo "$line" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['type'])")
        category=$(echo "$line" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['category'])")

        if [ -n "$only_target" ] && [ "$name" != "$only_target" ]; then
            continue
        fi

        count=$((count + 1))

        local prompt
        prompt=$(sed \
            -e "s|{{COMPETITOR_NAME}}|$name|g" \
            -e "s|{{COMPETITOR_DISPLAY}}|$display|g" \
            -e "s|{{COMPETITOR_URL}}|$url|g" \
            -e "s|{{COMPETITOR_WEBSITE}}|$website|g" \
            -e "s|{{COMPETITOR_TYPE}}|$type|g" \
            -e "s|{{COMPETITOR_CATEGORY}}|$category|g" \
            "$PHASE2_TEMPLATE")

        if run_agent "$name" "$prompt" "outputs/phase2/${name}.json"; then
            success=$((success + 1))
        else
            failed=$((failed + 1))
        fi

        if [ -z "$only_target" ]; then
            log "[WAIT] 30s rate limit cooldown..."
            sleep 30
        fi

    done < <(python3 -c "
import yaml, json
with open('$CONFIG') as f:
    data = yaml.safe_load(f)
for c in data['competitors']:
    print(json.dumps(c))
")

    echo ""
    log "Phase 2 Results: $count attempted | $success succeeded | $failed failed"

    if [ -n "$only_target" ]; then
        echo ""
        log "═══ PILOT PAUSE ═══"
        log "파일럿 완료. 다음 단계:"
        log "  1. outputs/phase2/${only_target}.json 검토"
        log "  2. 스키마/프롬프트 보정 필요 시 수정"
        log "  3. 준비되면: ./orchestrator.sh phase2"
        echo ""
    fi
}

run_phase3() {
    log "═══ Phase 3: Synthesis ═══"

    if [ ! -f "outputs/phase1/stablenet.json" ]; then
        err "Phase 1 output not found. Run: ./orchestrator.sh phase1"
        exit 1
    fi

    local phase2_count
    phase2_count=$(find outputs/phase2 -name "*.json" -type f 2>/dev/null | wc -l | tr -d ' ')

    if [ "$phase2_count" -lt "$MIN_THRESHOLD" ]; then
        err "Not enough data: ${phase2_count}/9 competitors (minimum: $MIN_THRESHOLD)"
        err "Run more Phase 2 agents before proceeding."
        log "Completed: $(ls outputs/phase2/*.json 2>/dev/null | xargs -I{} basename {} .json | tr '\n' ', ')"
        exit 1
    fi

    log "Data check: ${phase2_count}/9 competitors (threshold: $MIN_THRESHOLD) ✅"

    local context=""
    context+="## StableNet Self-Audit Data
\`\`\`json
$(cat outputs/phase1/stablenet.json)
\`\`\`

"
    for f in outputs/phase2/*.json; do
        local comp_name
        comp_name=$(basename "$f" .json)
        context+="## Competitor: $comp_name
\`\`\`json
$(cat "$f")
\`\`\`

"
    done

    local prompt
    prompt="$context
---
$(cat "$PHASE3_PROMPT")"

    log "[RUN] phase3_synthesis..."

    local full_prompt
    full_prompt="$(cat "$SYSTEM_PROMPT")

---
$prompt"

    if ! claude --dangerously-skip-permissions \
        -p "$full_prompt" > "outputs/phase3/raw_output.md" 2>> "logs/phase3.log"; then
        err "Phase 3 synthesis failed"
        exit 1
    fi

    log "[DONE] Phase 3 → outputs/phase3/raw_output.md"
    echo ""
    log "═══ AUDIT COMPLETE ═══"
    log "Results: outputs/phase3/raw_output.md"
}

main() {
    check_gate1
    local command="${1:-help}"
    shift || true

    case "$command" in
        phase1)   run_phase1 ;;
        phase2)
            local only=""
            if [ "${1:-}" = "--only" ] && [ -n "${2:-}" ]; then only="$2"; fi
            run_phase2 "$only"
            ;;
        phase3)   run_phase3 ;;
        all)      run_phase1; echo ""; run_phase2 "maroo" ;;
        *)
            echo "Usage:"
            echo "  ./orchestrator.sh phase1                 # StableNet 자체 진단"
            echo "  ./orchestrator.sh phase2 --only maroo    # Maroo 파일럿"
            echo "  ./orchestrator.sh phase2                 # 나머지 경쟁사 (완료 skip)"
            echo "  ./orchestrator.sh phase3                 # 종합 분석"
            echo "  ./orchestrator.sh all                    # Phase1 + Maroo 파일럿"
            echo ""
            echo "권장 순서: preflight.sh → all → (검토) → phase2 → phase3"
            ;;
    esac
}

main "$@"
