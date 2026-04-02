## Task: StableNet Developer Docs Self-Audit

Analyze StableNet's developer documentation at https://docs.stablenet.network/

### Instructions

1. **Navigate the docs thoroughly.**
   - Identify the sitemap/navigation structure
   - Count approximate total pages
   - List all top-level sections

2. **Score each metric** using 0-5 rubrics from the evaluation schema.
   - For each score, provide specific evidence (page names, URLs, features)
   - Be honest about gaps — this is a self-audit

3. **Assess from ICP perspective:**
   - Primary: Can an EVM dev deploy first contract in 30 min using only these docs?
   - Secondary: Would a fintech decision-maker find enough to evaluate StableNet?

4. **Note:** StableNet is Testnet phase. Faucet and Explorer exist. Mintlify-based docs.

### Output: ONLY valid JSON

```json
{
  "competitor": "StableNet",
  "docs_url": "https://docs.stablenet.network",
  "type": "stablechain",
  "analyzed_at": "<ISO 8601>",
  "schema_version": "1.0",
  "agent_confidence": <0.0-1.0>,
  "navigation_structure": {
    "total_pages_estimated": <number>,
    "top_level_sections": ["..."],
    "nav_depth": <number>
  },
  "axis_1_developer_onboarding": {
    "time_to_first_tx": {"score": <0-5>, "evidence": "..."},
    "evm_tooling_support": {"score": <0-5>, "evidence": "..."},
    "code_examples": {"score": <0-5>, "evidence": "..."},
    "testnet_accessibility": {"score": <0-5>, "evidence": "..."},
    "sdk_api_quality": {"score": <0-5>, "evidence": "..."}
  },
  "axis_2_institutional_confidence": {
    "compliance_docs": {"score": <0-5>, "evidence": "..."},
    "governance_transparency": {"score": <0-5>, "evidence": "..."},
    "security_audits": {"score": <0-5>, "evidence": "..."},
    "sla_uptime": {"score": <0-5>, "evidence": "..."},
    "enterprise_integration": {"score": <0-5>, "evidence": "..."}
  },
  "axis_3_stablecoin_depth": {
    "minting_redeeming": {"score": <0-5>, "evidence": "..."},
    "reserve_transparency": {"score": <0-5>, "evidence": "..."},
    "cross_chain": {"score": <0-5>, "evidence": "..."},
    "krw_specific": {"score": <0-5|null>, "evidence": "..."},
    "payment_use_cases": {"score": <0-5>, "evidence": "..."}
  },
  "axis_4_docs_quality": {
    "information_architecture": {"score": <0-5>, "evidence": "..."},
    "search_discoverability": {"score": <0-5>, "evidence": "..."},
    "freshness": {"score": <0-5>, "evidence": "..."},
    "localization": {"score": <0-5>, "evidence": "..."},
    "interactive_elements": {"score": <0-5>, "evidence": "..."}
  },
  "qualitative": {
    "strengths": ["..."],
    "weaknesses": ["..."],
    "critical_gaps": ["..."]
  }
}
```

Output ONLY the JSON. No other text.
