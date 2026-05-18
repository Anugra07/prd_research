#!/usr/bin/env bash
# http-bench.sh - HTTP throughput and latency benchmark skeleton.
# Driven by `wrk` (https://github.com/wg/wrk). Install: `brew install wrk` or `apt install wrk`.
#
# Customize the TODO blocks below, then run:
#   ./http-bench.sh baseline
#   # apply change
#   ./http-bench.sh treatment
#   diff results/baseline.txt results/treatment.txt

set -euo pipefail

# ---- TODO: configure these ------------------------------------------------
URL="http://localhost:8080/TODO-endpoint"
DURATION="30s"          # measurement duration after warmup
WARMUP="10s"            # discarded
THREADS=4               # wrk worker threads
CONNECTIONS=64          # concurrent connections
# Optional: a wrk Lua script for POST bodies, custom headers, scenario sequencing.
# WRK_SCRIPT="./post.lua"
# ---------------------------------------------------------------------------

LABEL="${1:-run}"
mkdir -p results

if ! command -v wrk >/dev/null 2>&1; then
  echo "error: wrk not installed. brew install wrk OR apt install wrk" >&2
  exit 1
fi

GIT_SHA=$(git rev-parse --short HEAD 2>/dev/null || echo "uncommitted")
DATE=$(date -u +%Y-%m-%dT%H:%M:%SZ)
HW=$(uname -smr)

OUT="results/${LABEL}.txt"

{
  echo "benchmark: http-bench"
  echo "label:     $LABEL"
  echo "revision:  $GIT_SHA"
  echo "date:      $DATE"
  echo "hardware:  $HW"
  echo "url:       $URL"
  echo "threads:   $THREADS"
  echo "conns:     $CONNECTIONS"
  echo "warmup:    $WARMUP"
  echo "duration:  $DURATION"
  echo

  echo "-- warmup --"
  wrk -t"$THREADS" -c"$CONNECTIONS" -d"$WARMUP" --latency "$URL" >/dev/null

  echo "-- measurement --"
  wrk -t"$THREADS" -c"$CONNECTIONS" -d"$DURATION" --latency "$URL"
} | tee "$OUT"

echo
echo "wrote $OUT"
echo "tip: also inspect server-side metrics (CPU, memory, DB time) during the run"
