# Optimization Report

Chat-output layout for Tier 1 / Tier 2. Render these sections directly in the chat response - do NOT save this as a file in the user's project. Date: {{DATE}}. Tier: {{TIER_1_OR_2}}.

## 0. TL;DR

{{3-5 lines: what the project is, the single highest-value recommendation, the biggest risk, and whether the current approach is already appropriate. A reader who stops here should know what to do next.}}

## 1. Project Snapshot

**What it is:** {{one-sentence description}}

**Stack:**
- Languages: {{languages}}
- Frameworks / runtimes: {{frameworks}}
- Datastores: {{datastores}}
- Infra / deploy: {{infra}}
- Build / tooling: {{tooling}}

**Architecture summary:**
{{2-6 sentences describing entry points, primary data flow, key modules, external dependencies}}

**Observed weak points (from code, not speculation):**
- `{{file:line}}` - {{what is wrong in one sentence}}
- `{{file:line}}` - {{...}}

**Unknowns:**
- {{e.g. no load-test data available, no production metrics shared}}

## 2. Competitive Landscape

| Competitor | Their approach | What's different from ours | What's better | Source (tier) |
|---|---|---|---|---|
| {{name}} | {{stack + key architectural choices}} | {{the delta}} | {{what they do better, or "unclear"}} | {{URL}} ({{S/A/B/C/D}}) |
| {{...}} | | | | |

If a competitor's internals are not public, write "internals not public" in the approach column and omit the source.

## 3. Research Findings

- **{{title}}** ({{paper / repo / docs}}, tier {{S/A/B/C/D}}) - {{one-line summary}}. Relevant because: {{why}}. Source: {{URL}}
- {{...}}

## 4. Scale Analysis

- **10x current load:** {{what breaks first, failure mode}}
- **100x current load:** {{what breaks, failure mode}}
- **1000x current load:** {{what breaks, failure mode, or "not realistic for this project"}}

## 5. Recommendations

Ordered by `(impact x confidence) / (effort x risk)`, highest first. If the honest finding is that the current approach is already appropriate, say so here and do not invent recommendations.

### R1. {{short title}}
- **What to change:** {{specific change}}
- **Why:** {{rationale, citing section 2 or 3, e.g. "(Finding 2, A-tier)"}}
- **Counter-argument considered:** {{the strongest case against this, and why the rec survives it}}
- **Quantitative impact:** {{number with units, or "qualitative"}}
- **Effort:** {{dev-weeks}}
- **Cost delta:** {{$/month at assumed scale, or "negligible"}}
- **Risk:** {{migration hazards, what could go wrong}}
- **Confidence:** {{high / medium / low}}
- **Ranking inputs:** impact={{H/M/L}}, confidence={{H/M/L}}, effort={{H/M/L}}, risk={{H/M/L}} -> score {{value}}
- **Next step:** {{file/module to touch, library to evaluate, benchmark to run}}

### R2. {{short title}}
- **What to change:** {{...}}
- **Why:** {{...}}
- **Quantitative impact:** {{...}}
- **Effort:** {{...}}
- **Cost delta:** {{...}}
- **Risk:** {{...}}
- **Confidence:** {{...}}
- **Next step:** {{...}}

{{repeat - typically 4-10 recommendations}}

## 6. Future Watch

- **Emerging:** {{tech / techniques getting traction in this space in the last ~12 months}}
- **Deprecating:** {{what is fading or officially being sunset}}
- **2-3 year horizon:** {{where the field is heading}}
- **Worth tracking, not acting on yet:** {{specific projects / standards}}

## 7. Open Questions

- {{question the research could not answer}}
- {{If applicable: "This project uses {{X}}, which I am not strong in. Recommendations in that area should be validated by an expert."}}
