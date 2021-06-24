#!/bin/bash

if [[ -z $DOTPATH ]]; then
  DOTPATH=~/.dotfiles
fi

DOTFILES_GITHUB="https://github.com/sushidesu/dotfiles.git"

if [[ -d $DOTPATH ]]; then
  echo "$DOTPATH is already exsists."
  exit 1
else
  echo "Initialize...!"
fi

git clone --recursive $DOTFILES_GITHUB $DOTPATH

