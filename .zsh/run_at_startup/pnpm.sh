# PNPM_HOME/bin holds the binaries of globally installed packages
# (pnpm add -g). It is appended, not prepended: `pnpm setup` also drops a
# pnpm shim there, and pnpm itself must resolve to the mise-managed version.
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PATH:$PNPM_HOME/bin"
