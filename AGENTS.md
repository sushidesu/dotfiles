# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository that manages shell configuration, tool scripts, and application configurations for macOS. Files are symlinked from this repository to the home directory using the installation scripts.

## Installation & Setup

### Initial Installation
```bash
# Clone and setup dotfiles
./scripts/install.sh
```

This script:
1. Clones the repository to `~/.dotfiles`
2. Runs `./scripts/link.sh` to create symlinks

### Manual Symlinking
```bash
# Create symlinks for dotfiles
./scripts/link.sh
```

Creates symlinks from `.dotfiles/*` to `~/*` and `.dotfiles/.config/*` to `~/.config/*`, excluding `.git`, `.config`, and `scripts` directories.

## Directory Structure

### Core Configuration
- `.zshrc` - Main shell initialization file
- `.zsh/` - Modular zsh configuration
  - `alias.zsh` - Command aliases and shell functions
  - `options.zsh` - Zsh options
  - `plugins.zsh` - Zinit plugin definitions
  - `run_at_startup/` - Language/tool initializers (fnm, pyenv, goenv, etc.)
- `.gitconfig` - Git configuration with custom aliases and delta diff viewer

### Tools (`tools/`)
Collection of custom shell scripts and utilities:
- `ping.sh` - Wi-Fi connection monitor with configurable environment variables (IFACE, TARGET, PING_TIMEOUT_MS, SLOW_THRESHOLD_MS, SLEEP_SEC, SHOW_SSID)
- `cleanup-local-branches.sh` - Deletes local git branches that don't exist on remote (use `--fix` flag to actually delete)
- `get-mid-commit.sh` - Finds midpoint commit(s) between two git hashes
- `rewifi/` - Node.js/TypeScript tool for Wi-Fi automation (uses esbuild, got, tough-cookie)
- `.entrypoints/` - Symlinked executables that can be added to PATH

### Application Configs (`.config/`)
- `nvim/` - Neovim configuration with Lazy.nvim plugin manager
- `ghostty/` - Ghostty terminal emulator config
- `tmux/` - Tmux configuration
- `alacritty/`, `skhd/`, `yabai/` - Other application configs

### Claude Commands (`.claude/commands/`)
Custom slash commands for Claude Code:
- `/commit` - Creates concise conventional commits without Co-Author-By tags

## Git Configuration

Uses delta as the diff pager with the following conventions:
- Default branch: `main`
- Pull strategy: fast-forward only (`ff = only`)
- Case-sensitive filenames (`ignorecase = false`)

### Common Git Aliases
Defined in `.gitconfig` and aliased further in `.zsh/alias.zsh`:
- `git ss` / `ss` - status
- `git lo` - log --oneline last 12 commits (reversed)
- `git ca` / `ca` - commit --amend
- `git can` / `can` - commit --amend --no-edit
- `git fp` / `fp` - fetch --prune
- `git sw` / `sw` - switch
- `git stash-find` - Find unreachable stash commits
- `git stash-pick` - Cherry-pick stashed commits

## Shell Configuration Architecture

The `.zshrc` follows a modular loading pattern:
1. Load startup scripts from `.zsh/run_at_startup/` (language version managers)
2. Load aliases from `.zsh/alias.zsh`
3. Load options from `.zsh/options.zsh`
4. Initialize Zinit plugin manager
5. Load plugins from `.zsh/plugins.zsh`

### Key Tools & Plugins
- **zinit** - Plugin manager
- **exa** - Modern `ls` replacement (aliased as default `ls`)
- **zoxide** - Smart cd replacement
- **atuin** - Shell history
- **delta** - Git diff viewer with syntax highlighting
- **ripgrep** (rg) - Always includes dotfiles (`rg -.`)
- **fd** - Always includes hidden files (`fd -H`)

## Development Workflows

### Working with rewifi
```bash
cd tools/rewifi
pnpm build    # Build with esbuild
pnpm start    # Run built version
pnpm dev      # Build and run
```

### Shell Customization
When modifying shell configuration:
- Add new aliases to `.zsh/alias.zsh`
- Add zsh options to `.zsh/options.zsh`
- Add plugins to `.zsh/plugins.zsh`
- Add language/tool initializers to `.zsh/run_at_startup/`

### Creating New Tools
Place scripts in `tools/` directory. For scripts that should be executable from anywhere:
1. Create executable script in `tools/`
2. Create symlink in `tools/.entrypoints/`
3. Add `tools/.entrypoints` to PATH

## Commit Conventions

This repository uses conventional commits with a preference for conciseness:
- Types: `feat`, `fix`, `docs`, `style`, `refactor`, `chore`, `test`, `build`, `ci`
- Format: `type(scope): description` or just `type: description`
- Keep descriptions under 50 characters
- Use present tense
- No trailing period
- Omit scope unless it adds clarity
- Small changes can be just the type (e.g., "fix: typo")
- Do NOT add "Co-Authored-By" or "Generated with Claude" tags
