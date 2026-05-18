# project-optimizer

A tiered, source-cited **technical** research skill for Claude Code. Inspect the user's project, research competitors and prior art, and produce an improvement report calibrated to the project's complexity.

Strictly technical. No business advice, no UX opinions, no marketing. Only performance, architecture, algorithms, stack choices, scalability, code quality, tooling, infrastructure.

## The three tiers

The skill auto-detects which tier to run via `scripts/complexity-detect.sh`. The user can force a tier by saying "run project-optimizer in deep mode".

| Tier | Trigger | Output |
|---|---|---|
| **1 - Light** | < 2k LOC, single service, no distributed components | `OPTIMIZATION_REPORT.md` + chat summary |
| **2 - Standard** | 2k-20k LOC, OR multiple modules, OR a database | `OPTIMIZATION_REPORT.md` + `bibliography.md` + chat summary |
| **3 - Deep** | > 20k LOC, OR microservices, OR distributed markers (queues, caches, k8s), OR user requests "deep/thorough/production-grade" | `optimization/` directory tree (see below) + runnable benchmarks + chat summary |

## Tier 3 output

```
optimization/
├── EXECUTIVE_REPORT.md       # TL;DR, scoreboard, top 10 recommendations, key risks
├── subsystems/
│   ├── <subsystem-1>.md      # deep dive per subsystem
│   └── ...
├── bibliography.md           # every source with quality tier (S/A/B/C/D) + relevance note
├── risk-register.md          # all risks across all recs, ranked
├── failure-modes.md          # what breaks at 10x / 100x / 1000x
├── future-watch.md           # emerging tech, deprecation watch
└── benchmarks/
    ├── README.md             # how to run these
    └── <runnable scripts>    # one per high-impact recommendation
```

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

To update later, re-run the same install command (the previous install is auto-backed-up unless `SKILL_FORCE=1`).

## How to trigger it

Open Claude Code inside (or pointed at) the project you want analyzed and say something like:

- **Tier 1:** "Quick optimization pass on this script."
- **Tier 2:** "How can I make this service faster?" / "What should I improve here?"
- **Tier 3:** "Deep technical review." / "What do competitors do, and how can we outperform them?" / "Production-grade review of this system."

The skill leans toward false negatives - if it doesn't activate, invoke explicitly with "run project-optimizer".

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
9. **Output** - the multi-file tree above + runnable benchmarks for high-impact recs.

Tiers 1 and 2 run an abbreviated version of this pipeline and produce a single (or two-file) report.

## Hard rules

- **No uncited claims.** Every recommendation cites at least one source from Phase 2 or 3.
- **No fabricated benchmarks.** If a number isn't sourced, it's marked "estimated" with the math shown.
- **No bluffing.** If the project is in a domain Claude isn't strong in, that's stated up front in the report.
- **No emojis** in any output file.
- **For Tier 3:** at least one runnable benchmark per high-impact recommendation.

## File tree (this repo)

```
project-optimizer/
├── SKILL.md                                  # workflow Claude follows
├── README.md                                 # this file
├── .gitignore
├── references/
│   ├── research-sources.md                   # curated search starting points per domain
│   ├── source-quality-rubric.md              # S/A/B/C/D scoring rules
│   ├── interview-questions.md                # Phase 0 question bank
│   └── report-templates/
│       ├── OPTIMIZATION_REPORT.md            # Tier 1/2 single-file template
│       ├── EXECUTIVE_REPORT.md               # Tier 3 top-level
│       ├── subsystem.md                      # Tier 3 per-subsystem
│       ├── bibliography.md                   # Tier 3 sources
│       ├── risk-register.md                  # Tier 3 risks
│       ├── failure-modes.md                  # Tier 3 scale analysis
│       └── future-watch.md                   # Tier 3 horizon scan
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
