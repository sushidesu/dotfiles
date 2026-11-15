---
name: tasklist-review
description: Review `tasks.md` (or equivalent implementation task lists) for autonomous agent execution readiness, directly fix blocker/major issues, and report findings with rationale without pasting full rewrite text.
---

# Tasklist Review

Review `tasks.md` and make it executable by an autonomous agent without stopping.

## Workflow

1. Read `tasks.md` and any directly related design/requirement section referenced by the tasks.
2. Assign stable labels to tasks (`T1`, `T2`, ...) if task IDs are missing.
3. Evaluate every task using the checklist below.
4. Mark findings with severity:
   - `blocker`: likely to stop implementation flow
   - `major`: high risk of rework or wrong implementation
   - `minor`: quality issue but unlikely to block
5. Directly edit `tasks.md` to fix every `blocker` and `major` item.
6. Keep `minor` items as report-only unless they can be fixed with a tiny, low-risk wording change.

## Checklist

### 1) Autonomous Execution Readiness

For each task, confirm all items:

- Define what to build concretely (interface, types, file path, contract boundary).
- Define how to build concretely (no unresolved implementation decision that would require asking the user).
- Declare dependencies on other tasks explicitly.
- Define clear done criteria.
- Include test policy inside the same task (do not leave testing as a separate final task only).

### 2) Missing Viewpoints

Confirm task list coverage for:

- Preconditions check exists (current tests/type-check pass status before implementation).
- Error-handling policy exists.
- Consistency between design policy and task list exists.
- Documentation update is required only when the task includes technology selection records or external research results; otherwise treat docs update as optional.
- Task granularity is appropriate (`1 task ~= 1 commit`).

## Output Format

Output in this order:

1. `Readiness summary` with overall verdict (`ready` / `needs-fixes`) and counts by severity.
2. `Strengths` listing what is already good in the current task list.
3. `Findings` grouped by severity with task label, failed checklist item, and brief evidence.
4. `Applied fixes` listing what was changed in `tasks.md`, with one-line rationale per fix.
5. `Remaining risks` listing unresolved `minor` items only.
6. `Coverage gaps` for any missing cross-cutting tasks (precheck, error handling, consistency sync).

Do not include full rewritten task text in the response. Summarize changes and rationale only.

## Guardrails

- Prefer assumptions plus explicit notes over stopping for clarification.
- If information is missing, apply a reasonable default directly in `tasks.md` and mention it with rationale in `Applied fixes`.
- Keep edits minimal but executable.
- Treat "test task only at the end" as a `blocker` and embed test steps into each implementation task.
- Do not raise missing docs updates as `blocker`/`major` unless the task explicitly requires recording technology decisions or external investigation outcomes.
- Never paste full-file or full-section rewrites in the response; summarize diffs only.
