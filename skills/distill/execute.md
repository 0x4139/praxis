# Execute

Work the backlog off the **ticket frontier** — every open ticket whose blockers are all closed. Default is **solo mode**: take the next frontier ticket yourself, complete it, close it, recompute. Offer parallel agents only when the frontier holds several independent tickets and the user wants the wall-clock win; tickets are vertical slices with declared blocking edges, so frontier tickets are independent by construction — but never split one ticket across agents by layer.

All state lives on GitHub — no local tracking files. Progress is `subIssuesSummary` on the epic; ordering is the native blocked-by graph.

## Preconditions

An epic with sub-issue tickets and dependencies (from `slice.md`), or any issue set with blocked-by edges. Ticket state queries: `track.md`.

## Setup: One Worktree per Epic

```bash
git checkout main && git pull origin main
git worktree add ../epic-<name> -b epic/<name>
```

Block on a dirty working tree; never use `--force` on any git operation.

## The Loop

1. **Compute the frontier** (query in `track.md`): open tickets, no open blockers, not already assigned or labeled `in-progress`.
2. **Solo mode (default):** mark the next frontier ticket (`gh issue edit <n> --add-assignee @me --add-label in-progress`), implement it in the epic worktree against its acceptance criteria, post a completion comment, close it with the user's confirmation, recompute the frontier, repeat.
3. **Parallel mode (on request):** confirm the wave with the user — list the frontier tickets and how many agents launch (cap at 3–5) — then mark each ticket as above and launch one subagent per ticket:

```
You are implementing GitHub issue #<n> in the worktree at ../epic-<name>/ (branch epic/<name>).

1. Read the issue: gh issue view <n> --comments — the body's "What to build" and
   acceptance criteria are the contract; the spec it links is the context.
2. Work only within this ticket's scope. A needed change outside it → post an issue
   comment and stop; do not expand scope.
3. Before creating or editing files, git pull --rebase origin epic/<name>.
   Commit frequently: "Issue #<n>: <specific change>". Push after each commit.
4. Merge conflicts are never resolved unilaterally — report in a comment and pause.
5. When acceptance criteria pass, post a completion comment summarizing what was
   built and how it was verified. Do not close the issue.
```

4. **On completion of any ticket** (either mode): verify the acceptance criteria yourself or with the user, close the ticket (`gh issue close <n> --comment "..."`), recompute the frontier, and pick up the newly unblocked tickets. Repeat until the epic's `subIssuesSummary.completed == total`.

## Coordination Rules

- One ticket, one agent, whole slice — schema to UI to tests
- Frontier tickets that unexpectedly collide on the same files: run them sequentially and record the missing edge as a native blocked-by dependency (the slice missed it)
- Agents report conflicts and blockers as issue comments — the issue thread is the audit trail
- The epic branch integrates continuously; nothing merges to main mid-epic

## Epic Completion

All sub-issues closed → offer to merge: `git checkout main && git pull && git merge epic/<name>`, push, close the epic issue, remove the worktree (`git worktree remove ../epic-<name>`), delete the branch. Milestone closes when its issues are done (`../project-management/issues-advanced.md`).

## Exit

Between waves and at completion, report status in `track.md`'s standup format.
