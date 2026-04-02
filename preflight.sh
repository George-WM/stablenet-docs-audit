#!/usr/bin/env bash
# preflight.sh — Phase 2 실행 전 경쟁사 docs URL 접근성 확인
# Usage: ./preflight.sh

set -euo pipefail

CONFIG="config/competitors.yaml"
LOGFILE="logs/preflight.log"

check_dependencies() {
    local missing=()
    command -v python3 >/dev/null 2>&1 || missing+=("python3")
    command -v curl >/dev/null 2>&1 || missing+=("curl")
    command -v claude >/dev/null 2>&1 || missing+=("claude")
    if command -v python3 >/dev/null 2>&1; then
        python3 -c "import yaml" 2>/dev/null || missing+=("python3-yaml (pip install pyyaml)")
    fi
    if [ ${#missing[@]} -gt 0 ]; then
        echo "❌ Missing dependencies: ${missing[*]}"
        exit 1
    fi
    echo "✅ All dependencies found"
}

check_url() {
    local name=$1 url=$2
    local status
    status=$(curl -o /dev/null -s -w "%{http_code}" -L --max-time 10 "$url" 2>/dev/null || echo "000")
    if [[ "$status" =~ ^(200|301|302|303|307|308)$ ]]; then
        echo "  ✅ $name ($url) → HTTP $status"
        echo "OK $name $url $status" >> "$LOGFILE"
        return 0
    else
        echo "  ❌ $name ($url) → HTTP $status"
        echo "FAIL $name $url $status" >> "$LOGFILE"
        return 1
    fi
}

main() {
    echo "═══════════════════════════════════════════"
    echo " StableNet Docs Audit — Pre-flight Check"
    echo "═══════════════════════════════════════════"
    echo ""
    check_dependencies
    echo ""
    mkdir -p logs outputs/{phase1,phase2,phase3,phase3_5}
    if [ ! -f "$CONFIG" ]; then
        echo "❌ Config not found: $CONFIG"; exit 1
    fi
    echo "✅ Config found: $CONFIG"
    if [ ! -f "schema/evaluation.yaml" ]; then
        echo "❌ GATE 1 BLOCKED: schema/evaluation.yaml not found"; exit 1
    fi
    echo "✅ Gate 1: schema/evaluation.yaml exists"
    echo ""
    echo "── URL Accessibility Check ──"
    > "$LOGFILE"
    local total=0 passed=0 failed=0
    total=$((total + 1))
    if check_url "StableNet" "https://docs.stablenet.network/"; then
        passed=$((passed + 1))
    else
        failed=$((failed + 1))
    fi
    while IFS= read -r line; do
        local name url
        name=$(echo "$line" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['name'])")
        url=$(echo "$line" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['docs_url'])")
        total=$((total + 1))
        if check_url "$name" "$url"; then
            passed=$((passed + 1))
        else
            failed=$((failed + 1))
        fi
    done < <(python3 -c "
import yaml, json
with open('$CONFIG') as f:
    data = yaml.safe_load(f)
for c in data['competitors']:
    print(json.dumps(c))
")
    echo ""
    echo "── Results ──"
    echo "Total: $total | Passed: $passed | Failed: $failed"
    echo ""
    if [ "$failed" -gt 0 ]; then
        echo "⚠️  Some URLs failed. Check logs/preflight.log"
        echo "   Failed URLs will get score 0 with evidence 'docs site inaccessible'"
    else
        echo "✅ All URLs accessible. Ready to run orchestrator.sh"
    fi
    echo "Log: $LOGFILE"
}

main "$@"
