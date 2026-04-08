#!/usr/bin/env bash
# Fast-forward pull from origin/main for this repo (MINERVA local copy).
set -euo pipefail
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:/usr/local/bin:${PATH:-}"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export GIT_TERMINAL_PROMPT=0
exec git -C "$REPO_ROOT" pull --ff-only origin main
