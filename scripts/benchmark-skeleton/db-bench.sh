#!/usr/bin/env bash
# db-bench.sh - database query performance benchmark skeleton.
# Defaults to PostgreSQL via psql. Adapt the QUERY and CLIENT for your DB.
#
# Usage:
#   ./db-bench.sh baseline
#   # apply schema/index/query change
#   ./db-bench.sh treatment
#   diff results/baseline.txt results/treatment.txt

set -euo pipefail

# ---- TODO: configure these ------------------------------------------------
DB_URL="${DB_URL:-postgres://user:pass@localhost:5432/dbname}"   # or set in env
QUERY_FILE="./query.sql"                                          # TODO: write the query you want to measure
RUNS=50                                                           # measured samples
WARMUP=10                                                         # discarded
# For MySQL: replace `psql` with `mysql --batch -e "$(cat $QUERY_FILE)"`
# For SQLite: replace with `sqlite3 path/to.db < $QUERY_FILE`
CLIENT_CMD="psql \"$DB_URL\" -X -q -t -A -f $QUERY_FILE"
# ---------------------------------------------------------------------------

LABEL="${1:-run}"
mkdir -p results

if [ ! -f "$QUERY_FILE" ]; then
  echo "error: $QUERY_FILE not found. Write the query you want to measure into it." >&2
  exit 1
fi

GIT_SHA=$(git rev-parse --short HEAD 2>/dev/null || echo "uncommitted")
DATE=$(date -u +%Y-%m-%dT%H:%M:%SZ)
HW=$(uname -smr)
OUT="results/${LABEL}.txt"

# helper: run query once, print elapsed in ms
time_one_ms() {
  # `time` to a temp; psql to /dev/null
  local start_ns end_ns
  start_ns=$(python3 -c 'import time; print(time.perf_counter_ns())')
  eval "$CLIENT_CMD" >/dev/null
  end_ns=$(python3 -c 'import time; print(time.perf_counter_ns())')
  echo "scale=3; ($end_ns - $start_ns) / 1000000" | bc
}

{
  echo "benchmark: db-bench"
  echo "label:     $LABEL"
  echo "revision:  $GIT_SHA"
  echo "date:      $DATE"
  echo "hardware:  $HW"
  echo "db_url:    ${DB_URL%%@*}@..."
  echo "query:     $QUERY_FILE"
  echo "warmup:    $WARMUP"
  echo "runs:      $RUNS"
  echo
  echo "-- warmup ($WARMUP runs, discarded) --"
  for _ in $(seq 1 "$WARMUP"); do
    time_one_ms >/dev/null
  done

  echo "-- measurement ($RUNS runs) --"
  samples_file=$(mktemp)
  for i in $(seq 1 "$RUNS"); do
    t=$(time_one_ms)
    echo "$t" >> "$samples_file"
    printf "run %3d: %s ms\n" "$i" "$t"
  done

  echo
  echo "-- stats (ms) --"
  python3 - "$samples_file" <<'PY'
import statistics, sys
vals = [float(x.strip()) for x in open(sys.argv[1]) if x.strip()]
vals.sort()
def pct(p):
    k = max(0, min(len(vals)-1, int(round(p/100*(len(vals)-1)))))
    return vals[k]
print(f"  p50:   {pct(50):.3f}")
print(f"  p95:   {pct(95):.3f}")
print(f"  p99:   {pct(99):.3f}")
print(f"  mean:  {statistics.fmean(vals):.3f}")
print(f"  stdev: {statistics.pstdev(vals):.3f}")
print(f"  min:   {min(vals):.3f}")
print(f"  max:   {max(vals):.3f}")
PY
  rm -f "$samples_file"
} | tee "$OUT"

echo
echo "wrote $OUT"
echo "tip: also capture EXPLAIN (ANALYZE, BUFFERS) before and after - the plan tells you why, the timing tells you how much"
