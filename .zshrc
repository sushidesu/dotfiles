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

# compinit runs once, right after zinit puts its completions dir (plugin
# completions such as zsh-completions) on fpath and before the tool inits
# below, which register completions only if compdef already exists
autoload -Uz compinit
compinit

# init tools
for i in $HOME/.zsh/run_at_startup/*; do
  source $i
done;

# role-specific inits (roles/<role>/zsh); scripts/bootstrap.sh records the role
if [[ -r $HOME/.config/dotfiles/role ]]; then
  for i in $DOTPATH/roles/$(<$HOME/.config/dotfiles/role)/zsh/*(N); do
    source $i
  done
else
  print -u2 "dotfiles: no role recorded; run $DOTPATH/scripts/bootstrap.sh <role>"
fi

# alias
source "$HOME/.zsh/aliases.zsh"

# user options
source "$HOME/.zsh/options.zsh"

# plugins
source "$HOME/.zsh/plugins.zsh"

# functions
source "$HOME/.zsh/functions.zsh"

# run_at_startup prepends tool dirs; keep ~/.local/bin (herdr, moshi, mise) ahead of them.
# Assigned through the path array so `typeset -U path` (.zshenv) drops the old entry.
path=("$HOME/.local/bin" $path)

# Report links that tools replaced with regular files; silent when all is well
"$DOTPATH/scripts/link.sh" --check
