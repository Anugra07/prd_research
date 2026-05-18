# Failure Modes at Scale

Per-subsystem analysis: what breaks first as load grows. Drives the "Scale Analysis" section of [EXECUTIVE_REPORT.md](EXECUTIVE_REPORT.md) and informs every recommendation's risk and confidence scoring.

## Current baseline

- Current scale (from Phase 0 interview): {{e.g. "50 rps, 2M rows in the largest table"}}
- Target scale (from Phase 0): {{e.g. "5,000 rps, 200M rows in 12 months"}}
- Headroom: {{ratio target/current, e.g. 100x rps and 100x data}}

## Per-subsystem failure analysis

### {{subsystem-1}}

| Scale | What breaks first | Failure mode | Evidence | Competitor approach at this scale | Source (tier) |
|---|---|---|---|---|---|
| 10x | {{component / resource}} | {{slow / errors / cascading / data loss}} | {{file:line or "inferred"}} | {{how a competitor handles it}} | {{URL}} ({{tier}}) |
| 100x | {{...}} | {{...}} | {{...}} | {{...}} | {{...}} |
| 1000x | {{... or "not realistic for this project - explain"}} | | | | |

Notes:
- {{Specific bottleneck mechanics. E.g. "At 100x, the single Postgres primary's WAL fsync becomes the bottleneck - see {{source}}"}}
- {{...}}

### {{subsystem-2}}

{{same table}}

{{repeat per subsystem}}

## Cross-cutting failure modes

Failures that emerge from interactions between subsystems, not from any one subsystem alone.

- **{{name, e.g. "Retry-storm cascade"}}** - {{description}}. Triggers at ~{{scale}}. Mitigated by: {{specific change}} ({{rec ID}}).
- {{...}}

## What we cannot predict from code alone

Failure modes that depend on runtime / production behavior we have no visibility into. Need observability or load testing to validate.

- {{e.g. "Connection pool saturation depends on real query latency distribution, which we don't have"}}
- {{...}}

## Comparison: how competitors fail

For each competitor whose failure modes are publicly documented (post-mortems, status pages, conference talks), note what their failure mode looks like at the user's target scale. This is often more honest than what they highlight in their architecture talks.

| Competitor | Documented failure | Source (tier) | Relevance to us |
|---|---|---|---|
| {{name}} | {{e.g. "Region-wide outage when shared cache failed - Mar 2024 post-mortem"}} | {{URL}} ({{tier}}) | {{e.g. "We use the same cache pattern - same risk applies"}} |
| {{...}} | | | |
