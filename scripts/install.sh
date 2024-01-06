#!/bin/bash

if [[ -z $DOTPATH ]]; then
  DOTPATH=~/.dotfiles
fi

# enable color
source $DOTPATH/scripts/colors.sh

DOTFILES_GITHUB="git@github.com:sushidesu/dotfiles.git"

function message() {
  echo -e "${C_LGY}------ ${1}${NC}"
}

message "CLONE REPOSITORY"
if [[ -d $DOTPATH ]]; then
  echo -e "${C_BL}skip${NC} $DOTPATH is already exsists."
else
  echo -e "${C_GR}clone${NC} $DOTFILES_GITHUB -> $DOTPATH"
  git clone --recursive $DOTFILES_GITHUB $DOTPATH
fi

echo
message "LINK FILES"
$DOTPATH/scripts/link.sh

echo
echo -e "done...!"

