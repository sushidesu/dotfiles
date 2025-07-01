# user
unsetopt PROMPT_SP
autoload -Uz compinit
compinit

setopt share_history
setopt append_history
setopt inc_append_history
setopt extended_history
export HISTTIMEFORMAT="[%F %T] "

HISTFILE=$HOME/.zsh-history
HISTSIZE=1000000000
SAVEHIST=1000000000
HISTFILESIZE=1000000000
setopt hist_ignore_all_dups
setopt hist_ignore_space

setopt auto_cd
# function chpwd() { ls } # auto ls

# my scripts
export PATH="$HOME/tools/.entrypoints:$PATH"

