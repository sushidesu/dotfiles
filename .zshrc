# Created by newuser for 5.4.2

# aliasを読み込む
source "$HOME/.zsh/alias.zsh"

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

### Added by Zplugin's installer
source "$HOME/.zplugin/bin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin installer's chunk

# anyenv
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# goenv
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"
export PATH="$GOROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"

# snippet
zplugin snippet 'OMZ::lib/completion.zsh'
zplugin snippet 'OMZ::lib/compfix.zsh'

# plugin
zplugin cdreplay -q

# zplugin ice wait '1' lucid
zplugin light 'zsh-users/zsh-completions' # 補完
# コマンドをハイライトするプラグインを遅延ロードします。
# zplugin ice wait '1' atload'_zsh_highlight' lucid
zplugin light 'zdharma/fast-syntax-highlighting'
# コマンドをサジェストするプラグインを遅延ロードします。
# zplugin ice wait '1' atload'_zsh_autosuggest_start' lucid
zplugin light 'zsh-users/zsh-autosuggestions'

# theme
zplugin ice wait'!0' lucid
zplugin light 'denysdovhan/spaceship-zsh-theme'

# my scripts
export PATH="$HOME/.sushidesu/tools:$PATH"

