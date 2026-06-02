# Risk Register

Chat-output layout - render as a section in the chat response, not a saved file. All risks surfaced across all recommendations, ranked by `severity x likelihood`. Each entry names the recommendation(s) it affects.

## Scoring

- **Severity:** Critical (data loss, prolonged outage, security breach) / High (significant degradation) / Medium (degraded UX, costly rollback) / Low (minor inconvenience).
- **Likelihood:** High / Medium / Low.
- **Score:** severity x likelihood, used for ranking. Critical x High at the top, Low x Low at the bottom.

## Register

| ID | Risk | Affects | Severity | Likelihood | Score | Mitigation | Owner |
|---|---|---|---|---|---|---|---|
| R01 | {{one-line description}} | {{rec IDs, e.g. EXEC-R1, S2-R3}} | {{Critical/High/Med/Low}} | {{High/Med/Low}} | {{score}} | {{one-line mitigation}} | {{team/role, or "unassigned"}} |
| R02 | {{...}} | | | | | | |

## Top 5, in detail

The five highest-scoring risks, expanded.

### R{{ID}}. {{title}}
- **What goes wrong:** {{specific failure scenario}}
- **Trigger:** {{what causes it to happen}}
- **Blast radius:** {{who/what is affected and how badly}}
- **Mitigation:** {{specific steps - feature flag, gradual rollout, dual-write, backup, etc.}}
- **Validation:** {{how to confirm mitigation works - e.g. "run benchmark X and confirm Y", "test in staging with shadow traffic"}}
- **Rollback plan:** {{exact steps to revert}}
- **Linked to:** {{rec IDs}}

{{repeat for top 5}}

## Cross-cutting risks

Risks that apply across multiple subsystems or recommendations, not specific to any one.

- **{{title}}** - {{e.g. "Lack of observability means we can't measure impact of any recommendation"}}. Affects: {{all recs that require measurement}}. Resolution: {{must-do prerequisite}}.
- {{...}}

## Risks accepted

Risks the user has explicitly chosen to accept (or the team has historically accepted). Recorded so future passes know not to re-raise them.

- {{title}} - accepted because {{reason}}. Revisit if {{trigger}}.
- {{...}}
