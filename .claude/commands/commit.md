---
description: Create concise conventional commit
argument-hint: [type] [scope] [description]
allowed-tools: Bash(git:*), Read(**), Edit(**)
---

# Create Commit

Review staged changes and create a **concise** conventional commit. No "Co-Author-By" or "Generated with Claude".

## Commit Types
- `feat`: new feature
- `fix`: bug fix  
- `docs`: documentation
- `style`: formatting (no logic change)
- `refactor`: code restructuring
- `chore`: maintenance tasks
- `test`: tests
- `build`/`ci`: build/CI changes

## Format
```
type(scope): description
```

## Instructions

1. Run `git status` and `git diff --cached` to review changes
2. Determine commit type from changes
3. **Write minimal commit message:**
   - For small changes: type only (e.g., `fix: typo`)
   - For normal changes: brief description (< 50 chars)
   - Only add body for complex changes that need explanation
4. Create commit with `git commit -m`

## Important
- **Be concise** - write only what's necessary
- Small changes don't need detailed descriptions
- Use present tense ("add" not "added")
- No period at end
- Skip scope unless it adds clarity
