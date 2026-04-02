## Task: Competitor Docs Analysis — {{COMPETITOR_DISPLAY_NAME}}

Analyze the developer documentation at {{COMPETITOR_URL}}

### Context
- Competitor: {{COMPETITOR_DISPLAY_NAME}}
- Type: {{COMPETITOR_TYPE}}
- Note: {{COMPETITOR_NOTE}}

### Instructions

1. **Navigate the docs thoroughly.**
   - Explore navigation, sitemap, key sections
   - Estimate total pages and structure depth

2. **Score each metric** using 0-5 rubrics.
   - Provide specific evidence for every score
   - If the docs URL is unreachable or redirects to a marketing page with no developer docs, set agent_confidence to 0.1 and score all metrics as 0 with evidence "Docs not accessible"

3. **Compare mentally against what a developer building on StableNet (KRW stablecoin chain) would need.**
   - What does this competitor do well that StableNet should learn from?
   - What gaps exist that StableNet could exploit?

4. **For krw_specific:** If this competitor has no KRW relevance, use score: null, evidence: "N/A"

### Output: ONLY valid JSON

```json
{
  "competitor": "{{COMPETITOR_DISPLAY_NAME}}",
  "docs_url": "{{COMPETITOR_URL}}",
  "type": "{{COMPETITOR_TYPE}}",
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
    "steal_worthy": ["..."]
  }
}
```

Output ONLY the JSON. No other text.
