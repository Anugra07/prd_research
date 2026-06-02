---
name: project-optimizer
description: Use when the user has a software project and asks for technical improvements - optimization, performance, scalability, architecture review, competitor comparison, or "how to make this better". Auto-tiers from light to deep research based on project complexity. Activates on phrases like "optimize this", "make it faster", "what do competitors do", "production-grade review", "outperform competitors", "deep technical research". Presents all findings directly in the chat - it does not write files into the user's project. Strictly technical scope.
---

# project-optimizer

A tiered, source-cited, bias-checked technical research workflow. Inspects the user's project, researches competitors and prior art, and presents a ranked improvement report directly in the chat.

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

## Output contract (read this first)

This skill presents **everything in the chat**. It does NOT create documents in the user's project.

- Never write `OPTIMIZATION_REPORT.md`, an `optimization/` directory, or any other file into the user's repository or working directory.
- Render the full report as structured markdown in the chat response.
- Benchmark scripts for Tier 3 are shown as copy-pasteable fenced code blocks in the chat, not written to disk.
- The single exception is the skill's own `MEMORY.md` (see "Memory"), which lives in the skill's install directory, never in the user's project.
- After delivering the report, you may offer: "I can save any of this to a file if you want - say the word." Only write a file on explicit user request.

## Memory - learning across sessions

This skill keeps a durable record of what it learns about the user across runs, in `MEMORY.md` inside the skill's own install directory (typically `~/.claude/skills/project-optimizer/MEMORY.md`).

Honest framing: a skill cannot retrain a model. "Learning" here means maintaining a concise, auditable set of observations that make future runs better - user preferences, domain corrections, recurring stack facts, and which sources proved reliable. It is transparent note-keeping, not machine learning, and the user can inspect or edit the file directly.

**At the START of every run** (after activation, before Phase 1):
1. If `MEMORY.md` does not exist in the skill directory, create it by copying `references/MEMORY.template.md`.
2. Read `MEMORY.md`. Apply relevant learnings to this run (for example: the user's team cannot adopt a given language; the user wants effort in ideal-days not dev-weeks; the user has repeatedly rejected microservice recommendations).
3. State in one line which learnings you applied this run, so it is visible and correctable.

**At the END of every run** (after Phase 9):
1. Append only durable, generalizable learnings: stable user preferences, corrections the user made to your analysis, recurring stack/domain facts about their work, and sources that proved reliable or unreliable.
2. Do NOT store secrets, credentials, proprietary code, or one-off project specifics. One line per entry.
3. Prune so each section stays under ~15 entries - drop the oldest or least-useful.
4. Tell the user in one line what you saved.

If the user says "forget that" or "don't remember this", delete the relevant entry from `MEMORY.md`.

## Bias guards (apply throughout - especially Phases 2, 4, and 7)

The value of this skill is an honest, evidence-ranked answer. Defend it against bias:

- **Hype / recency bias:** never recommend a technology because it is trending or new. Require evidence it fits THIS project's constraints.
- **Status-quo / incumbency bias:** do not favor the user's current stack out of inertia - and do not recommend a rewrite for novelty. The null recommendation ("the current approach is appropriate here, and here is the evidence") is a valid, expected output when true.
- **Vendor / conflict of interest:** flag when a source is the vendor of the thing it promotes (e.g. a database company benchmarking its own database). Down-weight it and seek independent corroboration.
- **Selection / survivorship bias:** success stories over-represent winners. Actively search for disconfirming evidence - "X postmortem", "why we migrated off X", "X limitations at scale", "X regrets".
- **Anchoring:** build the competitor/alternative list before forming an opinion, not to justify one you already hold.
- **Confirmation bias:** for every recommendation, write the strongest counter-argument you can. If it survives, keep it. If it doesn't, drop the recommendation.
- **Auditable ranking:** rank strictly by `(impact x confidence) / (effort x risk)`. Never reorder by preference, familiarity, or vendor. Show the four inputs for each recommendation so the ranking can be checked.
- **Calibrated confidence:** two independent cross-validated sources beat one high-tier source. State confidence honestly; prefer "unknown" over a confident guess.

## Tier auto-detection

Run `bash scripts/complexity-detect.sh <project-root>` for a suggested tier. Then apply:

- **Tier 1 (Light):** < 2k LOC, single service, no distributed components.
- **Tier 2 (Standard):** 2k-20k LOC, OR multiple modules, OR a database in the stack.
- **Tier 3 (Deep):** > 20k LOC, OR microservices, OR distributed-system markers (queues, caches, multiple DBs, k8s/orchestration), OR the user explicitly says "deep", "complex", "thorough", "production-grade", "outperform competitors".

User can force a tier: "run project-optimizer in deep mode" -> Tier 3 regardless of LOC.

State the detected tier in the first reply. Tier 3 cannot start research until the Phase 0 interview is answered.

## Workflow

Load memory (see "Memory") first. Then run phases in order. Phase 0 only fires for Tier 3. Phases 2 and 3 run in parallel.

### Phase 0 - Constraints interview (Tier 3 only)

Before any research, ask the user 3-5 sharp questions from `references/interview-questions.md`. Do not proceed until answered. The answers shape every later recommendation.

If the user says "go without it", proceed but mark every recommendation that depended on a missing answer as "assumption-based - validate before acting".

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

**Pass 1 - Discovery:** identify 5-10 competitors / alternatives. Direct = same product category. Adjacent = same underlying technical problem. Web-search for engineering content: blogs, talks, papers, repos. Build a candidate source list. (Anchoring guard: list broadly before judging.)

**Pass 2 - Deep read:** for each high-value source, read fully. Extract specifics: numbers, architecture diagrams, trade-offs, things the authors regretted. Follow citations from sources to deeper sources. Deliberately search for failure stories and migrations-away, not only success posts.

**Pass 3 - Cross-validation:** every load-bearing finding must be confirmed by >=2 independent sources or flagged "single-source / unconfirmed". Surface conflicting claims explicitly - do not paper over them. Flag any vendor-authored source.

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

**Deep-research depth dial (Tier 3):** do not stop at the first plausible answer per subsystem. Aim for at least 3 independent sources per load-bearing claim, follow at least one citation chain to its primary source, and explicitly record what you searched for but could NOT find (negative results are findings). If the user said "exhaustive" or "as deep as possible", widen the competitor set to 7-10 and add a second cross-validation pass.

### Phase 4 - Source quality scoring

Tag every source you cite with a quality tier per `references/source-quality-rubric.md`:

- **S** - primary docs, peer-reviewed papers, official benchmarks.
- **A** - first-party engineering blogs from companies operating at scale.
- **B** - talks from named engineers, well-known OSS maintainers.
- **C** - reputable community sources, well-cited technical articles.
- **D** - unranked, single contributor, no track record.

A recommendation cannot rest on D-tier sources alone. It needs at least one S/A/B citation or it is flagged "low confidence". Vendor-authored sources are noted as such regardless of tier.

### Phase 5 - Quantitative grounding

Every performance claim attaches a number where possible:
- Latency (p50, p99).
- Throughput (req/s, rows/s, msgs/s).
- Memory / CPU.
- Big-O for algorithmic changes.
- Cost delta ($/month at given scale).

If no number is available, mark the claim **qualitative** in the report. Do not bury this. Do not fabricate numbers. If you compute an estimate, show the math inline and label it "estimated".

### Phase 6 - Failure mode + scale analysis

Per subsystem (Tier 3) or for the system as a whole (Tier 1/2), answer:
- What breaks first at 10x current load?
- At 100x?
- At 1000x?
- What is the failure mode (slow, errors, data loss, cascading)?
- What do competitors do at that scale, and which source says so?

### Phase 7 - Synthesis: recommendations

Each recommendation has:
- **What to change** - specific files / modules / libraries.
- **Why** - cited sources with quality tier. Include the surviving counter-argument from the bias guard.
- **Quantitative impact** - numbers from research, or "qualitative" if none.
- **Effort** - dev-weeks estimate (or the unit the user prefers per MEMORY.md).
- **Infra cost delta** - $/month, with assumed scale.
- **Risk** - what could go wrong, migration hazards.
- **Concrete next step** - benchmark to run, spike to do, library to evaluate.
- **Confidence** - **high** (cross-validated S/A sources), **medium** (A/B sources), **low** (single-source or D-tier).

Rank by `(impact x confidence) / (effort x risk)`, highest first. Show the four input values so the order is auditable. If the honest conclusion is "no change needed here", say so and stop - do not manufacture recommendations to fill space.

### Phase 8 - Future-watch

- What is emerging in this space in the last ~12 months?
- What is getting deprecated?
- Where is the field heading in 2-3 years?
- What should the team track but not act on yet?

### Phase 9 - Output (in the chat only)

Do not write anything into the user's project. Render the entire report as structured markdown in your chat response, top to bottom. Lead with a 3-5 line TL;DR.

**Tier 1** - post these sections in chat:
1. TL;DR
2. Project Snapshot
3. Competitive Landscape
4. Research Findings
5. Scale Analysis
6. Recommendations (ranked, with audit values)
7. Future Watch
8. Open Questions

Use `references/report-templates/OPTIMIZATION_REPORT.md` as the section structure (it is a chat layout, not a file to save).

**Tier 2** - same as Tier 1, plus a **Bibliography** section (structure from `references/report-templates/bibliography.md`).

**Tier 3** - post the full report in chat with H2 sections in this order, using the matching templates in `references/report-templates/` purely as layout guides:
1. TL;DR + Scoreboard + Top 10 (from `EXECUTIVE_REPORT.md`)
2. Constraints (Phase 0 answers)
3. Project Snapshot + Subsystem Map
4. One deep-dive section per subsystem (from `subsystem.md`)
5. Competitive Landscape
6. Research Findings
7. Failure Modes at 10x / 100x / 1000x (from `failure-modes.md`)
8. Risk Register (from `risk-register.md`)
9. Recommendations, ranked across all subsystems (with audit values)
10. Future Watch (from `future-watch.md`)
11. Bibliography (from `bibliography.md`)
12. Open Questions

For each high-impact Tier 3 recommendation, include a runnable benchmark as a fenced code block inline in the chat (adapt `scripts/benchmark-skeleton/`), with clear `# TODO` markers. Do not write the benchmark to disk.

If the report is long, post it in clearly labeled parts within the conversation, but ensure ALL of it reaches the chat. Never truncate or summarize away findings to save space. Cross-reference sections by name ("see the Risk Register section above"), not by file path.

After the report, offer once: "I can save any of this to a file in your project if you want - I won't unless you ask."

Then run the end-of-run Memory step.

## Hard rules

- No uncited claims. Ever. Every recommendation cites at least one source from Phase 2 or 3.
- No fabricated benchmarks or numbers. If a number is not sourced, write "estimated" and show the math.
- Never write files into the user's project. All findings go in the chat. The only file this skill writes is its own `MEMORY.md` in the skill install directory.
- If the project is in a domain you are not strong in (niche embedded targets, obscure DSLs, hardware-specific code, etc.), declare it up front in the report. Do not bluff.
- Apply the bias guards. Show the four ranking inputs so the order is auditable. "No change needed" is a valid result.
- No padding. Every section earns its place. Drop empty sections rather than filling them.
- No emojis anywhere in the output.
- For Tier 3, include at least one runnable benchmark (as an inline code block) per high-impact recommendation.
- Read MEMORY.md at the start and update it at the end of every run.

## Files in this skill

- `SKILL.md` - this file.
- `references/MEMORY.template.md` - seed for the per-user learning file.
- `references/research-sources.md` - curated search starting points per domain.
- `references/source-quality-rubric.md` - exact S/A/B/C/D scoring rules.
- `references/interview-questions.md` - Phase 0 constraints interview.
- `references/report-templates/` - chat-section layout guides (not files to save).
- `scripts/stack-detect.sh` - stack and LOC first pass.
- `scripts/complexity-detect.sh` - LOC, module count, distributed markers -> suggested tier.
- `scripts/benchmark-skeleton/` - starter templates you adapt into inline benchmark code blocks.
- `README.md` - install and usage notes for humans.
