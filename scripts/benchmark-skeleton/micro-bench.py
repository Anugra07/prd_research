#!/usr/bin/env python3
"""micro-bench.py - algorithmic micro-benchmark skeleton.

Drop your "before" and "after" implementations into BASELINE() and TREATMENT(),
plus a setup() that builds the input. Run:

    python3 micro-bench.py

Output is stable across runs so you can diff results across commits.
"""

from __future__ import annotations

import argparse
import gc
import platform
import statistics
import subprocess
import sys
import time
from typing import Any, Callable


# ---- TODO: configure ------------------------------------------------------


def setup() -> Any:
    """Build the input. Called once. Cost is excluded from measurement."""
    # TODO: build whatever your function under test consumes.
    return list(range(100_000))


def baseline(inp: Any) -> Any:
    """The current implementation."""
    # TODO: replace with the current code path you want to beat.
    return sorted(inp, reverse=True)


def treatment(inp: Any) -> Any:
    """The proposed implementation."""
    # TODO: replace with the candidate change.
    out = list(inp)
    out.sort(reverse=True)
    return out


# ---------------------------------------------------------------------------


def _percentile(sorted_vals: list[float], p: float) -> float:
    if not sorted_vals:
        return float("nan")
    k = max(0, min(len(sorted_vals) - 1, round(p / 100 * (len(sorted_vals) - 1))))
    return sorted_vals[k]


def _bench(fn: Callable[[Any], Any], inp: Any, runs: int, warmup: int) -> dict[str, float]:
    # warmup
    for _ in range(warmup):
        fn(inp)

    samples: list[float] = []
    for _ in range(runs):
        gc.collect()
        gc.disable()
        try:
            t0 = time.perf_counter_ns()
            fn(inp)
            t1 = time.perf_counter_ns()
        finally:
            gc.enable()
        samples.append((t1 - t0) / 1_000_000.0)  # ms

    samples.sort()
    return {
        "p50": _percentile(samples, 50),
        "p95": _percentile(samples, 95),
        "p99": _percentile(samples, 99),
        "mean": statistics.fmean(samples),
        "stdev": statistics.pstdev(samples),
        "min": samples[0],
        "max": samples[-1],
    }


def _git_sha() -> str:
    try:
        return subprocess.check_output(
            ["git", "rev-parse", "--short", "HEAD"], stderr=subprocess.DEVNULL
        ).decode().strip()
    except Exception:
        return "uncommitted"


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--runs", type=int, default=200)
    ap.add_argument("--warmup", type=int, default=30)
    ap.add_argument("--only", choices=["baseline", "treatment", "both"], default="both")
    args = ap.parse_args()

    print(f"benchmark: micro-bench.py")
    print(f"revision:  {_git_sha()}")
    print(f"python:    {sys.version.split()[0]}")
    print(f"platform:  {platform.platform()}")
    print(f"runs:      {args.runs}")
    print(f"warmup:    {args.warmup}")
    print()

    inp = setup()

    results: dict[str, dict[str, float]] = {}
    if args.only in ("baseline", "both"):
        results["baseline"] = _bench(baseline, inp, args.runs, args.warmup)
    if args.only in ("treatment", "both"):
        results["treatment"] = _bench(treatment, inp, args.runs, args.warmup)

    for name, stats in results.items():
        print(f"-- {name} (ms) --")
        for k in ("p50", "p95", "p99", "mean", "stdev", "min", "max"):
            print(f"  {k:5s}: {stats[k]:.4f}")
        print()

    if "baseline" in results and "treatment" in results:
        b, t = results["baseline"], results["treatment"]
        delta_pct = (t["p50"] - b["p50"]) / b["p50"] * 100
        sign = "+" if delta_pct >= 0 else ""
        verdict = "slower" if delta_pct > 0 else "faster"
        print(f"-- delta (p50) --")
        print(f"  treatment is {sign}{delta_pct:.2f}% ({verdict})")
        print(f"  beware: ignore deltas smaller than baseline stdev / mean ratio")
        ratio = b["stdev"] / b["mean"] * 100 if b["mean"] else float("inf")
        print(f"  baseline noise floor: ~{ratio:.2f}%")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
