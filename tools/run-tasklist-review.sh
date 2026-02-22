#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: run-tasklist-review.sh [count]

Run `codex exec` with `Use $tasklist-review` sequentially.
Defaults to 5 runs when count is omitted.
USAGE
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

count="${1:-5}"

if ! [[ "$count" =~ ^[1-9][0-9]*$ ]]; then
  usage >&2
  exit 1
fi

if ! command -v codex >/dev/null 2>&1; then
  echo "Error: codex command not found in PATH" >&2
  exit 1
fi

for ((i = 1; i <= count; i++)); do
  echo "[$i/$count] Running tasklist-review"

  if codex -a untrusted -s workspace-write exec 'Use $tasklist-review'; then
    :
  else
    code=$?
    echo "Error: tasklist-review failed at run $i (exit: $code)" >&2
    exit 1
  fi
done

echo "Completed $count runs successfully."
