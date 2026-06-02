---
name: project-optimizer
description: Use when the user has a software product and wants to make it better - technically and/or as a business in its market. Two modes. TECHNICAL mode (optimize, make faster, scale, architecture review, "how do competitors do this", "production-grade review") covers performance, architecture, algorithms, stack, infra. BUSINESS mode ("what's our UVP", "how do we position", "where do we stand in the market", "how do we grow", "how do we differentiate", "how do we expand", "take it to the next level") covers product value, market positioning, competitive standing, growth, and expansion. FULL mode runs both and unifies them. Auto-tiers light to deep. Presents all findings in the chat - never writes files into the user's project.
---

# project-optimizer

A tiered, source-cited, bias-checked research workflow that makes a software product better - technically, as a business in its market, or both. It inspects the product, researches competitors and prior art, and presents a ranked improvement report directly in the chat.

## Modes

- **technical** - performance, architecture, algorithms, stack, scalability, infra, tooling, code quality. (The original scope.)
- **business** - product value and UVP, market and competitive positioning, where the product stands, growth/optimization levers, and expansion strategy.
- **full** - both tracks, plus a unified synthesis that shows how technical work enables business goals and how business priorities should sequence technical work.

### Mode detection

Pick the mode from the request:
- **technical** signals: "optimize", "faster", "scale", "architecture", "refactor", "tech debt", "perf", "how do competitors do this technically".
- **business** signals: "UVP", "value proposition", "positioning", "where do we stand", "market", "grow", "growth", "go-to-market", "monetize", "pricing", "differentiate", "be the best", "expand", "next level".
- **full**: the request spans both ("understand my product technically and from a business perspective", "take it to the next level"), or the user says "full".

The user can force a mode: "run project-optimizer in business mode" / "technical mode" / "full mode". When the request clearly spans both tracks, default to **full**. State the detected mode and tier in your first reply.

## Scope

In scope:
- **Technical:** performance, architecture, algorithms, data structures, tech-stack choices, scalability, code quality, tooling, infrastructure, build/deploy, observability, testing strategy.
- **Business:** product value and jobs-to-be-done, unique value proposition, market and competitive positioning, differentiation and moat, growth and optimization (acquisition, activation, retention, monetization), pricing and packaging, and expansion (new segments, geographies, product-line extensions, platform/partnership plays).

Out of scope: visual/UX design execution, legal/accounting/tax mechanics, fundraising deal mechanics, and HR/hiring process. If asked, say once that this skill covers technical and product/market strategy and continue with what is in scope.

## Output contract (read this first)

This skill presents **everything in the chat**. It does NOT create documents in the user's project.

- Never write any report file (`OPTIMIZATION_REPORT.md`, an `optimization/` directory, a strategy doc, etc.) into the user's repository or working directory.
- Render the full report as structured markdown in the chat response.
- Tier 3 benchmark scripts are shown as copy-pasteable fenced code blocks in the chat, not written to disk.
- The single exception is the skill's own `MEMORY.md` (see "Memory"), in the skill's install directory, never in the user's project.
- After the report, you may offer: "I can save any of this to a file if you want - say the word." Only write a file on explicit request.

## Memory - learning across sessions

The skill keeps a durable record of what it learns about the user across runs, in `MEMORY.md` inside the skill's install directory (typically `~/.claude/skills/project-optimizer/MEMORY.md`).

Honest framing: a skill cannot retrain a model. "Learning" here means maintaining a concise, auditable set of observations that make future runs better - user preferences, domain and market corrections, recurring product/stack facts, and which sources proved reliable. It is transparent note-keeping, not machine learning, and the user can read or edit the file directly.

**At the START of every run** (after activation, before Phase 0/1):
1. If `MEMORY.md` does not exist, create it by copying `references/MEMORY.template.md`.
2. Read it. Apply relevant learnings (e.g. the user's target market, monetization model, effort-unit preference, a strategy direction they have rejected).
3. State in one line which learnings you applied.

**At the END of every run** (after output):
1. Append only durable, generalizable learnings: stable preferences, corrections the user made, recurring product/stack/market facts, reliable/unreliable sources.
2. No secrets, credentials, proprietary code, or one-off details. One line per entry. Keep each section under ~15 entries; prune the oldest.
3. Tell the user in one line what you saved.

If the user says "forget that", delete the relevant entry.

## Bias guards (apply throughout)

The value of this skill is an honest, evidence-ranked answer. Defend it against bias in both tracks.

Shared:
- **Hype / recency bias:** never recommend a technology or a trend (incl. AI-washing) because it is popular. Require evidence it fits THIS product and market.
- **Vendor / conflict of interest:** flag sources that are the vendor/marketer of the thing they praise (vendor benchmarks, press releases, sponsored reviews). Down-weight; seek independent corroboration.
- **Confirmation bias:** for every recommendation, write the strongest counter-argument. If it survives, keep it; if not, drop it.
- **Auditable ranking:** rank strictly by `(impact x confidence) / (effort x risk)`. Never reorder by preference or familiarity. Show the four inputs.
- **Calibrated confidence:** two independent cross-validated sources beat one. Prefer "unknown" over a confident guess. "No change needed" / "the current position is already strong" is a valid result.

Technical track:
- **Status-quo bias** (don't favor the current stack out of inertia) and its opposite, **novelty bias** (don't recommend rewrites for fashion).
- **Selection / survivorship:** hunt for failure stories ("why we moved off X", "X at scale", postmortems), not just success posts.

Business track:
- **Market-size inflation:** never present a top-down TAM without a bottom-up sanity check. Label every market estimate "estimated" and show the method.
- **Vanity metrics:** prefer revenue, retention, payback, and margin over downloads/signups/impressions.
- **Survivorship of unicorns:** a tactic that worked for one breakout is not a law. Note base rates.
- **Differentiation honesty:** if the UVP is weak, undifferentiated, or a feature not a moat, say so plainly.

## Tier auto-detection

Run `bash scripts/complexity-detect.sh <project-root>` for a suggested tier. Apply:
- **Tier 1 (Light):** < 2k LOC, single service, no distributed components.
- **Tier 2 (Standard):** 2k-20k LOC, OR multiple modules, OR a database.
- **Tier 3 (Deep):** > 20k LOC, OR microservices/distributed markers (queues, caches, multiple DBs, k8s), OR the user says "deep", "thorough", "production-grade", "outperform competitors", "take it to the next level".

Tier sets research depth in BOTH tracks. The user can force a tier ("deep mode" -> Tier 3). Tier 3 cannot start research until the Phase 0 interview is answered.

## Workflow

Load memory first. Then run Phase 0, then the track(s) for the detected mode, then synthesis and output. Within a track, research phases run in parallel where noted.

### Phase 0 - Constraints interview (Tier 3, or any tier in business/full mode)

Ask 3-6 sharp questions before researching. Use `references/interview-questions.md` for technical and `references/business-interview-questions.md` for business; in full mode pick across both. Do not proceed until answered. If the user says "go without it", proceed but mark dependent recommendations "assumption-based - validate before acting".

---

## Technical track (mode = technical or full)

### Phase T1 - Project inspection
1. Run `bash scripts/stack-detect.sh <project-root>`.
2. Read entry points and top-level config (package.json, pyproject.toml, Cargo.toml, go.mod, Dockerfile, compose, infra/, terraform/, k8s/).
3. Map architecture: entry points, data flow, key modules, external services, datastores, queues, caches.
4. Read enough source to find real weak points (N+1 queries, blocking I/O on hot paths, unbounded queues, single-process design, no cache layer, missing indexes, no pooling, obviously-improvable algorithms). Cite `file:line` for every claim.
5. Tier 3: decompose into 3-8 named subsystems, each with entry points, data flow, dependencies, weak points (`file:line`).
6. Produce a Project Snapshot (and Subsystem Map for Tier 3). Note unknowns explicitly. Do not guess at runtime behavior without evidence.

### Phase T2 - Multi-pass competitor research (technical)
Pass 1 discovery: 5-10 competitors/alternatives (direct + adjacent). Pass 2 deep read: extract numbers, diagrams, trade-offs, regrets; follow citation chains; seek failure stories. Pass 3 cross-validation: each load-bearing finding confirmed by >=2 independent sources or flagged single-source. Marketing pages are not sources. If internals aren't public, say so. See `references/research-sources.md`.

### Phase T3 - Fallback research (parallel with T2)
arXiv/Scholar (last 5 years unless foundational); top-starred GitHub repos (README, ARCHITECTURE.md, recent issues/PRs); official docs perf/scalability/anti-pattern sections; domain conference talks. Capture URL, one-line summary, why it applies. Deep dial (Tier 3): >=3 independent sources per load-bearing claim, follow >=1 citation chain to primary, record what you searched for but did NOT find.

### Phase T4 - Source quality scoring
Tag every cited source S/A/B/C/D per `references/source-quality-rubric.md`. No recommendation rests on D-tier alone. Flag vendor-authored sources.

### Phase T5 - Quantitative grounding
Every perf claim gets a number where possible (latency p50/p99, throughput, memory/CPU, Big-O, $/month). No number -> mark "qualitative". No fabricated numbers; show the math for estimates and label "estimated".

### Phase T6 - Failure mode + scale analysis
Per subsystem (Tier 3) or whole system: what breaks first at 10x / 100x / 1000x, the failure mode, and what competitors do at that scale (with source).

### Phase T7 - Technical recommendations
Each: what to change (files/modules/libraries), why (cited, with tier + surviving counter-argument), quantitative impact, effort (dev-weeks or the user's preferred unit), infra cost delta, risk, concrete next step (benchmark/spike/library), confidence. Rank by `(impact x confidence) / (effort x risk)` with inputs shown.

### Phase T8 - Technical future-watch
Emerging (last ~12 months), deprecating, 2-3 year horizon, track-but-don't-act-yet.

---

## Business track (mode = business or full)

Apply the same citation, source-tiering, and bias discipline as the technical track. Business sources include competitor pricing/product pages (with capture date), independent review sites (G2, Capterra, TrustRadius), app-store and ProductHunt data, public filings and earnings calls, analyst mentions, and credible market reports. See `references/business-research-sources.md`. Label all market estimates "estimated" and show the method.

### Phase B1 - Product and value understanding
- State in one sentence what the product does and the core job-to-be-done it serves.
- Identify the target user/segment(s) and the primary use case(s) - from the code, docs, marketing, and the Phase 0 answers.
- Map the current business model: how value is delivered and (if any) captured (pricing/packaging, free vs paid, monetization).
- Draft the current UVP hypothesis in one sentence: "For [segment], [product] is the [category] that [key benefit], unlike [alternative], because [differentiator]."
- Cite evidence for each claim (code feature at `file:line`, a docs/marketing line, or a user/Phase-0 statement). Flag assumptions.

### Phase B2 - Market and competitive positioning
- Identify 5-10 competitors/alternatives at the BUSINESS level (direct, adjacent, and the "status quo / do nothing" alternative).
- For each, research: positioning and target segment, pricing/packaging, headline differentiators, apparent strengths and gaps, and traction signals (reviews, funding, hiring, app ranks). Capture sources with dates.
- Build a positioning map: where this product sits versus competitors on the 2 axes that matter most for this category (name the axes; justify them).
- Honest verdict: where the product stands today (leader / contender / niche / laggard) and on what evidence.

### Phase B3 - UVP analysis
- Compare the product's value prop against each competitor's. Is the differentiator real, defensible, and valued by the target segment - or a feature anyone can copy?
- Rate UVP strength (strong / moderate / weak) with reasoning, and name the sharpest wedge (the narrow place this product can credibly be the best).
- Identify the gap to "best in category": what would have to be true (product, performance, positioning) to win the wedge, and then expand from it.

### Phase B4 - Growth and optimization levers
- Across acquisition, activation, retention, monetization, and referral, identify the highest-leverage levers for THIS product and stage.
- Tie levers to evidence: comparable companies' approaches (cited), the product's own funnel/architecture constraints (note where a technical limit caps a business lever - this is where the two tracks meet), and the Phase 0 goals.
- Prefer levers grounded in revenue/retention/payback over vanity metrics.

### Phase B5 - Expansion strategy
- Enumerate expansion vectors: new segments, new geographies, adjacent product lines, platform/ecosystem/API plays, and partnerships.
- For each: the thesis, the evidence it's viable (market signal, competitor precedent, inbound demand), the technical and go-to-market prerequisites, the risk, and a sequencing note (now / next / later).
- Be explicit about what would have to be proven before committing.

### Phase B6 - Business recommendations
Each: what to do, why (cited, with source tier + surviving counter-argument), expected impact (revenue/growth/strategic, quantified or "qualitative"), effort, cost, risk, concrete next step (an experiment to run, a positioning change to test, a segment to interview, a metric to instrument), and confidence. Rank by `(impact x confidence) / (effort x risk)` with inputs shown.

---

## Synthesis (full mode)

Merge the two tracks into ONE ranked roadmap. For each item tag `[Technical]`, `[Business]`, or `[Both]`. Show the dependencies that cross tracks: where a technical change unlocks a business lever (e.g. "p99 latency fix is a prerequisite for the enterprise segment"), and where a business priority should sequence technical work. Rank the unified list by `(impact x confidence) / (effort x risk)` with inputs shown. Lead with a single executive summary covering both technical health and market standing.

## Output (in the chat only)

Render the whole report as structured markdown in chat - no files in the user's project. Lead with a TL;DR. Assemble sections by mode using the layout guides in `references/report-templates/` (they describe chat sections, not files):

- **technical**: TL;DR, Project Snapshot, Competitive Landscape (tech), Research Findings, Scale Analysis, Recommendations (ranked), Future Watch, Open Questions. (`OPTIMIZATION_REPORT.md` layout; add `bibliography.md` at Tier 2+, full Tier-3 multi-section set at Tier 3.)
- **business**: TL;DR, Business Snapshot + UVP, Market & Competitive Positioning, Growth Levers, Expansion Roadmap, Strategic Recommendations (ranked), Open Questions, Bibliography. (`business-sections.md` layout.)
- **full**: a unified Executive Summary, then the technical sections, then the business sections, then the **unified ranked roadmap** from Synthesis, then one combined Bibliography and Open Questions.

For Tier 3, include at least one runnable benchmark (inline code block, adapted from `scripts/benchmark-skeleton/`) per high-impact technical recommendation, and at least one concrete, measurable experiment per high-impact business recommendation. Post long reports in clearly labeled parts but ensure ALL of it reaches the chat. Cross-reference by section name, not file path. Then run the end-of-run Memory step.

## Hard rules

- No uncited claims, technical or business. Every recommendation cites at least one source.
- No fabricated numbers or benchmarks. Mark unsourced figures "estimated" and show the math. Market sizes are always "estimated" with method.
- Never write files into the user's project. Findings go in the chat. The only file written is the skill's own `MEMORY.md`.
- If the product is in a technical domain or a market you are not strong in, declare it up front. Do not bluff.
- Apply the bias guards. Show the four ranking inputs. "No change needed / position already strong" is a valid result.
- No padding. Drop empty sections. No emojis in output.
- Read `MEMORY.md` at the start and update it at the end of every run.

## Files in this skill

- `SKILL.md` - this file.
- `references/MEMORY.template.md` - seed for the per-user learning file.
- `references/interview-questions.md` - Phase 0 technical constraints interview.
- `references/business-interview-questions.md` - Phase 0 business/market interview.
- `references/research-sources.md` - technical search starting points per domain.
- `references/business-research-sources.md` - market/competitor intelligence starting points.
- `references/source-quality-rubric.md` - S/A/B/C/D scoring rules (applies to both tracks).
- `references/report-templates/` - chat-section layout guides (not files to save), incl. `business-sections.md`.
- `scripts/stack-detect.sh` - stack and LOC first pass.
- `scripts/complexity-detect.sh` - LOC, module count, distributed markers -> suggested tier.
- `scripts/benchmark-skeleton/` - starters you adapt into inline benchmark code blocks.
- `README.md` - install and usage notes for humans.
