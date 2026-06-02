# Executive Report (Tier 3)

Chat-output layout for the top of a Tier 3 report. Render in the chat - do NOT save as a file. The companion sections (subsystems, bibliography, risk register, failure modes, future watch) follow in the same chat response. Refer to them by name, not by file path. Date: {{DATE}}.

## TL;DR

{{3-5 sentences. What the project is, the single most important finding, the single most important recommendation, the single biggest risk. If the current architecture is already appropriate for the stated scale, say so plainly. A reader who only reads this paragraph should know what to do next.}}

## Constraints (from Phase 0 interview)

- Current scale: {{...}}
- Target scale: {{...}}
- Latency budget: {{...}}
- Team: {{...}}
- Infra constraints: {{...}}
- Non-negotiables: {{...}}
- Stated pain: {{...}}

## Project Snapshot

**Purpose (one sentence):** {{...}}

**Stack:** {{...}}

**Subsystems (each gets its own deep-dive section below):**
- {{subsystem-1}} - {{one-line role}}
- {{subsystem-2}} - {{...}}
- {{...}}

## Scoreboard

Each subsystem's health against the user's stated constraints.

| Subsystem | Current state | Headroom to target | Top risk | Confidence |
|---|---|---|---|---|
| {{name}} | {{healthy / stressed / bottleneck}} | {{good / tight / will break}} | {{one-line top risk}} | {{high/med/low}} |
| {{...}} | | | | |

## Top 10 Recommendations

Ranked by `(impact x confidence) / (effort x risk)`. The ranking inputs are shown so the order is auditable. Full detail for each lives in the relevant subsystem section below. If fewer than 10 are genuinely warranted, list fewer - do not pad.

| # | Recommendation | Subsystem | Impact | Effort (dev-wks) | Confidence | Score |
|---|---|---|---|---|---|---|
| 1 | {{title}} | {{subsystem}} | {{high/med/low}} | {{n}} | {{high/med/low}} | {{score}} |
| 2 | {{...}} | | | | | |
| {{...}} | | | | | | |

## Must-do this quarter

The 2-4 recommendations the user should commit to this quarter given their constraints. One line each.

1. {{...}} - because {{...}}
2. {{...}} - because {{...}}

## Key risks

Top 3-5 risks, summarized. The full Risk Register section below has the rest.

- **{{risk title}}** ({{severity}}) - {{one-line summary}}. Mitigation: {{one-line}}.
- {{...}}

## Cross-cutting findings

Findings that don't sit cleanly in one subsystem.

- {{e.g. "No centralized observability - blocks every recommendation that needs measurement."}}
- {{...}}

## Caveats

- {{Domain confidence: e.g. "I am not strong in {{X}}; recommendations touching it are marked low-confidence."}}
- {{Coverage caveats: e.g. "Did not review the {{Y}} subsystem in depth - out of scope this pass."}}
- {{Bias notes: e.g. "Two sources here are vendor-authored and flagged as such."}}
