# Subsystem: {{SUBSYSTEM_NAME}}

_Part of the project-optimizer Tier 3 report. See [EXECUTIVE_REPORT.md](../EXECUTIVE_REPORT.md) for the top-level view._

## 1. Role

{{One sentence on what this subsystem is responsible for, and why it exists as a distinct subsystem.}}

## 2. Boundaries

- **Owns:** {{data, responsibilities this subsystem owns exclusively}}
- **Depends on:** {{other subsystems, external services, datastores}}
- **Consumed by:** {{who calls into this subsystem}}
- **Entry points:** `{{file:line}}`, `{{file:line}}`, ...

## 3. Current architecture

{{2-5 sentences. Data flow through the subsystem, key modules, where state lives, sync vs async boundaries. Diagram in ASCII or mermaid if it helps. Reference `file:line` for every structural claim.}}

```
{{optional ASCII diagram}}
```

## 4. Current behavior under load

What you can observe from the code:
- **Hot paths:** `{{file:line}}` - {{why it's hot}}
- **Synchronization points / locks:** `{{file:line}}` - {{...}}
- **Bounded vs unbounded:** {{queues, caches, pools}}
- **Backpressure handling:** {{present / absent / file:line}}
- **Retries / timeouts:** {{configured at file:line, or "missing"}}

If load-test or production-metrics data is available, attach it here. Otherwise: "no observed runtime data - all claims are from reading source".

## 5. Weak points (from code, not guess)

- `{{file:line}}` - {{specific weak point}}. {{Why it matters.}}
- `{{file:line}}` - {{...}}

## 6. How competitors / adjacent tools handle this

Per Phase 2. One row per competitor whose approach to this subsystem is informative.

| Competitor | Approach to this subsystem | Delta vs. ours | What's better | Source (tier) |
|---|---|---|---|---|
| {{name}} | {{...}} | {{...}} | {{...}} | {{URL}} ({{S/A/B/C/D}}) |
| {{...}} | | | | |

## 7. Relevant prior art

Per Phase 3, scoped to this subsystem.

- **{{title}}** ({{paper / repo / docs}}, tier {{S/A/B/C/D}}) - {{one-line summary}}. Relevant because: {{why}}. Source: {{URL}}
- {{...}}

## 8. Failure modes at scale

Refers to [failure-modes.md](../failure-modes.md). Subsystem-specific notes:

- **10x load:** {{what breaks first in this subsystem, failure mode}}
- **100x load:** {{...}}
- **1000x load:** {{...}}

## 9. Recommendations (subsystem-scoped)

Ordered by `(impact x confidence) / (effort x risk)`. Recommendations that span subsystems live in [EXECUTIVE_REPORT.md](../EXECUTIVE_REPORT.md).

### S{{N}}-R1. {{short title}}
- **What to change:** {{specific change with file/module pointers}}
- **Why:** {{rationale, citing sources from sections 6 or 7 with tier}}
- **Quantitative impact:** {{number with units, or "qualitative"}}
- **Effort:** {{dev-weeks}}
- **Cost delta:** {{$/month at assumed scale, or "negligible"}}
- **Risk:** {{migration hazards}} (see [risk-register.md](../risk-register.md) row {{id}})
- **Confidence:** {{high / medium / low}}
- **Benchmark to verify:** `benchmarks/{{script-name}}` (see [benchmarks/README.md](../benchmarks/README.md))
- **Next step:** {{...}}

### S{{N}}-R2. {{short title}}
{{...}}

{{repeat per subsystem - typically 3-8 recommendations}}

## 10. Open questions

- {{things research could not answer about this subsystem}}
- {{If applicable: "{{technique X}} appears promising but I could not find numbers - benchmark before committing"}}
