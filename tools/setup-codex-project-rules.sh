#!/bin/bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: setup-codex-project-rules.sh [target_dir]

Create project-local Codex config and rules:
  <target_dir>/.codex/config.toml
  <target_dir>/.codex/rules/default.rules

If target_dir is omitted, the current directory is used.
This script is idempotent for the git prefix rules.
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

target_dir="${1:-$PWD}"

if [[ ! -d "$target_dir" ]]; then
  echo "Error: target directory does not exist: $target_dir" >&2
  exit 1
fi

target_dir="$(cd "$target_dir" && pwd)"
codex_dir="$target_dir/.codex"
rules_dir="$codex_dir/rules"
config_file="$codex_dir/config.toml"
rules_file="$rules_dir/default.rules"

mkdir -p "$rules_dir"

if [[ ! -f "$config_file" ]]; then
  cat > "$config_file" <<EOF
# Project-local Codex settings
[projects."$target_dir"]
trust_level = "trusted"
EOF
  echo "Created: $config_file"
else
  if ! rg -q '^\[projects\."'"$target_dir"'"\]$' "$config_file"; then
    cat >> "$config_file" <<EOF

[projects."$target_dir"]
trust_level = "trusted"
EOF
    echo "Updated: $config_file (added project trust block)"
  else
    echo "Skipped: $config_file (project trust block already exists)"
  fi
fi

add_rule_if_missing() {
  local rule="$1"
  if [[ ! -f "$rules_file" ]]; then
    printf '%s\n' "$rule" > "$rules_file"
    return
  fi

  if ! rg -F -q "$rule" "$rules_file"; then
    printf '%s\n' "$rule" >> "$rules_file"
  fi
}

add_rule_if_missing 'prefix_rule(pattern=["git", "add"], decision="allow")'
add_rule_if_missing 'prefix_rule(pattern=["git", "commit"], decision="allow")'

echo "Ensured rules in: $rules_file"
echo
echo "Next:"
echo "1) Restart Codex in this project."
echo "2) Verify from project root: ls -la .codex .codex/rules"
