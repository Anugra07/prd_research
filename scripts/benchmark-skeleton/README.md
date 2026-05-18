# Benchmark Skeletons

Starter templates for the most common benchmark types you'll need to verify project-optimizer recommendations. **None of these are runnable as-is.** Each one has `# TODO` markers where you must plug in your project's endpoint, query, dataset, or workload.

Copy a skeleton into `optimization/benchmarks/<descriptive-name>` (one per high-impact recommendation), fill in the TODOs, and commit the result alongside the report so the user can re-run it after applying the change.

## What's here

| File | Purpose | When to use |
|---|---|---|
| `http-bench.sh` | HTTP-level throughput and latency (wrk-based) | Any web service / API recommendation |
| `db-bench.sh` | Database query performance (psql / mysql-cli driven) | Schema, index, or query-shape recommendations |
| `micro-bench.py` | Algorithmic micro-benchmark in Python (timeit + statistics) | Algorithm-level changes within a Python codebase |
| `micro-bench.js` | Algorithmic micro-benchmark in Node.js | Algorithm-level changes within a JS/TS codebase |

If your project is in Go / Rust / Java / Kotlin / etc., use the language's native benchmarking facility instead of the micro-bench Python/JS skeletons:
- Go: `testing.B` (`go test -bench`)
- Rust: `criterion` crate
- Java/Kotlin: JMH

## Discipline

1. **Baseline first.** Run on the unchanged code, record numbers. Without this, "X is faster" is unfalsifiable.
2. **Warm up.** First runs are noisy. Discard the first 10-20% of measurements.
3. **Multiple samples.** At least 30 samples. Report p50, p95, p99 - never just a mean.
4. **Pin the environment.** Same hardware, same dataset, same load generator, ideally same time of day. Note all of these in the script header.
5. **Vary one thing.** Apply exactly one change between baseline and treatment. If you want to test multiple changes, do multiple A/B benchmarks.
6. **Statistical sanity.** A 3% improvement in a noisy benchmark is noise. Aim for changes you can detect above measurement variance.

## Output convention

Each benchmark should print, at minimum:

```
benchmark: <name>
revision: <git sha or "uncommitted">
date:     <ISO8601>
hardware: <CPU / RAM / OS>
dataset:  <size, source>
runs:     <n>
warmup:   <n>
results:
  p50:  ...
  p95:  ...
  p99:  ...
  mean: ...
  stdev: ...
```

Keep this stable so successive runs are diffable.
