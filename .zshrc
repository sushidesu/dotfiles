# Created by newuser for 5.4.2

# init tools
for i in $HOME/.zsh/run_at_startup/*; do
  source $i
done;

# alias
source "$HOME/.zsh/alias.zsh"

# user options
source "$HOME/.zsh/options.zsh"

# Zinit (Zplugin)
ZPLUGIN_PATH="$HOME/.zplugin/bin/zplugin.zsh"
ZINIT_PATH="$HOME/.zinit/bin/zinit.zsh"
if [[ -e $ZPLUGIN_PATH ]]; then
  source $ZPLUGIN_PATH
  autoload -Uz _zplugin
  (( ${+_comps} )) && _comps[zplugin]=_zplugin
elif [[ -e $ZINIT_PATH ]]; then
  source $ZINIT_PATH
  autoload -Uz _zinit
  (( ${+_comps} )) && _comps[zinit]=_zinit
else
  echo "please install zinit!!"
fi

# plugins
source "$HOME/.zsh/plugins.zsh"


export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export PATH="$HOME/.poetry/bin:$PATH"
