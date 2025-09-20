---
description: "Create .claude directory and setup settings.local.json with basic tool permissions"
allowed-tools: ["Write", "Read", "Edit"]
---

# Setup Local Claude Settings

Create a `.claude` directory and set up `settings.local.json` file with basic tool permissions for efficient development workflow.

This command will:
1. Create the `.claude` directory if it doesn't exist
2. Create or update `settings.local.json` with common tool permissions if it doesn't exist
3. Enable Write, Read, Edit

The settings file will include permissions for:
- **Write**: Create and overwrite files
- **Read**: Read any file in the project
- **Edit**: Modify existing files

Example `settings.local.json` format:
```json
{
  "permissions": {
    "allow": [
      "Read(**)",
      "Edit(**)",
      "Write(**)"
    ]
  }
}
```

Perfect for initializing Claude Code configuration in new projects or when you need to quickly set up a permissive development environment.
