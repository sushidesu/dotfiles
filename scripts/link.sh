#!/bin/bash

# .config/herdr is excluded from the .config sweep: ~/.config/herdr holds
# runtime state (sockets, logs), so only config.toml gets linked below
EXCLUDE_PATH=(".git" ".config" ".config/herdr" ".claude" ".codex" "home" "scripts" "AGENTS.md" "CLAUDE.md")
EXCLUDE_FILES=(".DS_Store")
DOTPATH=$HOME/.dotfiles

# enable echo in color
source "$DOTPATH/scripts/colors.sh"

function message_skip() {
  echo -e "${C_BL}skip${NC} $1"
}
function message_warn() {
  echo -e "${C_YE}warn${NC} $1"
}
function message_link() {
  echo -e "${C_GR}link${NC} $1 -> $2"
}

function linking() {
  local from_name=$1
  local to_name=$2

  if [ -h "$to_name" ]; then
    local current
    current=$(readlink "$to_name")
    if [ "$current" == "$from_name" ]; then
      message_skip "${to_name} is already linked"
    else
      message_warn "${to_name} is linked to ${current}, not ${from_name}"
    fi
  elif [ -d "$to_name" ]; then
    message_skip "${to_name} is directory"
  elif [ -e "$to_name" ]; then
    message_warn "${to_name} already exists; remove it to link ${from_name}"
  else
    message_link "$from_name" "$to_name"
    ln -s "$from_name" "$to_name"
  fi
}

function is_exclude() {
  local filename=$1
  for ex in "${EXCLUDE_PATH[@]}"; do
    if [[ "$DOTPATH/$ex" == "$filename" ]]; then
      return 0
    fi
  done
  for name in "${EXCLUDE_FILES[@]}"; do
    if [[ "${filename##*/}" == "$name" ]]; then
      return 0
    fi
  done
  return 1
}

function link_anywhere() {
  local base_dir=$1
  local link_dir=$2
  local file

  for file in "$base_dir"/* "$base_dir"/.??*; do
    if [ ! -e "$file" ]; then
      continue
    fi
    if is_exclude "$file"; then
      continue
    fi
    linking "$file" "$link_dir/${file##*/}"
  done
}

function message() {
  local target=$1
  echo -e "${C_LGY}------ LINK \"${target}\"${NC}"
}

function ensure_dir() {
  local dir=$1
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
  fi
}

message "\$DOTPATH/*"
link_anywhere "$DOTPATH" "$HOME"

message "\$DOTPATH/.config/*"
ensure_dir "$HOME/.config"
link_anywhere "$DOTPATH/.config" "$HOME/.config"

# ~/.config/herdr also holds runtime state (sockets, logs),
# so link only the config file, not the directory
message "\$DOTPATH/.config/herdr/config.toml"
ensure_dir "$HOME/.config/herdr"
linking "$DOTPATH/.config/herdr/config.toml" "$HOME/.config/herdr/config.toml"

message "\$DOTPATH/.claude/commands/*"
ensure_dir "$HOME/.claude"
linking "$DOTPATH/.claude/commands" "$HOME/.claude/commands"

message "\$DOTPATH/.claude/commands -> ~/.codex/prompts"
ensure_dir "$HOME/.codex"
linking "$DOTPATH/.claude/commands" "$HOME/.codex/prompts"

message "\$DOTPATH/.claude/skills/*"
ensure_dir "$HOME/.claude"
linking "$DOTPATH/.claude/skills" "$HOME/.claude/skills"

message "\$DOTPATH/.claude/skills -> ~/.codex/skills"
ensure_dir "$HOME/.codex"
linking "$DOTPATH/.claude/skills" "$HOME/.codex/skills"

message "\$DOTPATH/home/*"
link_anywhere "$DOTPATH/home" "$HOME"

message "\$DOTPATH/home/CLAUDE.md -> ~/.claude-work/CLAUDE.md"
ensure_dir "$HOME/.claude-work"
linking "$DOTPATH/home/CLAUDE.md" "$HOME/.claude-work/CLAUDE.md"
