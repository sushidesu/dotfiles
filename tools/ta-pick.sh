#!/usr/bin/env bash
# ta-pick.sh — interactive tmux session picker.
#
# Sources candidates from:
#   - existing tmux sessions (MRU order)
#   - zoxide frecent directories (deduped against session paths)
#
# On selection:
#   - existing session → switch-client / attach-session
#   - directory        → create session (name derived from basename) then attach
#
# Invoked by:
#   - `ta` with no arguments (from shell)
#   - tmux keybind via `display-popup -E`

set -euo pipefail

if ! command -v fzf >/dev/null 2>&1; then
  printf 'ta-pick: fzf not found in PATH\n' >&2
  exit 1
fi
if ! command -v tmux >/dev/null 2>&1; then
  printf 'ta-pick: tmux not found in PATH\n' >&2
  exit 1
fi

candidates() {
  local session_paths=""
  local _unused name path short

  if tmux list-sessions >/dev/null 2>&1; then
    while IFS=$'\t' read -r _unused name path; do
      [[ -z "${name:-}" ]] && continue
      short="${path/#$HOME/~}"
      printf 'S\t%s\t%s\t[S] %-24s %s\n' "$name" "$path" "$name" "$short"
      session_paths+="$path"$'\n'
    done < <(
      tmux list-sessions -F $'#{session_last_attached}\t#{session_name}\t#{session_path}' 2>/dev/null \
        | sort -rn
    )
  fi

  if command -v zoxide >/dev/null 2>&1; then
    while IFS= read -r path; do
      [[ -z "$path" ]] && continue
      case $'\n'"$session_paths" in
        *$'\n'"$path"$'\n'*) continue ;;
      esac
      short="${path/#$HOME/~}"
      printf 'D\t\t%s\t    %s\n' "$path" "$short"
    done < <(zoxide query -l 2>/dev/null)
  fi
}

selected=$(
  candidates | fzf \
    --delimiter=$'\t' \
    --with-nth=4 \
    --no-sort \
    --height=60% \
    --reverse \
    --prompt='ta> ' \
    --preview='p={3}; printf "path: %s\n\n" "$p"; if [ -d "$p" ]; then (cd "$p" && git rev-parse --abbrev-ref HEAD 2>/dev/null | sed "s/^/branch: /"); echo; ls -A "$p" 2>/dev/null | head -40; fi' \
    --preview-window='right,50%,wrap'
) || exit 0

[[ -z "$selected" ]] && exit 0

IFS=$'\t' read -r sel_type sel_name sel_path _sel_display <<<"$selected"

name_from_path() {
  local n="${1##*/}"
  if [[ -z "$n" || "$n" == "/" ]]; then n="root"; fi
  if [[ "$n" == .* ]]; then n="_${n#.}"; fi
  n="${n//[^A-Za-z0-9_-]/-}"
  printf '%s\n' "$n"
}

attach_or_switch() {
  local target="=$1"
  if [[ -n "${TMUX:-}" ]]; then
    tmux switch-client -t "$target"
  else
    tmux attach-session -t "$target"
  fi
}

case "$sel_type" in
  S)
    attach_or_switch "$sel_name"
    ;;
  D)
    [[ -d "$sel_path" ]] || { printf 'ta-pick: not a directory: %s\n' "$sel_path" >&2; exit 1; }
    abs=$(cd "$sel_path" && pwd -P)
    new_name=$(name_from_path "$abs")
    if ! tmux has-session -t "=$new_name" 2>/dev/null; then
      tmux new-session -d -s "$new_name" -c "$abs"
    fi
    attach_or_switch "$new_name"
    ;;
  *)
    printf 'ta-pick: unknown selection type: %s\n' "$sel_type" >&2
    exit 1
    ;;
esac
