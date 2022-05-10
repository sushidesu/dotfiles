# user
unsetopt PROMPT_SP
autoload -Uz compinit
compinit
setopt share_history
setopt append_history
HISTFILE=$HOME/.zsh-history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt auto_cd
function chpwd() { ls } # auto ls

# my scripts
export PATH="$HOME/tools:$PATH"

