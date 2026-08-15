#!/bin/bash

# .config/herdr is excluded from the .config sweep: ~/.config/herdr holds
# runtime state (sockets, logs), so only config.toml gets linked below
EXCLUDE_PATH=(".git" ".config" ".config/herdr" ".claude" ".codex" ".pi" "home" "scripts" "AGENTS.md" "CLAUDE.md")
EXCLUDE_FILES=(".DS_Store")
DOTPATH=$HOME/.dotfiles

# enable echo in color
source $DOTPATH/scripts/colors.sh

function link_anywhere() {
  local base_dir=$1
  local link_dir=$2

  function link_to_link_dir() {
    local target_filename=$1
    local base_filename=`basename $target_filename`
    linking "$base_dir/$base_filename" "$link_dir/$base_filename"
  }
  list_dir $base_dir link_to_link_dir
}

function message_skip() {
  echo -e "${C_BL}skip${NC} $1"
}
function message_link() {
  echo -e "${C_GR}link${NC} $1 -> $2"
}
function linking() {
  local from_name=$1
  local to_name=$2

  # validation for idempotence
  if [ -h $to_name ]; then
    message_skip "${to_name} is already linked"
  elif [ -d $to_name ]; then
    message_skip "${to_name} is directory"
  else
    # link
    message_link $from_name $to_name
    ln -s $from_name $to_name
  fi
}

function linking_dir() {
  local from_name=$1
  local to_name=$2

  # validation for idempotence
  if [ -h $to_name ]; then
    message_skip "${to_name} is already linked"
  elif [ -d $to_name ]; then
    message_skip "${to_name} is directory"
  else
    message_link $from_name $to_name
    ln -s $from_name $to_name
  fi
}
function list_dir() {
  local target_dir=$1
  local function_receives_filename=$2

  for i in $target_dir/* $target_dir/.??*; do
    if [ ! -d $i ] && [ ! -e $i ]; then
      continue
    elif is_exclude $i; then
      continue
    else
      $function_receives_filename $i
    fi
  done
}

function is_exclude() {
  local filename=$1
  for ex in "${EXCLUDE_PATH[@]}"; do
    if [[ $DOTPATH/$ex == $filename ]]; then
      return 0
    fi
  done
  for name in "${EXCLUDE_FILES[@]}"; do
    if [[ ${i##*/} == $name ]]; then
      return 0
    fi
  done
  return 1
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
link_anywhere $DOTPATH $HOME

message "\$DOTPATH/.config/*"
ensure_dir "$HOME/.config"
link_anywhere $DOTPATH/.config $HOME/.config

# ~/.config/herdr also holds runtime state (sockets, logs),
# so link only the config file, not the directory
message "\$DOTPATH/.config/herdr/config.toml"
ensure_dir "$HOME/.config/herdr"
linking "$DOTPATH/.config/herdr/config.toml" "$HOME/.config/herdr/config.toml"

# ~/.pi is shared with Claude Code (~/.Claude Code -> ~/.pi) and holds runtime
# state (sessions, auth, model store), so link only the hand-maintained files:
# settings.json (theme/provider/model/packages) and keybindings.json
message "\$DOTPATH/.pi/agent/*"
ensure_dir "$HOME/.pi/agent"
linking "$DOTPATH/.pi/agent/settings.json" "$HOME/.pi/agent/settings.json"
linking "$DOTPATH/.pi/agent/keybindings.json" "$HOME/.pi/agent/keybindings.json"

message "\$DOTPATH/.claude/commands/*"
ensure_dir "$HOME/.claude"
linking_dir "$DOTPATH/.claude/commands" "$HOME/.claude/commands"

message "\$DOTPATH/.claude/commands -> ~/.codex/prompts"
ensure_dir "$HOME/.codex"
linking_dir "$DOTPATH/.claude/commands" "$HOME/.codex/prompts"

message "\$DOTPATH/.claude/skills/*"
ensure_dir "$HOME/.claude"
linking_dir "$DOTPATH/.claude/skills" "$HOME/.claude/skills"

message "\$DOTPATH/.claude/skills -> ~/.codex/skills"
ensure_dir "$HOME/.codex"
linking_dir "$DOTPATH/.claude/skills" "$HOME/.codex/skills"

message "\$DOTPATH/home/*"
link_anywhere $DOTPATH/home $HOME

message "\$DOTPATH/home/CLAUDE.md -> ~/.claude-work/CLAUDE.md"
ensure_dir "$HOME/.claude-work"
linking "$DOTPATH/home/CLAUDE.md" "$HOME/.claude-work/CLAUDE.md"
