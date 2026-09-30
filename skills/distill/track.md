# Track

Answer "where are we?" from GitHub alone — the native sub-issue and dependency graph is the single source of truth. No local status files, no progress frontmatter; if GitHub doesn't say it, it isn't true.

Substitute `ORG`/`REPO`/`EPIC` from the current repo (`gh repo view --json owner,name`).

## The One Query

Epic state — every ticket, its blockers, and overall progress:

```bash
gh api graphql -f query='{ repository(owner: "ORG", name: "REPO") { issue(number: EPIC) {
  subIssuesSummary { total completed percentCompleted }
  subIssues(first: 100) { nodes {
    number title state
    assignees(first: 5) { nodes { login } }
    labels(first: 10) { nodes { name } }
    blockedBy(first: 20) { nodes { number state } }
  } }
} } }'
```

Derive the buckets:

| Bucket | Rule |
|--------|------|
| **Done** | `state == CLOSED` |
| **In progress** | open, and assigned or labeled `in-progress` |
| **Blocked** | open, with at least one blocker still `OPEN` — report *which* blockers |
| **Next (the frontier)** | open, unassigned, every blocker `CLOSED` or none |

## Standup Format

```
## <epic title> — <completed>/<total> (<pct>%)

Done since last standup: #12 <title>, #14 <title>
In progress:             #15 <title> (@who)
Blocked:                 #17 <title> — waiting on #15
Next up:                 #16 <title>, #18 <title>
```

Answer narrower questions from the same data: "what's next" → the frontier, ordered by how many open tickets each one unblocks (highest leverage first); "what's blocked" → the blocked bucket with blocker numbers; "status" → the header line plus counts.

## Across Epics

List epics and their progress:

```bash
gh issue list --label epic --state all --json number,title,state
# then subIssuesSummary per epic via the query above
```

Milestone view (deliverable-level): `gh api "repos/ORG/REPO/milestones?state=open" --jq '.[] | {title, open_issues, closed_issues}'`

## Hygiene Checks

Run when numbers look off:

- Open ticket whose blockers are all closed but sits unassigned for days → surface it ("frontier is starving")
- Closed ticket with open tickets still blocked on it → the dependency should have been removed on close; fix it
- Ticket `in-progress` with no assignee, or assigned with no activity → flag for the user, don't chase on your own
