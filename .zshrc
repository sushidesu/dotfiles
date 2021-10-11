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

# plugins
source "$HOME/.zsh/plugins.zsh"

