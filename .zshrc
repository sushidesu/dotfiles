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

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone --filter=blob:none https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

ZPLUGIN_PATH="$HOME/.zplugin/bin/zplugin.zsh"
ZINIT_PATH="$HOME/.zinit/bin/zinit.zsh"
ZINIT_NEW_PATH="$HOME/.local/share/zinit/zinit.git/zinit.zsh"
if [[ -e $ZPLUGIN_PATH ]]; then
  source $ZPLUGIN_PATH
  autoload -Uz _zplugin
  (( ${+_comps} )) && _comps[zplugin]=_zplugin
elif [[ -e $ZINIT_PATH ]]; then
  source $ZINIT_PATH
  autoload -Uz _zinit
  (( ${+_comps} )) && _comps[zinit]=_zinit
elif [[ -e $ZINIT_NEW_PATH ]]; then
  source $ZINIT_NEW_PATH
  autoload -Uz _zinit
  (( ${+_comps} )) && _comps[zinit]=_zinit
else
  echo "please install zinit!!"
fi

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# plugins
source "$HOME/.zsh/plugins.zsh"

export PATH="$HOME/.poetry/bin:$PATH"


. "$HOME/.local/bin/env"
