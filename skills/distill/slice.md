# Slice

Break a spec (or a sufficiently settled conversation) into **tracer-bullet tickets**: vertical slices with explicit blocking edges, published in dependency order, optionally grouped into milestones.

## Process

### 1. Gather context

Work from the spec or conversation. If given a reference (spec path, issue number), fetch and read it fully. Explore the codebase if not already done; look for **prefactoring** opportunities — "make the change easy, then make the easy change" — and front-load them as their own tickets.

### 2. Draft vertical slices

- Each slice cuts a narrow but **complete** path through every layer (schema, API, UI, tests) — vertical, never a horizontal slice of one layer
- A completed slice is demoable or verifiable on its own
- Each slice fits a single fresh agent context window
- Prefactoring tickets come first

Give each ticket its **blocking edges**: the tickets that must complete before it can start. A ticket with no blockers can start immediately.

**Wide refactors are the exception.** One mechanical change (rename a column, retype a shared symbol) whose blast radius breaks call sites everywhere can't land as a green vertical slice. Sequence it **expand–contract**: *expand* (add the new form beside the old — nothing breaks), *migrate* in batches sized by blast radius (per package/directory, each batch a ticket blocked by the expand), *contract* (delete the old form, blocked by every migrate batch). If even batches can't stay green alone, share an integration branch and promise green only at a final integrate-and-verify ticket.

### 3. Quiz the user

Present the breakdown as a numbered list — per ticket: **Title**, **Blocked by**, **What it delivers** (end-to-end behavior, not layers). Ask:

- Granularity right? (too coarse / too fine)
- Blocking edges correct — does each ticket depend only on what genuinely gates it?
- Merge or split any?

If natural phases emerge (foundation / feature / polish), propose one **milestone** per phase. Iterate until approved. If quizzing exposes an unsettled decision, run a **targeted round** (`elicit.md` § Targeted Round), update the spec if one exists, and continue.

### 4. Publish

Use the `project-management` skill's machinery (`../project-management/issues.md`, `../project-management/issues-advanced.md`) — not improvised gh calls:

1. Parent epic (Epic template in `../project-management/issue-templates.md`) referencing the spec
2. One issue per ticket (template below), in dependency order so blockers exist before their dependents, each linked as a **sub-issue** of the epic (capture `number` and `id`)
3. Blocking edges as **native blocked-by dependencies**, not prose
4. Milestones created and assigned if phases were approved
5. Report all issue URLs; do not close or modify any pre-existing parent issue

### Ticket template

Ticket bodies use this template — it overrides the Task template that `issues.md`'s breakdown flow would otherwise pick:

```md
## What to build

[The end-to-end behavior this ticket makes work, from the user's perspective.]

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2

## Blocked by

[Native dependency set; restate here as #N references, or "None (can start immediately)".]

## Spec

[Path or link to the spec this slices. Slicing from conversation with no spec: reference the epic instead, or write a minimal spec first via `specify.md`.]
```

No file paths or code snippets in tickets — they go stale. Same single exception as the spec: a trimmed snippet that *is* the decision.

## Exit

Hand off: the backlog now exists in dependency order. Offer **triage** (`triage.md`) to label states, or **execute** (`execute.md`) — the frontier (tickets with no unfinished blockers) is ready to start.
