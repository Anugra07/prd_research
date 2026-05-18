# Source Quality Rubric

Every source cited in the report gets a tier. Recommendations are weighted by the highest-tier source backing them.

## Tiers

### S - Primary / authoritative
- Official documentation of the product or runtime under discussion (e.g. Postgres docs, the Linux kernel docs, the language spec).
- Peer-reviewed papers (ACM, USENIX, IEEE, NeurIPS, ICML, VLDB, SIGMOD, OSDI, SOSP, etc.).
- Official benchmark results from the benchmark maintainer (TPC, MLPerf, TechEmpower, YCSB).
- Public RFCs, standards documents (IETF, W3C).
- Direct code from the project being discussed, when the claim is about that project.

### A - First-party engineering content at scale
- Engineering blogs from companies operating at meaningful scale, talking about their own systems (Stripe, Netflix, Cloudflare, Discord, Figma, Shopify, Uber, Airbnb, GitHub, GitLab, Slack, Notion, Vercel, Linear, etc.).
- Official post-mortems and incident write-ups from the affected company.
- Architecture-decision records (ADRs) published by such companies.
- Conference keynotes from named principal/staff engineers at such companies.

### B - Recognized expert content
- Technical talks at major conferences (Strange Loop, QCon, GOTO, KubeCon, SREcon, P99 CONF, JSConf, etc.) by named engineers.
- Long-form posts by well-known OSS maintainers about their own project.
- Books from recognized technical publishers (O'Reilly, Manning, Pragmatic Bookshelf) by authors with track records.
- High-quality independent technical blogs by named engineers with verifiable credentials (e.g. Brendan Gregg, Dan Luu, Marc Brooker, Aleksey Shipilev).

### C - Reputable community
- Well-cited Stack Overflow / GitHub Discussions answers where the answerer is a maintainer or expert.
- Mid-tier engineering blogs with technical depth but smaller scale.
- HN / Lobsters comment threads from named experts, used as a pointer (not the primary claim).
- Wikipedia for foundational definitions only, never for design decisions.

### D - Unranked
- Anonymous blog posts.
- Single-contributor repos with no users.
- Tutorials of unknown provenance.
- Marketing pages that snuck in.
- LLM-generated content cited as if primary.

## Rules

1. **Every citation gets a tier.** In `bibliography.md`, every source row has a `Tier` column.
2. **No D-only recommendations.** A recommendation backed only by D-tier sources gets flagged "low confidence" in Phase 7. The user can still act on it, but they're warned.
3. **Cross-validation outranks tier.** A claim confirmed by two B sources from independent organizations beats a single A source. Note this in `bibliography.md`'s relevance column.
4. **Recency matters in fast-moving areas.** In LLM serving, frontend perf, and cloud-native ops, prefer sources from the last 24 months. In algorithms, OS internals, and DB theory, older S sources are fine.
5. **Scale-mismatch warning.** If you cite an A source from a company operating at scale far above the user's, note this. A pattern Netflix needs is not necessarily one a 10-rps service needs.
6. **Conflicts surface.** When sources disagree, both go in `bibliography.md` and the disagreement is named in the relevant recommendation's "Why" section.

## Quick triage flowchart

- Is it the official docs / a paper? -> S.
- Is the company writing about its own system, operating at scale, with diagrams or numbers? -> A.
- Is it a named expert on a known platform with technical depth? -> B.
- Is the author identifiable, the content technical, but the source mid-tier? -> C.
- Anything else, or unknown author -> D.
