# AGENTS.md

Personal dotfiles for macOS. Files are symlinked from this repo to `~/`.

## Where to add things

- New aliases → `.zsh/aliases.zsh`
- Zsh options → `.zsh/options.zsh`
- Plugins → `.zsh/plugins.zsh`
- Tool initializers (fnm, pyenv, etc.) → `.zsh/run_at_startup/<tool>.sh`
- External commands → `bin/<command>` (no extension, already on PATH)

## Claude Code

Normally run as `wclaude` (= `CLAUDE_CONFIG_DIR=~/.claude-work claude`), a separate work profile.