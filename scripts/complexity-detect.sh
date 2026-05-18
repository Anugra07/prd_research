#!/usr/bin/env bash
# complexity-detect.sh - estimate project complexity and suggest a project-optimizer tier.
# Usage: complexity-detect.sh [project-root]
# Output is a HINT. The skill applies the final tier decision (and respects user overrides).

set -u

ROOT="${1:-.}"

if [ ! -d "$ROOT" ]; then
  echo "error: '$ROOT' is not a directory" >&2
  exit 1
fi

cd "$ROOT" || exit 1

echo "=== project-optimizer: complexity detection ==="
echo "root: $(pwd)"
echo

PRUNE='-not -path */.git/* -not -path */node_modules/* -not -path */.venv/* -not -path */venv/* -not -path */__pycache__/* -not -path */dist/* -not -path */build/* -not -path */target/* -not -path */.next/* -not -path */.nuxt/* -not -path */vendor/* -not -path */.gradle/* -not -path */.idea/* -not -path */.vscode/*'

# --- LOC across common source extensions ---
exts="tsx jsx ts js mjs cjs py rs go java kt swift m mm rb php cs fs scala clj ex exs erl hs ml lua dart c h cpp cc cxx hpp hh sh sql"

total_loc=0
for ext in $exts; do
  # shellcheck disable=SC2086
  files=$(find . -type f -name "*.${ext}" $PRUNE 2>/dev/null)
  if [ -n "$files" ]; then
    loc=$(printf '%s\n' "$files" | tr '\n' '\0' | xargs -0 wc -l 2>/dev/null | tail -n1 | awk '{print $1}')
    [ -z "$loc" ] && loc=0
    total_loc=$((total_loc + loc))
  fi
done
echo "total source LOC: $total_loc"

# --- top-level module count (directories under src/, app/, services/, packages/, cmd/, internal/) ---
module_count=0
for mdir in src app services packages cmd internal pkg apps modules lib libs; do
  if [ -d "$mdir" ]; then
    c=$(find "$mdir" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
    if [ "$c" -gt "$module_count" ]; then
      module_count="$c"
    fi
  fi
done
echo "top-level module count (best guess): $module_count"

# --- distributed-system markers ---
echo
echo "--- distributed-system markers ---"
markers=0
mark() { echo "  $1"; markers=$((markers + 1)); }

# orchestration
if [ -d "k8s" ] || [ -d "kubernetes" ] || [ -d "helm" ] || [ -d "charts" ]; then
  mark "kubernetes/helm directory present"
fi
if find . -maxdepth 4 -type f \( -name "*.yaml" -o -name "*.yml" \) $PRUNE 2>/dev/null | xargs grep -l -E 'apiVersion:.*(apps|batch|networking)' 2>/dev/null | head -1 | grep -q .; then
  mark "kubernetes manifests detected"
fi

# multiple datastores
db_hits=0
for pat in 'postgres' 'mysql' 'mongodb' 'redis' 'cassandra' 'dynamodb' 'clickhouse' 'elasticsearch' 'opensearch' 'kafka' 'rabbitmq' 'nats' 'pulsar' 'sqs'; do
  if grep -r -i -l "$pat" --include='*.toml' --include='*.json' --include='*.yaml' --include='*.yml' --include='*.env*' --include='Dockerfile*' --include='*.tf' . 2>/dev/null | head -1 | grep -q .; then
    db_hits=$((db_hits + 1))
  fi
done
if [ "$db_hits" -ge 2 ]; then
  mark "multiple datastores or message queues referenced ($db_hits hits)"
fi

# compose / multi-service
if [ -f docker-compose.yml ] || [ -f docker-compose.yaml ] || [ -f compose.yml ] || [ -f compose.yaml ]; then
  svc_count=$(grep -cE '^\s{2}[a-zA-Z0-9_-]+:\s*$' docker-compose.yml docker-compose.yaml compose.yml compose.yaml 2>/dev/null | awk -F: '{s+=$NF} END {print s+0}')
  if [ "$svc_count" -ge 3 ]; then
    mark "compose file with >=3 services ($svc_count)"
  fi
fi

# infra-as-code
if find . -maxdepth 3 -name '*.tf' $PRUNE 2>/dev/null | head -1 | grep -q .; then
  mark "terraform files present"
fi

# microservice-ish layout
if [ -d "services" ] || [ -d "apps" ]; then
  c=$(find services apps -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
  if [ "$c" -ge 3 ]; then
    mark "monorepo with $c top-level services/apps"
  fi
fi

# message queues / streaming hints in source
if grep -r -i -l -E '(kafka|rabbitmq|nats|pulsar|sqs|kinesis|pubsub)\b' --include='*.py' --include='*.ts' --include='*.js' --include='*.go' --include='*.rs' --include='*.java' --include='*.kt' . 2>/dev/null | head -1 | grep -q .; then
  mark "message queue / streaming client referenced in source"
fi

[ "$markers" -eq 0 ] && echo "  (no distributed markers detected)"

echo
echo "--- summary ---"
echo "LOC:           $total_loc"
echo "modules:       $module_count"
echo "dist markers:  $markers"

# --- tier suggestion ---
tier=1
reason="LOC < 2k, no distributed markers"

if [ "$total_loc" -ge 2000 ] || [ "$module_count" -ge 2 ] || [ "$db_hits" -ge 1 ]; then
  tier=2
  reason="LOC >= 2k OR multiple modules OR datastore in stack"
fi

if [ "$total_loc" -ge 20000 ] || [ "$markers" -ge 2 ]; then
  tier=3
  reason="LOC >= 20k OR multiple distributed-system markers"
fi

echo
echo "suggested tier: $tier"
echo "reason:         $reason"
echo
echo "Note: the skill applies the final tier decision and respects explicit user overrides"
echo "      ('run in deep mode' -> Tier 3 regardless of these numbers)."
echo
echo "=== end complexity detection ==="
