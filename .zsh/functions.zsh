_tmux_session_name_from_dir() {
  local dir="$1"
  local name="${dir:t}"

  if [[ -z "$name" || "$name" == "/" ]]; then
    name="root"
  fi

  # Avoid tmux target parsing ambiguity (for example names starting with ".").
  if [[ "$name" == .* ]]; then
    name="_${name#.}"
  fi

  # Keep session names tmux-friendly and easy to target.
  name="${name//[^A-Za-z0-9_-]/-}"
  print -r -- "$name"
}

_tmux_open_session_for_dir() {
  local dir="${1:-$PWD}"

  if [[ ! -d "$dir" ]]; then
    print -u2 "ta: directory not found: $dir"
    return 1
  fi

  dir="${dir:A}"
  local name="$(_tmux_session_name_from_dir "$dir")"
  local target="=$name"

  if ! tmux has-session -t "$target" 2>/dev/null; then
    tmux new-session -d -s "$name" -c "$dir" || return 1
  fi
  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$target"
  else
    tmux attach-session -t "$target"
  fi
}

ta() {
  local dir_input="$1"

  if [[ -z "$dir_input" && ! -t 0 ]]; then
    IFS= read -r dir_input
  fi

  if [[ -z "$dir_input" ]]; then
    local picker="$HOME/.dotfiles/bin/ta-pick"
    if [[ -x "$picker" ]]; then
      "$picker"
      return $?
    fi
    print -u2 "ta: picker not found at $picker"
    return 1
  fi

  _tmux_open_session_for_dir "$dir_input"
}

_register_tmux_dir_completions() {
  if ! typeset -f compdef >/dev/null 2>&1; then
    return
  fi

  compdef _directories ta

  if typeset -f add-zsh-hook >/dev/null 2>&1; then
    add-zsh-hook -d precmd _register_tmux_dir_completions
  fi
}

if typeset -f compdef >/dev/null 2>&1; then
  _register_tmux_dir_completions
else
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _register_tmux_dir_completions
fi

# Sync tmux server's global PATH with the current shell's PATH.
# Useful after installing new tools via mise — the tmux server's env is
# frozen at startup and won't pick up new install dirs until reloaded.
# Like `prefix + r` reloads tmux.conf, this reloads env vars.
tmux-reload-env() {
  if ! command -v tmux >/dev/null 2>&1; then
    print -u2 "tmux-reload-env: tmux not found"
    return 1
  fi
  tmux set-environment -g PATH "$PATH"
}
