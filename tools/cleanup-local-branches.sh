#!/bin/bash

# enable echo in color
source $DOTPATH/scripts/colors.sh

function cleanup_local_branches() {
  if [[ "$1" == "--fix" ]]; then
    DRYRUN="false"
  else
    DRYRUN="true"
  fi

  REMOTE_BRANCHES=$(git branch -r | remove_spaces)
  LOCAL_BRANCHES=$(git branch | remove_spaces)

  # remoteに無いブランチに対して、`git branch -d {name}` を実行する
  echo "$LOCAL_BRANCHES" | while IFS= read -r line; do
    match=$(echo "$REMOTE_BRANCHES" | grep $line)
    if [[ -z "$match" ]]; then
      message_delete "$line"
      if [[ "$DRYRUN" == "false" ]]; then
        git branch -d $line
        echo
      fi
    else
      message_skip "$line"
    fi
  done
}

# * main
#   some-branch
# ↑この空白とアスタリスクを消す
function remove_spaces() {
  getarg.sh | sed "s/\* //" | sed "s/^  //"
}

function message_skip() {
  echo -e "skip   $1"
}

function message_delete() {
  echo -e "${C_RD}delete${NC} $1"
}

cleanup_local_branches "$1"
