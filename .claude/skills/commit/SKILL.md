---
name: commit
description: Create a concise conventional commit for the current repo. Use when the user says to commit (e.g., "commitして", "commit", "make a commit") and expects a git commit message and `git commit -m` execution.
---

# Commit

Quick checks:
!`git status`
!`git diff --cached`

Create a concise conventional commit based on staged changes. Follow repo conventions: no Co-Author-By, no "Generated with" tags, present tense, no trailing period, keep description under 50 chars, omit scope unless it adds clarity. Use minimal messages for tiny changes.

## Workflow

1. Review staged changes (run the quick checks above).
2. If nothing is staged, auto-stage based on context:
   - Prefer files mentioned by the user in the current request.
   - Include files modified in this session that are directly related to the task.
   - If multiple unrelated areas are modified and the user didn’t scope it, ask before staging.
   - Avoid staging unrelated changes. Do not stage generated files unless they are the expected output.
3. Decide the commit type from changes:
   - `feat`, `fix`, `docs`, `style`, `refactor`, `chore`, `test`, `build`, `ci`.
4. Compose the message:
   - Small changes: `type: short` (e.g., `fix: typo`).
   - Normal changes: `type(scope): description` when scope helps clarity.
5. Commit with `git commit -m "..."`.

## Codex-specific execution rules

- In Codex, treat `git add` and `git commit` as operations that usually require escalation approval.
- Do not chain commit-related commands in one shell invocation.
- Run commit-related operations as separate commands in order:
  1. `git add ...`
  2. `git diff --cached`
  3. `git commit -m "..."`

## Guardrails

- Be concise; avoid bodies unless needed for complex changes.
- Prefer `type: description` over verbose phrasing.
- Do not amend or add co-author lines unless explicitly requested.
