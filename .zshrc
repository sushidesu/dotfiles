# Created by newuser for 5.4.2

# init tools
for i in $HOME/.zsh/run_at_startup/*; do
  source $i
done;

# alias
source "$HOME/.zsh/aliases.zsh"

# user options
source "$HOME/.zsh/options.zsh"

# Zinit

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone --filter=blob:none https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

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

# functions
source "$HOME/.zsh/functions.zsh"

export PATH="$HOME/.local/bin:$PATH"
