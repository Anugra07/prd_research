# project-optimizer

A tiered, source-cited, bias-checked **technical** research skill for Claude Code. It inspects the user's project, researches competitors and prior art, and presents a ranked improvement report **directly in the chat**.

Strictly technical. No business advice, no UX opinions, no marketing. Only performance, architecture, algorithms, stack choices, scalability, code quality, tooling, infrastructure.

**It does not write files into your project.** Every finding is returned in the chat. The only file it ever writes is its own `MEMORY.md`, inside the skill's install directory - see [Learning across sessions](#learning-across-sessions).

## The three tiers

The skill auto-detects which tier to run via `scripts/complexity-detect.sh`. The user can force a tier by saying "run project-optimizer in deep mode". Every tier outputs to the chat - the deeper the tier, the more sections.

| Tier | Trigger | Chat output |
|---|---|---|
| **1 - Light** | < 2k LOC, single service, no distributed components | TL;DR + Snapshot + Landscape + Findings + Scale + ranked Recommendations + Future Watch + Open Questions |
| **2 - Standard** | 2k-20k LOC, OR multiple modules, OR a database | Everything in Tier 1, plus a Bibliography section |
| **3 - Deep** | > 20k LOC, OR microservices, OR distributed markers (queues, caches, k8s), OR user requests "deep/thorough/production-grade" | Full multi-section report (see below), with runnable benchmarks shown inline as code blocks |

## Tier 3 chat report (sections, not files)

The deep tier renders one long structured report in the chat with these H2 sections, in order:

```
TL;DR + Scoreboard + Top 10 recommendations
Constraints (from the Phase 0 interview)
Project Snapshot + Subsystem Map
Per-subsystem deep dive  (one section each)
Competitive Landscape
Research Findings
Failure Modes at 10x / 100x / 1000x
Risk Register
Recommendations  (ranked across all subsystems, with audit values)
Future Watch
Bibliography  (every source, S/A/B/C/D tier, vendor sources flagged)
Open Questions
```

Each high-impact recommendation includes a runnable benchmark as an inline, copy-pasteable code block. Nothing is written to disk. After the report, the skill offers to save it to a file only if you ask.

## Install

One-liner (no git required - downloads a tarball and places it in `~/.claude/skills/project-optimizer`):

```bash
curl -fsSL https://raw.githubusercontent.com/Anugra07/prd_research/main/install.sh | bash
```

Or, if you prefer git:

```bash
git clone https://github.com/Anugra07/prd_research.git ~/.claude/skills/project-optimizer
```

Claude Code picks up skills under `~/.claude/skills/` automatically.

### Installer options

The installer takes env vars:

- `SKILL_DIR` - install location. Default: `~/.claude/skills/project-optimizer`.
- `SKILL_REF` - git ref to download. Default: `main`.
- `SKILL_FORCE=1` - overwrite an existing install without backing it up.
- `SKIP_DEPS=1` - skip the optional-dependency check.

Example: install into a custom path without the dep check:

```bash
SKILL_DIR=~/skills/po SKIP_DEPS=1 curl -fsSL https://raw.githubusercontent.com/Anugra07/prd_research/main/install.sh | bash
```

To update later, re-run the same install command. The previous install is backed up (unless `SKILL_FORCE=1`) to `~/.claude/project-optimizer-backups/` - deliberately outside `~/.claude/skills/` so the backup is never loaded as a duplicate skill. Your `MEMORY.md` is carried forward automatically.

## How to trigger it

Open Claude Code inside (or pointed at) the project you want analyzed and say something like:

- **Tier 1:** "Quick optimization pass on this script."
- **Tier 2:** "How can I make this service faster?" / "What should I improve here?"
- **Tier 3:** "Deep technical review." / "What do competitors do, and how can we outperform them?" / "Production-grade review of this system."

The skill leans toward false negatives - if it doesn't activate, invoke explicitly with "run project-optimizer".

## Learning across sessions

A skill can't retrain a model, so "learning" here is honest, inspectable note-keeping. The skill keeps a `MEMORY.md` in its own install directory (typically `~/.claude/skills/project-optimizer/MEMORY.md`, seeded from `references/MEMORY.template.md` on first run). It:

- **reads** it at the start of every run and applies relevant learnings (your preferred effort unit, stack you can't change, recommendation types you've rejected, sources that proved unreliable), telling you in one line what it applied;
- **appends** durable, generalizable learnings at the end of every run, telling you in one line what it saved.

It stores preferences and corrections, never secrets, credentials, or your code. The file is local-only (git-ignored), survives reinstalls (the installer carries it forward), and you can edit it by hand or say "forget that" to drop an entry.

## Staying unbiased

The report is only useful if it's honest, so the skill runs explicit bias guards: it down-weights and flags vendor-authored sources, actively hunts for failure stories and "why we migrated off X" posts (not just success blogs), writes the strongest counter-argument for every recommendation before keeping it, and treats "the current approach is already appropriate" as a valid result rather than manufacturing changes. Recommendations are ranked strictly by `(impact x confidence) / (effort x risk)`, and the four input values are shown so you can audit the ordering yourself.

## Workflow (Tier 3)

The full pipeline:

0. **Constraints interview** - 3-5 sharp questions about scale, latency budget, team, infra, non-negotiables.
1. **Project inspection** - stack-detect, subsystem decomposition, weak points with `file:line` citations.
2. **Multi-pass competitor research** - discovery, deep read, cross-validation. Per subsystem.
3. **Fallback research** (in parallel) - arXiv, top-starred repos, official perf docs, conference talks.
4. **Source quality scoring** - every source tagged S/A/B/C/D. D-only recs flagged "low confidence".
5. **Quantitative grounding** - every perf claim has a number, or is explicitly marked "qualitative".
6. **Failure mode + scale analysis** - what breaks at 10x / 100x / 1000x, what competitors do at that scale.
7. **Synthesis** - recommendations ranked by `(impact x confidence) / (effort x risk)`.
8. **Future-watch** - emerging tech, deprecation watch.
9. **Output** - the full report rendered in the chat (sections above), with runnable benchmarks inline as code blocks. No files written to your project.

Bookending the pipeline: read `MEMORY.md` before Phase 1, append learnings after Phase 9. Tiers 1 and 2 run an abbreviated version of this pipeline and produce a shorter chat report.

## Hard rules

- **No uncited claims.** Every recommendation cites at least one source from Phase 2 or 3.
- **No fabricated benchmarks.** If a number isn't sourced, it's marked "estimated" with the math shown.
- **No bluffing.** If the project is in a domain Claude isn't strong in, that's stated up front in the report.
- **No files in your project.** All findings go to the chat; the only file written is the skill's own `MEMORY.md`.
- **Auditable, unbiased ranking.** Bias guards applied; the four ranking inputs are shown; "no change needed" is a valid result.
- **No emojis** in any output.
- **For Tier 3:** at least one runnable benchmark (inline code block) per high-impact recommendation.

## File tree (this repo)

```
project-optimizer/
├── SKILL.md                                  # workflow Claude follows
├── README.md                                 # this file
├── .gitignore
├── install.sh                               # no-git tarball installer (preserves MEMORY.md)
├── references/
│   ├── MEMORY.template.md                    # seed for the per-user learning file
│   ├── research-sources.md                   # curated search starting points per domain
│   ├── source-quality-rubric.md              # S/A/B/C/D scoring rules
│   ├── interview-questions.md                # Phase 0 question bank
│   └── report-templates/                     # chat-section layout guides (not files to save)
│       ├── OPTIMIZATION_REPORT.md            # Tier 1/2 chat layout
│       ├── EXECUTIVE_REPORT.md               # Tier 3 top-of-report layout
│       ├── subsystem.md                      # Tier 3 per-subsystem section
│       ├── bibliography.md                   # Tier 3 sources section
│       ├── risk-register.md                  # Tier 3 risks section
│       ├── failure-modes.md                  # Tier 3 scale-analysis section
│       └── future-watch.md                   # Tier 3 horizon-scan section
└── scripts/
    ├── stack-detect.sh                       # stack and LOC first pass
    ├── complexity-detect.sh                  # suggests Tier 1 / 2 / 3
    └── benchmark-skeleton/
        ├── README.md
        ├── http-bench.sh                     # wrk-driven HTTP benchmark
        ├── db-bench.sh                       # psql-driven query benchmark
        ├── micro-bench.py                    # Python algorithmic micro-bench
        └── micro-bench.js                    # Node.js algorithmic micro-bench
```
