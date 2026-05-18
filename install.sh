#!/usr/bin/env bash
# install.sh - download and install the project-optimizer Claude skill.
# No git required. Downloads the source tarball from GitHub.
#
# One-line install (recommended):
#   curl -fsSL https://raw.githubusercontent.com/Anugra07/prd_research/main/install.sh | bash
#
# Or, after downloading this file:
#   bash install.sh
#
# Env vars (all optional):
#   SKILL_DIR    install location (default: ~/.claude/skills/project-optimizer)
#   SKILL_REF    git ref to download (default: main)
#   SKILL_FORCE  if "1", overwrite an existing install without backing it up
#   SKIP_DEPS    if "1", skip the optional-dependency check at the end

set -euo pipefail

REPO="Anugra07/prd_research"
SKILL_NAME="project-optimizer"
DEFAULT_DIR="${HOME}/.claude/skills/${SKILL_NAME}"
SKILL_DIR="${SKILL_DIR:-$DEFAULT_DIR}"
SKILL_REF="${SKILL_REF:-main}"
SKILL_FORCE="${SKILL_FORCE:-0}"
SKIP_DEPS="${SKIP_DEPS:-0}"

say()  { printf '[install] %s\n' "$*"; }
warn() { printf '[install] warn: %s\n' "$*" >&2; }
die()  { printf '[install] error: %s\n' "$*" >&2; exit 1; }

# ---- preflight ----
case "$(uname -s)" in
  Darwin) say "macOS detected" ;;
  Linux)  say "Linux detected (installer also works here)" ;;
  *)      die "unsupported OS: $(uname -s). This installer targets macOS/Linux." ;;
esac

command -v curl >/dev/null 2>&1 || die "curl not found. Install curl and retry."
command -v tar  >/dev/null 2>&1 || die "tar not found."

# ---- handle existing install ----
if [ -e "$SKILL_DIR" ]; then
  if [ "$SKILL_FORCE" = "1" ]; then
    say "removing existing install at $SKILL_DIR (SKILL_FORCE=1)"
    rm -rf "$SKILL_DIR"
  else
    backup="${SKILL_DIR}.backup.$(date +%Y%m%d-%H%M%S)"
    say "existing install found - backing up to: $backup"
    mv "$SKILL_DIR" "$backup"
  fi
fi

# ---- download ----
tmpdir=$(mktemp -d -t project-optimizer-install.XXXXXX)
trap 'rm -rf "$tmpdir"' EXIT

url="https://codeload.github.com/${REPO}/tar.gz/refs/heads/${SKILL_REF}"
say "downloading: $url"
curl -fsSL "$url" -o "${tmpdir}/src.tar.gz" || die "download failed (check network and that ref '$SKILL_REF' exists)"

say "extracting"
tar -xzf "${tmpdir}/src.tar.gz" -C "$tmpdir"

# GitHub tarball top-level dir is "<repo-basename>-<ref>"
extracted_dir=$(find "$tmpdir" -maxdepth 1 -mindepth 1 -type d -name 'prd_research-*' | head -1)
[ -n "$extracted_dir" ] || die "could not find extracted source directory in tarball"

# ---- install ----
mkdir -p "$(dirname "$SKILL_DIR")"
mv "$extracted_dir" "$SKILL_DIR"

# Belt and suspenders - tar preserves exec bits, but ensure scripts are executable.
chmod +x \
  "$SKILL_DIR"/scripts/*.sh \
  "$SKILL_DIR"/scripts/benchmark-skeleton/*.sh \
  "$SKILL_DIR"/scripts/benchmark-skeleton/*.py \
  "$SKILL_DIR"/scripts/benchmark-skeleton/*.js \
  2>/dev/null || true

# ---- verify ----
[ -f "${SKILL_DIR}/SKILL.md" ] || die "install looks incomplete - SKILL.md missing at $SKILL_DIR"

say ""
say "installed at: $SKILL_DIR"

# ---- optional deps check ----
if [ "$SKIP_DEPS" != "1" ]; then
  say ""
  say "optional dependencies (only needed when running benchmark skeletons):"
  check() {
    if command -v "$1" >/dev/null 2>&1; then
      printf '  [ok]    %-8s - %s\n' "$1" "$2"
    else
      printf '  [miss]  %-8s - %s  (install: %s)\n' "$1" "$2" "$3"
    fi
  }
  check python3 "micro-bench.py"           "preinstalled on macOS, or 'brew install python'"
  check node    "micro-bench.js"           "brew install node"
  check wrk     "http-bench.sh"            "brew install wrk"
  check psql    "db-bench.sh (Postgres)"   "brew install libpq && brew link --force libpq"
  check bc      "db-bench.sh math"         "preinstalled on macOS, 'apt install bc' on Linux"
fi

say ""
say "done. Claude Code will discover the skill on next launch (or after /reload)."
say "trigger it by asking Claude to 'optimize my project' inside any project directory."
