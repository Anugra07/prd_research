# project-optimizer

A tiered, source-cited, bias-checked research skill for Claude Code that makes a software product better - **technically, as a business in its market, or both**. It inspects the product, researches competitors and prior art, and presents a ranked improvement report **directly in the chat**.

**It does not write files into your project.** Every finding is returned in the chat. The only file it ever writes is its own `MEMORY.md`, inside the skill's install directory - see [Learning across sessions](#learning-across-sessions).

## Modes

The skill picks a mode from your request (or you can force one):

| Mode | Covers | Trigger examples |
|---|---|---|
| **technical** | performance, architecture, algorithms, stack, scalability, infra, tooling, code quality | "optimize this", "make it faster", "scale this", "production-grade review", "how do competitors do this technically" |
| **business** | product value & UVP, market & competitive positioning, where you stand, growth levers, expansion strategy | "what's our UVP", "how do we position", "where do we stand in the market", "how do we grow", "how do we differentiate", "how do we expand" |
| **full** | both tracks, plus a unified ranked roadmap showing how tech enables business and vice versa | "understand my product technically and commercially", "take it to the next level" |

Force a mode with "run project-optimizer in business mode" (or technical / full). When a request clearly spans both, it defaults to **full**. The tier system below controls research depth in whichever mode runs.

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

- **Technical:** "Quick optimization pass on this script." / "How can I make this service faster?" / "Deep, production-grade technical review."
- **Business:** "What's our UVP and where do we stand in the market?" / "How do we differentiate and grow?" / "What are our expansion options?"
- **Full:** "Understand my product technically and commercially, then tell me how to take it to the next level."

The skill leans toward false negatives - if it doesn't activate, invoke explicitly with "run project-optimizer" (optionally naming a mode and tier, e.g. "run project-optimizer in full deep mode").

## Learning across sessions

A skill can't retrain a model, so "learning" here is honest, inspectable note-keeping. The skill keeps a `MEMORY.md` in its own install directory (typically `~/.claude/skills/project-optimizer/MEMORY.md`, seeded from `references/MEMORY.template.md` on first run). It:

- **reads** it at the start of every run and applies relevant learnings (your preferred effort unit, stack you can't change, recommendation types you've rejected, sources that proved unreliable), telling you in one line what it applied;
- **appends** durable, generalizable learnings at the end of every run, telling you in one line what it saved.

It stores preferences and corrections, never secrets, credentials, or your code. The file is local-only (git-ignored), survives reinstalls (the installer carries it forward), and you can edit it by hand or say "forget that" to drop an entry.

## Staying unbiased

The report is only useful if it's honest, so the skill runs explicit bias guards: it down-weights and flags vendor/marketing sources, actively hunts for failure stories and "why we migrated off X" posts (not just success blogs), writes the strongest counter-argument for every recommendation before keeping it, and treats "the current approach/position is already strong" as a valid result rather than manufacturing changes. In business mode it additionally refuses top-down market sizes without a bottom-up check (every market figure is labeled "estimated" with its method), prefers revenue/retention over vanity metrics, and tells you plainly when a UVP is weak or undifferentiated. Recommendations are ranked strictly by `(impact x confidence) / (effort x risk)`, with the four input values shown so you can audit the ordering yourself.

## Workflow

After a Phase 0 constraints interview (deeper at Tier 3, and always in business/full mode), the skill runs the track(s) for the detected mode, then synthesizes.

**Technical track:** project inspection (stack-detect, subsystem decomposition, weak points with `file:line`) -> multi-pass competitor research (discovery, deep read, cross-validation) -> fallback research (arXiv, top repos, official perf docs, talks) in parallel -> source quality scoring (S/A/B/C/D) -> quantitative grounding (numbers or "qualitative") -> failure-mode/scale analysis (10x/100x/1000x) -> ranked recommendations -> technical future-watch.

**Business track:** product & value understanding (job-to-be-done, segment, business model, UVP hypothesis) -> market & competitive positioning (incl. the "do nothing" alternative; a positioning map; an honest "where we stand") -> UVP analysis (is the differentiator real and defensible; the sharpest wedge; the gap to best-in-category) -> growth levers (acquisition/activation/retention/monetization, tied to evidence) -> expansion strategy (segments, geos, product lines, platform, partnerships; sequenced now/next/later) -> ranked strategic recommendations.

**Full mode** runs both and adds a **unified ranked roadmap** tagging each item `[Technical]` / `[Business]` / `[Both]` and calling out cross-track dependencies (e.g. "the p99 fix is a prerequisite for the enterprise segment").

Everything is ranked by `(impact x confidence) / (effort x risk)` with inputs shown, rendered in the chat. Bookending the pipeline: read `MEMORY.md` at the start, append learnings at the end. Tiers 1 and 2 run shorter versions and produce a shorter chat report.

## Hard rules

- **No uncited claims**, technical or business. Every recommendation cites at least one source.
- **No fabricated numbers or benchmarks.** Unsourced figures are marked "estimated" with the math shown; market sizes are always "estimated" with their method.
- **No bluffing.** If the product is in a technical domain or a market Claude isn't strong in, that's stated up front.
- **No files in your project.** All findings go to the chat; the only file written is the skill's own `MEMORY.md`.
- **Auditable, unbiased ranking.** Bias guards applied; the four ranking inputs are shown; "no change needed / position already strong" is a valid result.
- **No emojis** in any output.
- **For Tier 3:** at least one runnable benchmark (inline code block) per high-impact technical recommendation, and one measurable experiment per high-impact business recommendation.

## File tree (this repo)

```
project-optimizer/
├── SKILL.md                                  # workflow Claude follows
├── README.md                                 # this file
├── .gitignore
├── install.sh                               # no-git tarball installer (preserves MEMORY.md)
├── references/
│   ├── MEMORY.template.md                    # seed for the per-user learning file
│   ├── interview-questions.md                # Phase 0 technical interview
│   ├── business-interview-questions.md       # Phase 0 business/market interview
│   ├── research-sources.md                   # technical search starting points per domain
│   ├── business-research-sources.md          # market/competitor intelligence sources
│   ├── source-quality-rubric.md              # S/A/B/C/D scoring rules (both tracks)
│   └── report-templates/                     # chat-section layout guides (not files to save)
│       ├── OPTIMIZATION_REPORT.md            # technical Tier 1/2 chat layout
│       ├── EXECUTIVE_REPORT.md               # technical Tier 3 top-of-report layout
│       ├── subsystem.md                      # technical Tier 3 per-subsystem section
│       ├── bibliography.md                   # sources section
│       ├── risk-register.md                  # technical Tier 3 risks section
│       ├── failure-modes.md                  # technical Tier 3 scale-analysis section
│       ├── future-watch.md                   # technical Tier 3 horizon-scan section
│       └── business-sections.md              # business-track chat layouts + unified roadmap
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
