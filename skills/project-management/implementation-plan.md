# Implementation Plan

A plan file is a contract for execution: any competent agent or human should be able to run it without asking questions. Every task names its files and functions, every phase has measurable completion criteria, and every requirement is traceable through a stable identifier. Ambiguity in the plan becomes improvisation during execution.

## When to Activate

- A feature, refactor, package upgrade, data migration, or infrastructure change needs a plan before code is touched
- Work will be executed by another agent, a later session, or a teammate
- The user asks for an implementation plan, plan file, or task breakdown with tracking

**Not this skill:** multi-session, multi-agent projects needing per-step context briefs and adversarial review — use the `blueprint` skill. A plan derived from a spec should cite it (see `specification.md`); a plan becomes tracked work via `issues.md`.

## Output

- Location: `plan/` directory at the repo root (create it if missing)
- Name: `[purpose]-[component]-[version].md` where purpose is one of `upgrade|refactor|feature|data|infrastructure|process|architecture|design` — e.g. `feature-auth-module-1.md`
- Format: the template in `plan-template.md`, exactly — all front matter fields, section headers verbatim, no placeholder text left in the final file

## Workflow

1. **Gather ground truth.** Read the code the plan touches. Task descriptions must carry specific file paths, function names, and exact values — "update the config" is not a task; "set `maxRetries: 3` in `internal/client/config.go`" is.
2. **State requirements and constraints first** (`REQ-`, `SEC-`, `CON-`, `GUD-`, `PAT-`). Every task should trace back to one. When the plan derives from a spec, cite the spec's IDs verbatim instead of declaring new ones; declare new IDs only for plan-local constraints.
3. **Cut the work into phases.** Each phase has a `GOAL-` and independently verifiable completion criteria. Tasks within a phase are parallelizable unless a dependency is declared. No task may require human interpretation or an unstated decision.
4. **Fill the remaining sections**: alternatives considered, dependencies, affected files, tests, risks and assumptions.
5. **Set status** in front matter and as the badge: `Planned` when authoring; executors update to `In progress` / `Completed`, marking each task's `Completed`/`Date` columns as they go.
6. **Validate identifiers** before finalizing (below).

## Identifier Discipline

Every identifier (`REQ-`, `SEC-`, `CON-`, `GUD-`, `PAT-`, `GOAL-`, `TASK-`, `ALT-`, `DEP-`, `FILE-`, `TEST-`, `RISK-`, `ASSUMPTION-`, each with a 3-digit number) is **declared exactly once** — the leading cell of a table row or the bolded prefix of a bullet. It may then be **referenced** freely (a task citing a requirement, one task citing another). References are not collisions.

Run before finalizing; both checks must return zero rows:

```bash
PLAN_FILE="plan/<purpose>-<component>-<version>.md"

# Duplicate TASK/GOAL declarations in table rows
grep -oE '\| (TASK|GOAL)-[0-9]+ \|' "$PLAN_FILE" \
  | sed -E 's/.*((TASK|GOAL)-[0-9]+).*/\1/' | sort | uniq -d

# Duplicate declarations in bullet lines
grep -oE '^- \*\*(REQ|SEC|CON|GUD|RISK|ASSUMPTION|TASK|GOAL|FILE|TEST|PAT|ALT|DEP)-[0-9]+\*\*:' "$PLAN_FILE" \
  | sed -E 's/^- \*\*([A-Z]+-[0-9]+)\*\*:.*/\1/' | sort | uniq -d
```

Any output means a duplicate declaration: renumber and re-run until clean.

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Tasks like "improve error handling" | Name the file, the function, and the exact change |
| Phase depends on a later phase | Reorder; phases execute top to bottom |
| Placeholder text left in final plan | Fill or delete every bracketed section |
| Same TASK number declared twice | Run the uniqueness checks; renumber |
| Plan relies on chat context | The file must be self-contained — an executor sees only the plan and the repo |
| Status never updated | Executors mark tasks complete with dates and flip status when done |
