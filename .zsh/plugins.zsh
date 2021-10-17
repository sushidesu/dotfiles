# snippet
zplugin ice wait"0" lucid
zplugin snippet 'OMZ::lib/completion.zsh'
zplugin ice wait"0" lucid
zplugin snippet 'OMZ::lib/compfix.zsh'

# plugin
zplugin cdreplay -q

# complete command
zplugin ice wait"0" lucid
zplugin light 'zsh-users/zsh-completions'

# highlight commands
zplugin ice wait"0" lucid
zplugin light 'zdharma/fast-syntax-highlighting'

# suggest
zplugin ice !wait"0" lucid
zplugin light 'zsh-users/zsh-autosuggestions'

# theme
zinit ice !wait"0" lucid compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure

