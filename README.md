# dotfiles

Personal dotfiles for macOS, shared by machines with different roles:

- `laptop` — the MacBook
- `server` — the Mac mini: reached from the phone over Tailscale + mosh (Moshi), running agents inside herdr

## Setup

Install [Homebrew](https://brew.sh), clone to `~/.dotfiles` (the location is fixed; `.zshenv` and scripts depend on it), then bootstrap with the machine's role:

```sh
git clone https://github.com/sushidesu/dotfiles.git ~/.dotfiles
~/.dotfiles/scripts/bootstrap.sh <laptop|server>
```

`bootstrap.sh` records the role in `~/.config/dotfiles/role`, installs what `roles/common` and `roles/<role>` declare (`Brewfile`, `install.sh`), installs mise and its tools, and links the dotfiles. It is safe to rerun.

Steps that need an account or a GUI stay manual:

- server: install the Tailscale app and sign in; pair with the Moshi app (`moshi-hook host setup`)

To push over SSH once keys are set up:

```sh
git -C ~/.dotfiles remote set-url origin git@github.com:sushidesu/dotfiles.git
```

## Layout

- Tools: CLI tools in `.config/mise/config.toml`; the rest per role in `roles/<role>/` (`Brewfile`, `install.sh`, shell inits in `zsh/`)
- Links: `scripts/link.sh` links files into `$HOME`. It never overwrites anything; `link.sh --check` runs at every shell start and reports links that tools replaced with regular files
- Agents: shared instructions in `home/AGENTS.md` (`~/AGENTS.md`, `~/CLAUDE.md`), work-profile additions in `.claude-work/CLAUDE.md`, skills in `.agents/skills` (`~/.agents/skills` for pi and codex, `~/.claude/skills` for Claude Code)
