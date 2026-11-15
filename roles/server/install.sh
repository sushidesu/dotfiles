#!/bin/bash
# Server-role tools that neither brew nor mise provides. Both install into
# ~/.local/bin and update themselves (`herdr update`, `moshi-hook update`),
# so they are installed once and never reinstalled here.
set -euo pipefail

# herdr: the terminal multiplexer the agents run in
[ -x "$HOME/.local/bin/herdr" ] || curl -fsSL https://herdr.dev/install.sh | sh

# moshi-hook: bridges agent events to the Moshi app on the phone
[ -x "$HOME/.local/bin/moshi-hook" ] || curl -fsSL https://getmoshi.app/install.sh | sh

# pi notifies the phone when a run ends; idempotent, rewrites the hook extension
"$HOME/.local/bin/moshi-hook" install --target pi
