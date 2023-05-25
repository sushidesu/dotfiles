#!/bin/bash

EXCLUDE_PATH=(".git" ".config" "scripts")
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

message "\$DOTPATH/*"
link_anywhere $DOTPATH $HOME

message "\$DOTPATH/config/*"
link_anywhere $DOTPATH/.config $HOME/.config

