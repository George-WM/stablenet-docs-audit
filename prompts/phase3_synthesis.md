## Task: Synthesis — Comparison Matrix + Gap Analysis + Content Roadmap

You have the evaluation results from StableNet (self-audit) and 9 competitors. Synthesize them into actionable outputs.

### Input Files
The following JSON files are available in the outputs/ directory:
- `outputs/phase1/stablenet.json` — StableNet self-audit
- `outputs/phase2/*.json` — 9 competitor evaluations

Read ALL of these files before generating output.

### Instructions

#### 1. Comparison Matrix (outputs/phase3/matrix.md)
Create a Markdown table comparing all 10 entities (StableNet + 9 competitors) across all 4 axes.

Format:
| Competitor | Type | Axis 1 (Dev) | Axis 2 (Inst) | Axis 3 (Stable) | Axis 4 (Quality) | Weighted Total | Confidence |

- Calculate axis scores as average of their 5 metrics
- Calculate weighted total using weights: Axis1=0.35, Axis2=0.15, Axis3=0.25, Axis4=0.25
- Sort by weighted total descending
- Add a "StableNet Rank" row showing position

#### 2. Gap Analysis (outputs/phase3/gap_analysis.md)
For each metric where StableNet scores below the **category best** (group competitors by type):

Format per gap:
```
### [Metric Name] — StableNet: X/5 vs Best: Y/5 ([Competitor])
- **What they do:** [specific feature/page from competitor evidence]
- **What StableNet lacks:** [from self-audit evidence]
- **Effort to close:** S/M/L
- **Impact:** High/Medium/Low
- **Priority:** P1/P2/P3 (Impact × 1/Effort)
```

Sort gaps by Priority (P1 first).

#### 3. Content Roadmap (outputs/phase3/content_roadmap.md)
Based on gap analysis, create a week-by-week content plan:

- **Week 1-2:** P1 gaps (quick wins, high impact)
- **Week 3-4:** P1 gaps (larger effort)
- **Week 5-8:** P2 gaps
- **Week 9-12:** P3 gaps + polish

Each item should specify:
- Page/section to create or improve
- Reference competitor (what to benchmark against)
- Estimated effort (hours)
- Dependencies (if any)

#### 4. Summary JSON (outputs/phase3/summary.json)
Machine-readable summary:
```json
{
  "stablenet_weighted_score": <number>,
  "stablenet_rank": <number out of 10>,
  "competitor_count": 9,
  "total_gaps_identified": <number>,
  "p1_gaps": <number>,
  "p2_gaps": <number>,
  "p3_gaps": <number>,
  "top_3_steal_worthy": [
    {"competitor": "...", "feature": "...", "from_axis": "..."},
    ...
  ],
  "strongest_axis": "...",
  "weakest_axis": "...",
  "estimated_total_hours": <number>,
  "schema_version": "1.0"
}
```

### Output
Generate all 4 files. Write each file's content preceded by a clear file path header.
