# Bibliography

Chat-output layout - render as a section in the chat response, not a saved file. Every source cited anywhere in the report, with quality tier and relevance note.

## Tier legend

- **S** - Primary docs, peer-reviewed papers, official benchmarks.
- **A** - First-party engineering blogs from companies at scale.
- **B** - Talks from named engineers, well-known OSS maintainers, recognized expert blogs.
- **C** - Reputable community sources, well-cited articles.
- **D** - Unranked / single contributor / no track record.

Full tiering rules are in the skill's `references/source-quality-rubric.md`. Flag any vendor-authored source in the relevance column regardless of tier.

## Sources

| ID | Title | Author / Org | Year | Tier | Used in | Cross-validated by | Relevance |
|---|---|---|---|---|---|---|---|
| B01 | {{title}} | {{author}} | {{year}} | {{S/A/B/C/D}} | {{EXECUTIVE_REPORT / subsystems/X / failure-modes / etc.}} | {{B0N, B0M}} or "single-source" | {{one line on why it's cited}} |
| B02 | {{...}} | | | | | | |

URLs (out of the table to avoid line-wrapping):

- **B01** - {{URL}}
- **B02** - {{URL}}
- {{...}}

## Conflicts

When two sources disagree on a load-bearing claim, log the conflict here. The recommendation that depends on the claim must surface the conflict in its "Why" section.

- **Conflict 1:** {{topic, e.g. "Optimal shard count for use case Y"}}
  - {{B0N}} says {{X}}.
  - {{B0M}} says {{Y}}.
  - **Reconciliation:** {{which we believe and why, or "unresolved - flagged in recommendation R{{n}}"}}

## Scale-mismatch notes

Sources where the author operates at a scale far above (or below) the user's. The pattern may not transfer.

- **{{B0N}}** - author operates at {{their scale}}. User operates at {{user scale}}. Pattern referenced in {{rec ID}} should be evaluated, not adopted wholesale.
- {{...}}

## Recency notes

Sources older than 5 years in fast-moving areas. Confirm still current before relying on them.

- **{{B0N}}** ({{year}}) - {{area, e.g. "LLM serving"}}. Confirm the conclusion still holds against {{newer source if found}}.
- {{...}}

## Sources considered and rejected

Sources that came up in search but were excluded. Brief reason each. Keeps the next pass from re-treading the same dead ends.

- {{URL}} - {{rejected because: marketing / no technical depth / D-tier and contradicted by S-tier source / etc.}}
- {{...}}
