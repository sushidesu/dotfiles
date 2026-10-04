#!/bin/bash

# .config/herdr is excluded from the .config sweep: ~/.config/herdr holds
# runtime state (sockets, logs), so only config.toml gets linked below
EXCLUDE_PATH=(".git" ".config" ".config/herdr" ".claude" ".codex" ".pi" "home" "scripts" "AGENTS.md" "CLAUDE.md" "README.md")
EXCLUDE_FILES=(".DS_Store")
# ~/.dotfiles is a fixed location: .zshenv exports it as DOTPATH and other
# scripts rely on it, so a clone elsewhere would link a different (or missing)
# repo. Stop instead of linking whatever happens to be at ~/.dotfiles.
DOTPATH=$HOME/.dotfiles
if [ "$(cd "$(dirname "$0")" && pwd -P)" != "$(cd "$DOTPATH/scripts" 2>/dev/null && pwd -P)" ]; then
  echo "link.sh must run from $DOTPATH/scripts; clone the repo to $DOTPATH" >&2
  exit 1
fi

source "$DOTPATH/scripts/colors.sh"

function message() {
  echo -e "${C_LGY}------ LINK \"$1\"${NC}"
}
function message_skip() {
  echo -e "${C_BL}skip${NC} $1"
}
function message_warn() {
  echo -e "${C_YE}warn${NC} $1"
}
function message_link() {
  echo -e "${C_GR}link${NC} $1 -> $2"
}

# Links from -> to, and leaves anything already at `to` untouched. A target
# that is not our link is reported instead of skipped silently, so stale or
# conflicting links surface rather than looking "already linked".
function linking() {
  local from=$1
  local to=$2

  if [ -h "$to" ]; then
    local current
    current=$(readlink "$to")
    if [ "$current" == "$from" ]; then
      message_skip "$to is already linked"
    else
      message_warn "$to is linked to $current, not $from"
    fi
  elif [ -e "$to" ]; then
    message_warn "$to already exists; remove it to link $from"
  else
    message_link "$from" "$to"
    ln -s "$from" "$to"
  fi
}

function is_exclude() {
  local path=$1
  local ex name
  for ex in "${EXCLUDE_PATH[@]}"; do
    if [[ "$DOTPATH/$ex" == "$path" ]]; then
      return 0
    fi
  done
  for name in "${EXCLUDE_FILES[@]}"; do
    if [[ "${path##*/}" == "$name" ]]; then
      return 0
    fi
  done
  return 1
}

# Links every entry directly under base_dir into link_dir, by the same name
function link_anywhere() {
  local base_dir=$1
  local link_dir=$2
  local path

  for path in "$base_dir"/* "$base_dir"/.??*; do
    if [ ! -e "$path" ] || is_exclude "$path"; then
      continue
    fi
    linking "$path" "$link_dir/${path##*/}"
  done
}

message "\$DOTPATH/*"
link_anywhere "$DOTPATH" "$HOME"

message "\$DOTPATH/.config/*"
mkdir -p "$HOME/.config"
link_anywhere "$DOTPATH/.config" "$HOME/.config"

# ~/.config/herdr also holds runtime state (sockets, logs),
# so link only the config file, not the directory
message "\$DOTPATH/.config/herdr/config.toml"
mkdir -p "$HOME/.config/herdr"
linking "$DOTPATH/.config/herdr/config.toml" "$HOME/.config/herdr/config.toml"

# ~/.pi is shared with Claude Code (~/.Claude Code -> ~/.pi) and holds runtime
# state (sessions, auth, model store), so link only the hand-maintained files:
# settings.json (theme/provider/model/packages) and keybindings.json
message "\$DOTPATH/.pi/agent/*"
mkdir -p "$HOME/.pi/agent"
linking "$DOTPATH/.pi/agent/settings.json" "$HOME/.pi/agent/settings.json"
linking "$DOTPATH/.pi/agent/keybindings.json" "$HOME/.pi/agent/keybindings.json"

# extensions/ is also written by other tools (Orca installs its own extensions
# there), so link only the files dotfiles owns instead of the whole dir
message "\$DOTPATH/.pi/agent/extensions/powerline-footer/theme.json"
mkdir -p "$HOME/.pi/agent/extensions/powerline-footer"
linking "$DOTPATH/.pi/agent/extensions/powerline-footer/theme.json" "$HOME/.pi/agent/extensions/powerline-footer/theme.json"

message "\$DOTPATH/.claude/commands/*"
mkdir -p "$HOME/.claude"
linking "$DOTPATH/.claude/commands" "$HOME/.claude/commands"

message "\$DOTPATH/.claude/commands -> ~/.codex/prompts"
mkdir -p "$HOME/.codex"
linking "$DOTPATH/.claude/commands" "$HOME/.codex/prompts"

message "\$DOTPATH/.claude/skills/*"
linking "$DOTPATH/.claude/skills" "$HOME/.claude/skills"

message "\$DOTPATH/.claude/skills -> ~/.codex/skills"
linking "$DOTPATH/.claude/skills" "$HOME/.codex/skills"

message "\$DOTPATH/home/*"
link_anywhere "$DOTPATH/home" "$HOME"

message "\$DOTPATH/home/CLAUDE.md -> ~/.claude-work/CLAUDE.md"
mkdir -p "$HOME/.claude-work"
linking "$DOTPATH/home/CLAUDE.md" "$HOME/.claude-work/CLAUDE.md"
