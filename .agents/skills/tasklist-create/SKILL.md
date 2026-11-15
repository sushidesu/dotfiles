---
name: tasklist-create
description: Create or restructure `tasks.md` (or equivalent task list) into an executable plan for autonomous implementation. Use when the user asks to create a task list, break work into steps, or convert requirements/design docs into actionable tasks with dependencies, tests, and done criteria.
---

# Tasklist Create

Create a concrete, executable task list that another agent can run without asking follow-up questions.

## Workflow

1. Read the source context first.
   - Requirements, design docs, and existing `tasks.md` if present.
2. Define scope and assumptions.
   - Convert ambiguous points into explicit assumptions in Notes.
3. Build task skeleton.
   - Include sections: `In Progress`, `Todo`, `Blocked`, `Done`, `Notes`.
   - If IDs are missing, assign stable IDs (`T1`, `T2`, ...).
4. Split work into task units.
   - Target granularity: `1 task ~= 1 commit`.
   - Keep tasks vertically sliced when possible (contract -> implementation -> test/doc update).
5. Add mandatory fields to every implementation task.
   - `dependency`
   - `error-handling` (when relevant)
   - `test`
   - `done`
6. Add cross-cutting tasks.
   - Precheck task near the beginning (format/test/typecheck current baseline).
   - Final release-gate task near the end (full quality gate rerun).
7. Validate for autonomous execution.
   - No unresolved implementation decisions.
   - Clear file paths/interfaces/contracts.
   - Dependencies are acyclic and explicit.
   - Test plan is embedded in each task (not only at the end).
8. Write/update `tasks.md` directly.

## Task Writing Rules

- Use action-oriented task titles: `component: specific change`.
- State contract boundaries explicitly for API/type tasks.
- Prefer concrete file paths and endpoint/type names.
- Include fallback behavior when external inputs may be missing.
- Keep `Blocked` tasks actionable:
  - `reason`
  - `next`

## Recommended Task Template

```md
- [ ] (Tn) <scope>: <what to build>
  - dependency: <none | Tm>
  - error-handling: <policy>   # optional for purely static tasks
  - test: <tests to add/update + commands>
  - done: 実装完了、関連テスト成功、関連docs更新、tasksステータス更新、commit完了
```

## Guardrails

- Do not leave major choices as "to be decided later"; choose a default and record it.
- Do not create "test-only final task" as the only testing strategy.
- Do not mix unrelated scopes in one task.
- Keep edits minimal but executable when refining an existing `tasks.md`.
