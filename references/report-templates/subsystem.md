# Subsystem deep-dive: {{SUBSYSTEM_NAME}}

Chat-output layout for one subsystem in a Tier 3 report. Render as an H2/H3 section in the chat response - do NOT save as a file. Reference other sections ("see the Risk Register section") by name, not by path.

## Role

{{One sentence: what this subsystem is responsible for, and why it exists as a distinct subsystem.}}

## Boundaries

- **Owns:** {{data, responsibilities this subsystem owns exclusively}}
- **Depends on:** {{other subsystems, external services, datastores}}
- **Consumed by:** {{who calls into this subsystem}}
- **Entry points:** `{{file:line}}`, `{{file:line}}`, ...

## Current architecture

{{2-5 sentences: data flow, key modules, where state lives, sync vs async boundaries. ASCII diagram if it helps. Reference `file:line` for every structural claim.}}

```
{{optional ASCII diagram}}
```

## Current behavior under load

- **Hot paths:** `{{file:line}}` - {{why it's hot}}
- **Synchronization points / locks:** `{{file:line}}` - {{...}}
- **Bounded vs unbounded:** {{queues, caches, pools}}
- **Backpressure handling:** {{present / absent / file:line}}
- **Retries / timeouts:** {{configured at file:line, or "missing"}}

If load-test or production data is available, summarize it here. Otherwise: "no observed runtime data - all claims are from reading source".

## Weak points (from code, not guess)

- `{{file:line}}` - {{specific weak point}}. {{Why it matters.}}
- `{{file:line}}` - {{...}}

## How competitors / adjacent tools handle this

One row per competitor whose approach to this subsystem is informative. Flag vendor-authored sources.

| Competitor | Approach to this subsystem | Delta vs. ours | What's better | Source (tier) |
|---|---|---|---|---|
| {{name}} | {{...}} | {{...}} | {{...}} | {{URL}} ({{S/A/B/C/D}}) |
| {{...}} | | | | |

## Relevant prior art

- **{{title}}** ({{paper / repo / docs}}, tier {{S/A/B/C/D}}) - {{one-line summary}}. Relevant because: {{why}}. Source: {{URL}}
- {{...}}

## Failure modes at scale

- **10x load:** {{what breaks first in this subsystem, failure mode}}
- **100x load:** {{...}}
- **1000x load:** {{...}}

## Recommendations (subsystem-scoped)

Ordered by `(impact x confidence) / (effort x risk)`. If no change is warranted, say so.

### S{{N}}-R1. {{short title}}
- **What to change:** {{specific change with file/module pointers}}
- **Why:** {{rationale, citing sources above with tier}}
- **Counter-argument considered:** {{strongest case against, and why the rec survives it}}
- **Quantitative impact:** {{number with units, or "qualitative"}}
- **Effort:** {{dev-weeks}}
- **Cost delta:** {{$/month at assumed scale, or "negligible"}}
- **Risk:** {{migration hazards}} (cross-referenced in the Risk Register section)
- **Confidence:** {{high / medium / low}}
- **Ranking inputs:** impact={{H/M/L}}, confidence={{H/M/L}}, effort={{H/M/L}}, risk={{H/M/L}} -> score {{value}}
- **Benchmark to verify:** include the runnable script inline as a code block (adapt `scripts/benchmark-skeleton/`)
- **Next step:** {{...}}

### S{{N}}-R2. {{short title}}
{{...}}

## Open questions

- {{things research could not answer about this subsystem}}
- {{e.g. "{{technique X}} looks promising but I found no numbers - benchmark before committing"}}
