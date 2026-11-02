# .dotfiles PATH
export DOTPATH="$HOME/.dotfiles"

. "$HOME/.cargo/env"

# mise shims: non-interactive processes (agents, editors, scripts) see the same
# tools as the interactive shell, where `mise activate` in .zshrc takes over.
eval "$(/opt/homebrew/bin/mise activate zsh --shims)"

