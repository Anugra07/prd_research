# Research Sources

Starting points for Phase 2 (competitor) and Phase 3 (fallback) research. Not exhaustive. Always prefer primary technical material (engineering blogs, talks, source code, papers) over secondary commentary.

## Cross-domain

- **Engineering blogs aggregators**: https://blog.pragmaticengineer.com, https://highscalability.com, https://thedailywtf.com (anti-patterns), https://lobste.rs (filter by tag).
- **Conferences with strong technical talks**: Strange Loop, QCon, GOTO, USENIX (ATC, OSDI, SREcon), Papers We Love, P99 CONF.
- **Talks**: https://www.infoq.com/presentations/, https://speakerdeck.com (slide decks), conference YouTube channels.
- **Papers**: https://arxiv.org, https://scholar.google.com, https://dl.acm.org, https://www.usenix.org/publications/proceedings.
- **OSS discovery**: GitHub trending, https://github.com/topics/<topic>, sort by stars + recent activity.

## Web backends / APIs

- Engineering blogs: Stripe, Shopify, Cloudflare, Discord, Figma, Notion, Vercel, GitHub, GitLab, Basecamp/37signals, Netflix, Uber, Airbnb, Slack.
- Reference architectures: AWS Architecture Center, Google Cloud Architecture Framework, Azure Architecture Center.
- Benchmarks: TechEmpower Framework Benchmarks.
- Patterns: https://microservices.io, https://martinfowler.com.

## Databases / data storage

- Engineering blogs: PlanetScale, Neon, Supabase, Turso, CockroachDB, Vitess, MongoDB, Redis, ClickHouse.
- Papers: VLDB, SIGMOD, CIDR proceedings.
- Benchmarks: YCSB, TPC-C / TPC-H, ClickBench, JOB (Join Order Benchmark).
- Tuning docs: the official `Performance` or `Internals` chapter of the DB you're using - frequently overlooked.

## Data engineering / analytics

- Engineering blogs: Snowflake, Databricks, DuckLabs (DuckDB), Materialize, Confluent, dbt Labs, Airbyte.
- Papers: Dremel, Spanner, Photon, Procella - search arXiv for follow-ups.
- Benchmarks: TPC-DS, ClickBench, H2O.ai db-benchmark.

## ML / AI systems

- Engineering blogs: OpenAI, Anthropic, Hugging Face, Replicate, Modal, Together AI, Mistral, DeepMind, Meta AI.
- Papers: arXiv cs.LG, cs.CL, cs.CV, cs.DC. NeurIPS, ICML, ICLR proceedings.
- Inference perf: vLLM, TensorRT-LLM, llama.cpp, SGLang repos and their issue trackers.
- Benchmarks: MLPerf (training and inference), HELM, lm-evaluation-harness.

## Mobile (iOS / Android)

- Engineering blogs: Airbnb, Uber, Instagram, Reddit, Lyft, Square mobile engineering.
- Conferences: droidcon, try! Swift, Mobile@Scale.
- Performance: Android Developers `Performance` docs, Apple `Instruments` and WWDC perf sessions.

## Embedded / systems / low-level

- Conferences: USENIX ATC, OSDI, SOSP, EuroSys, FOSDEM, Embedded Linux Conference.
- Blogs: Cloudflare blog (network stack), Tigris, ScyllaDB engineering, Bun blog, Oxide Computer, LWN.net.
- References: Brendan Gregg's site (https://www.brendangregg.com), Agner Fog's optimization manuals.

## Frontend / browser

- Engineering blogs: Figma, Linear, Notion, Vercel, Sentry, Chrome DevTools team (web.dev), Mozilla Hacks.
- Conferences: JSConf, React Conf, Chrome Dev Summit.
- Benchmarks: Speedometer, JetStream, Web Vitals reports.

## DevOps / infra / observability

- Engineering blogs: HashiCorp, Honeycomb, Datadog, Grafana Labs, Fly.io, Render, Equinix Metal.
- SRE: Google SRE Book and Workbook (free online).
- Conferences: SREcon, KubeCon, HashiConf.

## How to evaluate a source

Use this triage when deciding whether to cite something:

1. Is it primary (the team that built it talking about it) or secondary?
2. Is there code, a diagram, numbers, or a profile - or only adjectives?
3. Is it dated? Anything older than ~5 years for a fast-moving area (LLM serving, frontend tooling) is suspect. Older is fine for fundamentals (algorithms, OS internals).
4. Is the company's scale comparable to the user's? A pattern that solves Netflix's problem may be overkill for a 10-rps service - say so when citing.
