---
name: tasklist-review
description: Review `tasks.md` (or equivalent implementation task lists) for autonomous agent execution readiness and missing viewpoints. Use when the user asks to review, improve, or lint a task list/TODO so an agent can continue without blocking confirmations.
---

# Tasklist Review

Review `tasks.md` and report whether each task is executable by an autonomous agent without stopping.

## Workflow

1. Read `tasks.md` and any directly related design/requirement section referenced by the tasks.
2. Assign stable labels to tasks (`T1`, `T2`, ...) if task IDs are missing.
3. Evaluate every task using the checklist below.
4. Mark findings with severity:
   - `blocker`: likely to stop implementation flow
   - `major`: high risk of rework or wrong implementation
   - `minor`: quality issue but unlikely to block
5. Propose concrete rewrites for each `blocker`/`major` item.

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
- Task granularity is appropriate (`1 task ~= 1 commit`).

## Output Format

Output in this order:

1. `Readiness summary` with overall verdict (`ready` / `needs-fixes`) and blocker count.
2. `Findings` grouped by severity with task label, failed checklist item, and evidence.
3. `Rewrite proposals` that can be copied into `tasks.md` directly.
4. `Coverage gaps` for missing cross-cutting tasks (precheck, error handling, consistency sync).

## Guardrails

- Prefer assumptions plus explicit notes over stopping for clarification.
- If information is missing, state the exact missing field and provide a default rewrite.
- Keep rewrite proposals minimal but executable.
- Treat "test task only at the end" as a `blocker` and propose embedding test steps into each implementation task.
