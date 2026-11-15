# AGENTS.md

Personal dotfiles for macOS. Files are symlinked from this repo to `~/` by `scripts/link.sh`; machines are set up per role by `scripts/bootstrap.sh` (see README.md).

## Where to add things

- New aliases → `.zsh/aliases.zsh`
- Zsh options → `.zsh/options.zsh`
- Plugins → `.zsh/plugins.zsh`
- Tool initializers every machine needs (zoxide, atuin, etc.) → `.zsh/run_at_startup/<tool>.sh`
- Tool initializers for one role → `roles/<role>/zsh/<tool>.sh`
- CLI tools → `.config/mise/config.toml`; what mise cannot install → `roles/<role>/Brewfile` or `roles/<role>/install.sh`
- Agent skills → `.agents/skills/<name>/SKILL.md`
- External commands → `bin/<command>` (no extension, already on PATH)
- New link targets outside the directory sweeps → `plan_links` in `scripts/link.sh`
