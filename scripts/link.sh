#!/bin/bash
# link.sh — link the dotfiles into $HOME, or check that the links are intact.
#
# Usage: link.sh          create missing links; never overwrites anything
#        link.sh --check  report links that are missing or were replaced;
#                         exits 1 if any are
#
# Tools sometimes replace a linked file with a regular copy (pnpm setup
# rewrote ~/.zshrc, pi-usage rewrote its config). Edits in the repo then stop
# applying without any sign, so --check exists to surface that drift; the
# shell runs it at startup (see .zshrc).

set -euo pipefail

# ~/.dotfiles is a fixed location: .zshenv exports it as DOTPATH and other
# scripts rely on it, so a clone elsewhere would link a different (or missing)
# repo. Stop instead of linking whatever happens to be at ~/.dotfiles.
DOTPATH=$HOME/.dotfiles
if [ "$(cd "$(dirname "$0")" && pwd -P)" != "$(cd "$DOTPATH/scripts" 2>/dev/null && pwd -P)" ]; then
  echo "link.sh must run from $DOTPATH/scripts; clone the repo to $DOTPATH" >&2
  exit 1
fi

source "$DOTPATH/scripts/colors.sh"

# Entries the directory sweeps skip: repo metadata, docs, and dirs whose
# contents are linked selectively by plan_links below. ~/.config/herdr also
# holds runtime state (sockets, logs), so only its config file is linked.
EXCLUDE_PATH=(".git" ".gitattributes" ".config" ".config/herdr" ".agents" ".claude-work" ".pi" "home" "roles" "scripts" "AGENTS.md" "CLAUDE.md" "README.md")
EXCLUDE_FILES=(".DS_Store")

is_excluded() {
  local path=$1 ex
  for ex in "${EXCLUDE_PATH[@]}"; do
    [[ "$DOTPATH/$ex" == "$path" ]] && return 0
  done
  for ex in "${EXCLUDE_FILES[@]}"; do
    [[ "${path##*/}" == "$ex" ]] && return 0
  done
  return 1
}

# Every entry directly under base_dir, linked into link_dir by the same name
plan_dir_entries() {
  local base_dir=$1 link_dir=$2 path
  for path in "$base_dir"/* "$base_dir"/.??*; do
    [ -e "$path" ] || continue
    is_excluded "$path" && continue
    printf '%s\t%s\n' "$path" "$link_dir/${path##*/}"
  done
}

# The single list of links, as "from<TAB>to" lines; both modes read it.
plan_links() {
  plan_dir_entries "$DOTPATH" "$HOME"

  plan_dir_entries "$DOTPATH/.config" "$HOME/.config"
  printf '%s\t%s\n' "$DOTPATH/.config/herdr/config.toml" "$HOME/.config/herdr/config.toml"

  # ~/.pi/agent also holds runtime state and secrets (sessions, auth.json,
  # mcp-auth.json, models-store.json), and extensions/ is written by other
  # tools (moshi-hook installs its extension there), so link file by file.
  # Packages in settings.json are installed by pi itself on first launch.
  local path
  while IFS= read -r -d '' path; do
    printf '%s\t%s\n' "$path" "$HOME/.pi/agent/${path#"$DOTPATH/.pi/agent/"}"
  done < <(find "$DOTPATH/.pi/agent" -type f ! -name .DS_Store -print0 | sort -z)

  # Skills live in the Agent Skills location, which pi and codex read;
  # Claude Code only reads its own dir, so it gets a second link
  printf '%s\t%s\n' "$DOTPATH/.agents/skills" "$HOME/.agents/skills"
  printf '%s\t%s\n' "$DOTPATH/.agents/skills" "$HOME/.claude/skills"

  plan_dir_entries "$DOTPATH/home" "$HOME"

  # the work profile imports the shared ~/AGENTS.md and adds work-only rules;
  # ~/.claude-work also holds runtime state, so link only the file
  printf '%s\t%s\n' "$DOTPATH/.claude-work/CLAUDE.md" "$HOME/.claude-work/CLAUDE.md"
}

# Sets STATE to "ok", "missing", "elsewhere" (a link to another path) or
# "replaced" (a regular file or dir stands where the link should be).
# A variable rather than output: --check runs at every shell startup, and a
# subshell plus readlink per entry would double the startup time.
link_state() {
  local from=$1 to=$2
  if [ -h "$to" ]; then
    if [ "$to" -ef "$from" ]; then STATE=ok; else STATE=elsewhere; fi
  elif [ -e "$to" ]; then
    STATE=replaced
  else
    STATE=missing
  fi
}

do_link() {
  local from to
  while IFS=$'\t' read -r from to; do
    link_state "$from" "$to"
    case $STATE in
      ok) ;;
      missing)
        mkdir -p "$(dirname "$to")"
        ln -s "$from" "$to"
        echo -e "${C_GR}link${NC} $to -> $from"
        ;;
      elsewhere) echo -e "${C_YE}warn${NC} $to links to $(readlink "$to"), not $from" ;;
      replaced) echo -e "${C_YE}warn${NC} $to already exists; remove it to link $from" ;;
    esac
  done < <(plan_links)
}

do_check() {
  local from to problems=0
  while IFS=$'\t' read -r from to; do
    link_state "$from" "$to"
    case $STATE in
      ok) ;;
      missing) echo -e "${C_YE}dotfiles${NC} missing link: $to"; problems=1 ;;
      elsewhere) echo -e "${C_YE}dotfiles${NC} $to links to $(readlink "$to"), not the repo"; problems=1 ;;
      replaced) echo -e "${C_YE}dotfiles${NC} $to was replaced by a regular file; compare with: diff $from $to"; problems=1 ;;
    esac
  done < <(plan_links)
  return $problems
}

case "${1:-}" in
  "") do_link ;;
  --check) do_check ;;
  *) echo "usage: link.sh [--check]" >&2; exit 2 ;;
esac
