---
name: project-optimizer
description: Use when the user has a software project and asks for technical improvements - optimization, performance, scalability, architecture review, competitor comparison, or "how to make this better". Auto-tiers from light to deep research based on project complexity. Activates on phrases like "optimize this", "make it faster", "what do competitors do", "production-grade review", "outperform competitors", "deep technical research". Strictly technical scope.
---

# project-optimizer

A tiered, source-cited technical research workflow. Inspects the user's project, researches competitors and prior art, and produces an improvement report calibrated to project complexity.

## Scope

In scope: performance, architecture, algorithms, data structures, tech-stack choices, scalability, code quality, tooling, infrastructure, build/deploy, observability, testing strategy.

Out of scope: UX, visual design, product strategy, marketing, pricing, hiring, fundraising, business model. If the user asks for any of those, say once that this skill is technical-only and continue with the technical analysis.

## Activation rules

Activate when the user:
- Asks to "optimize", "improve", "make faster", "scale", "harden", "modernize", or "outperform" their project.
- Asks how competitors or similar tools solve the same problem.
- Asks "what's the best way to architect / structure / implement X" with an existing project in scope.
- Shares a repo or directory and asks for technical critique or improvement ideas.
- Says "production-grade review", "deep technical research", or "thorough analysis".

Do NOT activate for:
- Single-function bug fixes.
- Knowledge questions with no project attached.
- Greenfield design (no existing code to inspect).
- Style, formatting, or linting questions.
- Adding a single feature.

Lean toward false negatives. The user can always invoke explicitly.

## Tier auto-detection

Run `bash scripts/complexity-detect.sh <project-root>` for a suggested tier. Then apply these rules:

- **Tier 1 (Light):** < 2k LOC, single service, no distributed components.
- **Tier 2 (Standard):** 2k-20k LOC, OR multiple modules, OR a database in the stack.
- **Tier 3 (Deep):** > 20k LOC, OR microservices, OR distributed-system markers (queues, caches, multiple DBs, k8s/orchestration), OR the user explicitly says "deep", "complex", "thorough", "production-grade", "outperform competitors".

User can force a tier: "run project-optimizer in deep mode" -> Tier 3, regardless of LOC.

State the detected tier in the first reply to the user. Tier 3 cannot start research until the Phase 0 interview is answered.

## Workflow

Run phases in order. Phase 0 only fires for Tier 3. Phases 2 and 3 run in parallel.

### Phase 0 - Constraints interview (Tier 3 only)

Before any research, ask the user 3-5 sharp questions from `references/interview-questions.md`. Do not proceed until answered. The answers shape every later recommendation.

If the user refuses to answer or says "go without it", proceed but mark every recommendation that depended on a missing answer as "assumption-based - validate before acting".

### Phase 1 - Project Inspection

1. Run `bash scripts/stack-detect.sh <project-root>` for a stack hint.
2. Read entry points (main.py, index.ts, cmd/*, app/, src/) and top-level config (package.json, pyproject.toml, Cargo.toml, go.mod, Dockerfile, compose files, infra/, terraform/, k8s/).
3. Map architecture: entry points, primary data flow, key modules, external services, datastores, queues, caches.
4. Read enough source to identify real weak points. Examples: N+1 queries, blocking I/O on hot paths, unbounded queues, single-process design, no cache layer, synchronous calls to slow externals, missing indexes, no connection pooling, inefficient algorithms with obvious alternatives. Cite `file:line` for every claim.
5. For **Tier 3**: decompose the project into 3-8 named, bounded subsystems (e.g. ingestion, storage, query, scheduling, billing). For each: entry points, data flow, key dependencies, current weak points with `file:line`.
6. Produce a "Project Snapshot" (always) and a "Subsystem Map" (Tier 3) in working notes.

Do:
- Read code. Quote `file:line` for every claim about the project.
- Note unknowns explicitly ("no load-test data available").

Don't:
- Guess at runtime behavior without evidence.
- Write the report yet.
- Proceed past Phase 1 until the snapshot (and subsystem map for Tier 3) are complete.

### Phase 2 - Multi-pass Competitor Research

For Tier 3, run this per subsystem. For Tier 1/2, run once for the whole project.

**Pass 1 - Discovery:** identify 5-10 competitors / alternatives. Direct = same product category. Adjacent = same underlying technical problem. Web-search for engineering content: blogs, talks, papers, repos. Build a candidate source list.

**Pass 2 - Deep read:** for each high-value source, read fully. Extract specifics: numbers, architecture diagrams, trade-offs, things the authors regretted. Follow citations from sources to deeper sources.

**Pass 3 - Cross-validation:** every load-bearing finding must be confirmed by >=2 independent sources or flagged "single-source / unconfirmed". Surface conflicting claims explicitly - do not paper over them.

Rules:
- Marketing pages are not sources. Skip anything without technical detail.
- Do not infer architecture from feature lists.
- If a competitor's internals are not public, write "internals not public" - never fabricate.

See `references/research-sources.md` for curated starting points per domain.

### Phase 3 - Fallback Research (parallel with Phase 2)

- arXiv / Google Scholar for relevant techniques. Filter to last 5 years unless the paper is foundational.
- Top-starred GitHub repos in the problem space. Read README, ARCHITECTURE.md, recent issues, recent PRs.
- Official docs of the underlying tech - especially perf / scalability / anti-pattern sections.
- Conference talks. Domain matters: KubeCon and SREcon for infra, QCon and Strange Loop for general, USENIX (ATC, OSDI) and SOSP for systems, NeurIPS / MLSys for ML.

Every finding: capture source URL, one-line summary, why it applies to this project.

### Phase 4 - Source quality scoring

Tag every source you cite with a quality tier per `references/source-quality-rubric.md`:

- **S** - primary docs, peer-reviewed papers, official benchmarks.
- **A** - first-party engineering blogs from companies operating at scale.
- **B** - talks from named engineers, well-known OSS maintainers.
- **C** - reputable community sources, well-cited technical articles.
- **D** - unranked, single contributor, no track record.

A recommendation cannot rest on D-tier sources alone. It needs at least one S/A/B citation or it gets flagged "low confidence".

### Phase 5 - Quantitative grounding

Every performance claim attaches a number where possible:
- Latency (p50, p99).
- Throughput (req/s, rows/s, msgs/s).
- Memory / CPU.
- Big-O for algorithmic changes.
- Cost delta ($/month at given scale).

If no number is available, mark the claim **qualitative** in the report. Do not bury this. Do not fabricate numbers. If you compute an estimate, show the math inline.

### Phase 6 - Failure mode + scale analysis

Per subsystem (Tier 3) or for the system as a whole (Tier 1/2), answer:
- What breaks first at 10x current load?
- At 100x?
- At 1000x?
- What is the failure mode (slow, errors, data loss, cascading)?
- What do competitors do at that scale, and which source says so?

Output goes into `failure-modes.md` (Tier 3) or a "Scale analysis" section in the single report (Tier 1/2).

### Phase 7 - Synthesis: recommendations

Each recommendation has:
- **What to change** - specific files / modules / libraries.
- **Why** - cited sources with quality tier.
- **Quantitative impact** - numbers from research, or "qualitative" if none.
- **Effort** - dev-weeks estimate.
- **Infra cost delta** - $/month, with assumed scale.
- **Risk** - what could go wrong, migration hazards.
- **Concrete next step** - benchmark to run, spike to do, library to evaluate.
- **Confidence** - **high** (cross-validated S/A sources), **medium** (A/B sources), **low** (single-source or D-tier).

Rank by `(impact x confidence) / (effort x risk)`. Highest first.

### Phase 8 - Future-watch

- What is emerging in this space in the last ~12 months?
- What is getting deprecated?
- Where is the field heading in 2-3 years?
- What should the team track but not act on yet?

Goes into `future-watch.md` (Tier 3) or a short "Future watch" section (Tier 1/2).

### Phase 9 - Output

Save files into the project root the user pointed at, not the skill directory.

**Tier 1 output:**
- `OPTIMIZATION_REPORT.md` - filled from `references/report-templates/OPTIMIZATION_REPORT.md`.
- Chat summary (<= 15 lines): top 3 recs + report path.

**Tier 2 output:**
- `OPTIMIZATION_REPORT.md`
- `bibliography.md` (filled from `references/report-templates/bibliography.md`)
- Chat summary (<= 15 lines).

**Tier 3 output:**
```
optimization/
├── EXECUTIVE_REPORT.md       # TL;DR, scoreboard, top 10 recs, key risks
├── subsystems/
│   ├── <subsystem-1>.md      # one file per subsystem from the map
│   └── ...
├── bibliography.md           # every source, with quality tier + relevance note
├── risk-register.md          # all risks across all recs, ranked
├── failure-modes.md          # what breaks at 10x / 100x / 1000x
├── future-watch.md           # emerging tech, deprecation watch
└── benchmarks/
    ├── README.md             # how to run these
    └── <runnable scripts>    # one per high-impact recommendation
```

For Tier 3, generate at least one runnable benchmark script per high-impact recommendation. Use `scripts/benchmark-skeleton/` as starting points. Each benchmark must be executable as-is, with clear `# TODO` markers where the user must plug in their environment.

Chat summary for Tier 3 (<= 20 lines): top 5 findings, must-do-this-quarter list, path to `optimization/`.

## Hard rules

- No uncited claims. Ever.
- No fabricated benchmarks. If a number is not sourced, write "estimated" and show the math.
- If the project is in a domain you are not strong in (niche embedded targets, obscure DSLs, hardware-specific code, etc.), declare it up front in the report. Do not bluff.
- No padding. Every section earns its place. Delete empty sections rather than filling with filler.
- No emojis in any output file.
- For Tier 3, at least one runnable benchmark per high-impact recommendation.
- Recommendations are ranked by `(impact x confidence) / (effort x risk)`, never alphabetically or by category.
- No business, UX, or marketing recommendations. If you write one, delete it.
- Do not collapse Tier 3 into a single file even if the project is "small for Tier 3". The multi-file structure is the deliverable.

## Files in this skill

- `SKILL.md` - this file.
- `references/research-sources.md` - curated search starting points per domain.
- `references/source-quality-rubric.md` - exact S/A/B/C/D scoring rules.
- `references/interview-questions.md` - Phase 0 constraints interview.
- `references/report-templates/` - one template per output file.
- `scripts/stack-detect.sh` - stack and LOC first pass.
- `scripts/complexity-detect.sh` - LOC, module count, distributed markers -> suggested tier.
- `scripts/benchmark-skeleton/` - starter templates for HTTP, DB, and micro-benchmarks.
- `README.md` - install and usage notes for humans.
