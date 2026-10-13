# snippet
zinit ice wait"0" lucid
zinit snippet 'OMZ::lib/completion.zsh'
zinit ice wait"0" lucid
zinit snippet 'OMZ::lib/compfix.zsh'

# complete command
zinit ice wait"0" lucid
zinit light 'zsh-users/zsh-completions'

# highlight commands
zinit ice wait"0" lucid
zinit light 'zdharma-continuum/fast-syntax-highlighting'

# suggest
zinit ice !wait"0" lucid
zinit light 'zsh-users/zsh-autosuggestions'

# theme
zinit ice !wait"0" lucid compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure
