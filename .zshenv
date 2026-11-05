# .dotfiles PATH
export DOTPATH="$HOME/.dotfiles"

. "$HOME/.cargo/env"

# mise shims: non-interactive processes (agents, editors, scripts) see the same
# tools as the interactive shell, where `mise activate` in .zshrc takes over.
# mise is installed by brew on the MacBook (/opt/homebrew/bin) and by its own
# installer on the Mac mini (~/.local/bin), so both are on PATH first.
export PATH="$HOME/.local/bin:/opt/homebrew/bin:$PATH"
eval "$(mise activate zsh --shims)"

