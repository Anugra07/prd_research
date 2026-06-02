# project-optimizer - memory

Durable, auditable notes the skill keeps across runs to improve future analyses.

This file lives in the skill's install directory (typically `~/.claude/skills/project-optimizer/MEMORY.md`). It is NEVER placed inside a user's project. It is plain notes, not machine learning - the user can read or edit it freely. On first run the skill copies this template to `MEMORY.md`; from then on it reads it at the start of each run and appends learnings at the end.

What belongs here: stable user preferences, corrections the user made, recurring stack/domain facts about their work, and sources that proved reliable or unreliable.

What does NOT belong here: secrets, credentials, proprietary code, or one-off project details. One line per entry. Keep each section under ~15 entries; prune the oldest or least useful.

If the user says "forget that", delete the relevant entry.

---

## User preferences (observed)

<!-- e.g. "Wants effort estimated in ideal-days, not dev-weeks." -->
<!-- e.g. "Prefers boring, proven tech over cutting-edge." -->

## Stack / domain facts about this user's work

<!-- e.g. "Primary stack is Go + Postgres + NATS, deployed on Fly.io." -->
<!-- e.g. "Team cannot adopt Rust (no in-house expertise)." -->

## Corrections (where the analysis was wrong before)

<!-- e.g. "I flagged an N+1 in repo X; user showed it was batched at the ORM layer." -->

## Recommendations the user accepted / rejected

<!-- e.g. "Rejected microservice split twice - keep monolith-first recommendations." -->
<!-- e.g. "Adopted connection pooling suggestion; it helped." -->

## Source reliability adjustments

<!-- e.g. "Vendor benchmark from $COMPANY consistently overstated; down-weight." -->
<!-- e.g. "$ENGINEER's blog has been accurate and reproducible; trust as B+." -->

## Constraints that recur across the user's projects

<!-- e.g. "Always on a tight infra budget; favor cost-efficient options." -->
<!-- e.g. "Latency-sensitive: p99 targets matter more than throughput." -->
