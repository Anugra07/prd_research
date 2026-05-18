# Phase 0 - Constraints Interview

Run for Tier 3 only. Ask 3-5 of these, picked for relevance to what you saw in the user's project. Do not start research until they're answered.

If the user says "go without it" or "skip the interview", proceed but mark every recommendation that hinges on a missing answer as **assumption-based - validate before acting** in the report.

## The bank

Pick from this list. Reword to match the project. Do not ask all 10 - pick the 3-5 most load-bearing.

### Scale (almost always ask)
1. **Current scale.** Roughly how many users, requests/sec, or rows/events per day does this handle today?
2. **Target scale.** Where do you need to be in 6-12 months? 10x current? 100x?

### Latency / SLO
3. **Latency budget.** Do you have p50 / p99 latency targets, or is "fast enough" enough? Where do you feel pain today?
4. **Availability target.** Is this a "best effort" service, 99.9%, 99.99%? Is there a public SLO?

### Team
5. **Team size and skill profile.** How many engineers will work on this, and what are they strongest in (e.g. "3 engineers, all strong in Python, one knows Rust, no one knows Kubernetes")?

### Infra constraints
6. **Cloud / on-prem / hybrid.** Where does this run, and are you locked in? Any cloud you can't use?
7. **Budget.** Rough infra budget per month, and is the constraint "cheap" or "fast"?

### Non-negotiables
8. **Stack constraints.** Anything that has to stay (language, framework, DB, vendor)? Why?
9. **Compliance / data residency.** SOC2, HIPAA, GDPR data-residency, FedRAMP? Anything that vetoes a popular option?

### Pain / priorities
10. **What hurts today.** What is the single thing about this system that is most painful for you or your users right now?

## How to use the answers

- **Current vs. target scale** sets the failure-mode horizon in Phase 6 (10x / 100x / 1000x).
- **Latency budget** filters out recommendations that trade latency for throughput (or vice versa).
- **Team size / skill** weights the Effort score. A 3-week migration is different for a 3-engineer team than a 30-engineer team. Stack proficiency also weights the Risk score.
- **Infra constraints + budget** filter the solution space. Don't recommend a managed Spanner cluster to a team on a $200/mo Hetzner box.
- **Non-negotiables** are hard filters. A recommendation that violates a non-negotiable must either be omitted or labeled "requires lifting constraint X".
- **Pain points** become Phase 7's tie-breakers. When two recommendations score the same on `(impact x confidence) / (effort x risk)`, prefer the one that addresses the user's stated pain.

## What to do if the user gives a vague answer

- "Quite a lot" / "fast" / "soon" -> push once for a number ("ballpark order of magnitude is fine - 100 rps, 10k rps, 1M rps?"). If they still can't, write the assumed range into the report and proceed.
- "Whatever's standard" for compliance -> assume none, but call this out as an assumption.
- "We don't know" for current scale -> recommend adding observability as a Phase 1 prerequisite recommendation.
