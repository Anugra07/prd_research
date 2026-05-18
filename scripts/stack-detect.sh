#!/usr/bin/env bash
# stack-detect.sh - first-pass detector for languages, package managers, frameworks, and rough LOC.
# Usage: stack-detect.sh [project-root]
# Output is a hint for the project-optimizer skill, not authoritative.

set -u

ROOT="${1:-.}"

if [ ! -d "$ROOT" ]; then
  echo "error: '$ROOT' is not a directory" >&2
  exit 1
fi

cd "$ROOT" || exit 1

echo "=== project-optimizer: stack detection ==="
echo "root: $(pwd)"
echo

# --- package managers / manifests ---
echo "--- manifests / package managers ---"
found_any=0
for f in \
  package.json pnpm-lock.yaml yarn.lock package-lock.json bun.lockb \
  pyproject.toml requirements.txt Pipfile poetry.lock uv.lock setup.py \
  Cargo.toml go.mod go.sum \
  Gemfile Gemfile.lock \
  composer.json composer.lock \
  pom.xml build.gradle build.gradle.kts settings.gradle settings.gradle.kts \
  mix.exs rebar.config \
  Package.swift Podfile Podfile.lock \
  pubspec.yaml \
  CMakeLists.txt Makefile \
  Dockerfile docker-compose.yml docker-compose.yaml compose.yml compose.yaml \
  .terraform terraform.tf main.tf \
  flake.nix shell.nix default.nix \
  deno.json deno.jsonc \
  .tool-versions .nvmrc .python-version .ruby-version
do
  if [ -e "$f" ]; then
    echo "  found: $f"
    found_any=1
  fi
done
[ "$found_any" -eq 0 ] && echo "  (none detected at project root)"
echo

# --- infra / deploy hints ---
echo "--- infra / deploy hints ---"
for d in k8s kubernetes helm infra terraform .github/workflows .gitlab-ci ansible deploy charts; do
  if [ -e "$d" ]; then
    echo "  found: $d"
  fi
done
echo

# --- language breakdown by file extension (rough LOC) ---
echo "--- language breakdown (file count and rough LOC) ---"

# Build a pruned find that skips heavy junk dirs.
PRUNE='-not -path */.git/* -not -path */node_modules/* -not -path */.venv/* -not -path */venv/* -not -path */__pycache__/* -not -path */dist/* -not -path */build/* -not -path */target/* -not -path */.next/* -not -path */.nuxt/* -not -path */vendor/* -not -path */.gradle/* -not -path */.idea/* -not -path */.vscode/*'

# ext:label pairs - longer/more specific extensions first to avoid mis-grouping (e.g. .tsx before .ts)
exts="tsx:TypeScript-React jsx:JavaScript-React ts:TypeScript js:JavaScript mjs:JavaScript cjs:JavaScript py:Python rs:Rust go:Go java:Java kt:Kotlin swift:Swift m:Objective-C mm:Objective-C++ rb:Ruby php:PHP cs:C# fs:F# scala:Scala clj:Clojure ex:Elixir exs:Elixir erl:Erlang hs:Haskell ml:OCaml lua:Lua dart:Dart c:C h:C-header cpp:C++ cc:C++ cxx:C++ hpp:C++-header hh:C++-header sh:Shell bash:Shell zsh:Shell sql:SQL html:HTML css:CSS scss:SCSS vue:Vue svelte:Svelte tf:Terraform"

for pair in $exts; do
  ext="${pair%%:*}"
  label="${pair##*:}"
  # shellcheck disable=SC2086
  files=$(find . -type f -name "*.${ext}" $PRUNE 2>/dev/null)
  if [ -n "$files" ]; then
    count=$(printf '%s\n' "$files" | wc -l | tr -d ' ')
    # rough LOC via wc -l; ignore failures on weird files
    loc=$(printf '%s\n' "$files" | tr '\n' '\0' | xargs -0 wc -l 2>/dev/null | tail -n1 | awk '{print $1}')
    [ -z "$loc" ] && loc="?"
    printf "  %-22s files=%-6s loc=%s\n" "$label(.$ext)" "$count" "$loc"
  fi
done
echo

# --- framework hints (cheap signal, not authoritative) ---
echo "--- framework hints ---"
hint() { [ -e "$1" ] && echo "  $2"; }
grep_hint() {
  # $1 file, $2 pattern, $3 label
  if [ -f "$1" ] && grep -qE "$2" "$1" 2>/dev/null; then
    echo "  $3"
  fi
}

grep_hint package.json '"next"' 'Next.js (package.json)'
grep_hint package.json '"react"' 'React (package.json)'
grep_hint package.json '"vue"' 'Vue (package.json)'
grep_hint package.json '"svelte"' 'Svelte (package.json)'
grep_hint package.json '"express"' 'Express (package.json)'
grep_hint package.json '"fastify"' 'Fastify (package.json)'
grep_hint package.json '"@nestjs/core"' 'NestJS (package.json)'
grep_hint package.json '"hono"' 'Hono (package.json)'

grep_hint pyproject.toml 'django' 'Django (pyproject.toml)'
grep_hint pyproject.toml 'fastapi' 'FastAPI (pyproject.toml)'
grep_hint pyproject.toml 'flask' 'Flask (pyproject.toml)'
grep_hint requirements.txt '^django' 'Django (requirements.txt)'
grep_hint requirements.txt '^fastapi' 'FastAPI (requirements.txt)'
grep_hint requirements.txt '^flask' 'Flask (requirements.txt)'

grep_hint Cargo.toml 'axum' 'Axum (Cargo.toml)'
grep_hint Cargo.toml 'actix-web' 'Actix-web (Cargo.toml)'
grep_hint Cargo.toml 'tokio' 'Tokio (Cargo.toml)'

grep_hint go.mod 'gin-gonic/gin' 'Gin (go.mod)'
grep_hint go.mod 'labstack/echo' 'Echo (go.mod)'
grep_hint go.mod 'fiber' 'Fiber (go.mod)'

hint Gemfile 'Ruby project (Gemfile present)'
grep_hint Gemfile 'rails' 'Rails (Gemfile)'

echo
echo "=== end stack detection ==="
