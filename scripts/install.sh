#!/bin/bash

if [[ -z $DOTPATH ]]; then
  DOTPATH=~/.dotfiles
fi

# https instead of ssh so the first clone works before SSH keys are set up
DOTFILES_GITHUB="https://github.com/sushidesu/dotfiles.git"

# colors.sh is only available after the clone, so this section is uncolored
echo "------ CLONE REPOSITORY"
if [[ -d $DOTPATH ]]; then
  echo "skip $DOTPATH already exists."
else
  echo "clone $DOTFILES_GITHUB -> $DOTPATH"
  git clone --recursive "$DOTFILES_GITHUB" "$DOTPATH" || exit 1
fi

source "$DOTPATH/scripts/colors.sh"

echo
echo -e "${C_LGY}------ LINK FILES${NC}"
"$DOTPATH/scripts/link.sh"

echo
echo -e "done...!"
