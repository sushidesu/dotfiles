#!/bin/bash
# bootstrap.sh — set this machine up for a role: record the role, install its
# tools, and link the dotfiles. Safe to rerun; every step skips what is done.
#
# Usage: bootstrap.sh <role>
#
# A role is a directory under roles/ (common is shared by all):
#   Brewfile    formulae, installed with brew bundle
#   install.sh  tools that neither brew nor mise provides
#   zsh/        shell inits, sourced by .zshrc for this role only
# CLI tools that mise can install belong in .config/mise/config.toml instead.

set -euo pipefail

DOTPATH=$HOME/.dotfiles
ROLE_FILE=$HOME/.config/dotfiles/role

roles() {
  local dir
  for dir in "$DOTPATH"/roles/*/; do
    dir=${dir%/}
    [[ "${dir##*/}" != common ]] && printf '%s ' "${dir##*/}"
  done
}

role=${1:-}
if [[ -z "$role" || "$role" == common || ! -d "$DOTPATH/roles/$role" ]]; then
  echo "usage: bootstrap.sh <role>   roles: $(roles)" >&2
  exit 2
fi

if ! command -v brew >/dev/null; then
  echo "bootstrap.sh: install Homebrew first: https://brew.sh" >&2
  exit 1
fi

mkdir -p "$(dirname "$ROLE_FILE")"
echo "$role" >"$ROLE_FILE"

for brewfile in "$DOTPATH/roles/common/Brewfile" "$DOTPATH/roles/$role/Brewfile"; do
  if [ -f "$brewfile" ]; then
    brew bundle --no-upgrade --file "$brewfile"
  fi
done

# mise's own installer puts it in ~/.local/bin, which .zshenv puts on PATH
if ! command -v mise >/dev/null && [ ! -x "$HOME/.local/bin/mise" ]; then
  curl -fsSL https://mise.run | sh
fi

"$DOTPATH/scripts/link.sh"

# the mise config arrives with the links above
PATH="$HOME/.local/bin:$PATH" mise install

if [ -f "$DOTPATH/roles/$role/install.sh" ]; then
  bash "$DOTPATH/roles/$role/install.sh"
fi

echo "bootstrap.sh: $role is set up; open a new shell to load it"
