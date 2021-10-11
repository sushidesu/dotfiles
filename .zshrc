# Created by newuser for 5.4.2

# init tools
for i in $HOME/.zsh/run_at_startup/*; do
  source $i
done;

# alias
source "$HOME/.zsh/alias.zsh"

# user options
source "$HOME/.zsh/options.zsh"

### Added by Zplugin's installer
source "$HOME/.zplugin/bin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin installer's chunk

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

