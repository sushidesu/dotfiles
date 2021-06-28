#!/bin/bash

EXCLUDE_PATH=(".git")
DOTPATH=$HOME/.dotfiles

function is_exclude() {
  for ex in "${EXCLUDE_PATH[@]}"; do
    if [[ $DOTPATH/$ex == $1 ]]; then
      return 0
    fi
  done
  return 1
}

for i in $DOTPATH/.??*; do
  if is_exclude $i; then
    continue
  else
    FILENAME=`basename $i`
    echo "$i -> ~/$FILENAME"
    ln -sf $i $HOME/$FILENAME
  fi
done

