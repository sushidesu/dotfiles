# dotfiles

Personal dotfiles for macOS.

## Setup

Clone to `~/.dotfiles` (the location is fixed; `.zshenv` and scripts depend on it), then link:

```sh
git clone https://github.com/sushidesu/dotfiles.git ~/.dotfiles
~/.dotfiles/scripts/link.sh
```

`link.sh` is idempotent: run it again whenever files are added. It never overwrites an existing file or a link pointing elsewhere; it prints a warning instead.

To push over SSH once keys are set up:

```sh
git -C ~/.dotfiles remote set-url origin git@github.com:sushidesu/dotfiles.git
```
