---
name: gh-pr-create
description: Create GitHub PRs via gh using the repository PULL_REQUEST_TEMPLATE.md. Trigger when the user says to create a PR, asks to push and open a PR, mentions PR templates, or wants background/QA sections filled.
---

# GH PR Create

Use this skill when asked to create a PR using `gh pr create` and the repo’s PR template.

## Workflow

1. **Check status**
   - Run `git status -sb` to ensure branch and changes are known.
   - If nothing to push, ask user whether to proceed.

2. **Confirm template**
   - Read `.github/PULL_REQUEST_TEMPLATE.md` to align sections.
   - If template missing, proceed with a minimal body.

3. **Prepare PR body**
   - If the repo is `balus-co-ltd/spwn` (or has the same template), follow the template: keep `pr_agent:summary`, remove `resolve #` when instructed, and place the userの背景 in **背景・課題・Issue**.
   - Otherwise, write the background as concise sentences (not bullet-heavy) and keep the body minimal.
   - For **実装詳細・変更点概要**, leave the template placeholder unless user explicitly asks to write it.
   - For QA, default to:
     - E2E: `未実施`
     - Manual: `1. 未実施`
   - Keep sections and wording consistent with the template when one exists.

4. **Decide optional steps**
   - Push branch only if not already pushed.
   - Create PR only if not already exists.

5. **Create PR**
   - Use `gh pr create --base <base> --head <branch> --title <title> --body <body>`.
   - Base defaults to the user’s target branch (e.g., `develop`). Ask if unclear.

## Guardrails

- **PR title**: Use a conventional-commit-like prefix and a short English summary in lowercase. Examples:
  - `ci: align pipeline cache keys`
  - `chore: tidy workspace scripts`
  - `docs: clarify release steps`
  - `feat: add admin export endpoint`
  - `fix: prevent duplicate checkout`
  Naming rules:
  - Present tense
  - Under 50 characters
  - No trailing period
  - Omit scope unless it adds clarity
- Do not overwrite template sections beyond what the user requested.
- If the user wants background only, keep other sections untouched.
- If the user says “auto-generate details,” keep `pr_agent:summary` and do not edit it.
- Keep the PR body concise; avoid extra sections.

## Prompts to ask when unclear

- “PRのベースブランチは `develop` で良いですか？”
- “`resolve #` を消して良いですか？”
- “背景・課題に入れる箇条書きを教えてください。”
