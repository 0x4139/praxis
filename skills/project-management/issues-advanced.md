# Advanced Issue Operations

Sub-issues, dependencies, milestones, and label administration via `gh`. `gh label` and `gh issue` act on the current repository (add `--repo {owner}/{repo}` for another); `gh api` fills `{owner}/{repo}` from the current repo; when targeting another repo, prefer writing `owner/repo` literally into the path (or set `GH_REPO=owner/repo`).

## Numbers vs IDs

Issue **number** is what the UI shows (`#42`); issue **ID** is the global numeric `.id` field. Sub-issue and dependency endpoints take the **ID**. Capture it at creation (`--jq '.id'`) or fetch it: `gh api repos/{owner}/{repo}/issues/{number} --jq '.id'`.

## Sub-Issues

A parent can hold up to 100 sub-issues, nested 8 levels deep, spanning repos under the same owner.

Create and link (the ID must be sent as an integer — `-f` sends strings and returns 422, so pipe JSON via `--input`). Capture both `number` and `id` at creation: dependency endpoints will need the number too.

```bash
SUB=$(gh api repos/{owner}/{repo}/issues -X POST \
  -f title="Sub-task title" -f body="..." --jq '{number, id}')
SUB_ID=$(jq '.id' <<<"$SUB")
SUB_NUMBER=$(jq '.number' <<<"$SUB")

echo "{\"sub_issue_id\": $SUB_ID}" | \
  gh api repos/{owner}/{repo}/issues/{parent_number}/sub_issues -X POST --input -
```

| Operation | Command |
|-----------|---------|
| List sub-issues | `gh api repos/{owner}/{repo}/issues/{n}/sub_issues` |
| Get parent | `gh api repos/{owner}/{repo}/issues/{n}/parent` |
| Move to new parent | add `"replace_parent": true` to the link JSON |
| Remove sub-issue | `echo '{"sub_issue_id": ID}' \| gh api .../issues/{parent_n}/sub_issue -X DELETE --input -` |
| Reorder | `echo '{"sub_issue_id": ID, "after_id": OTHER_ID}' \| gh api .../issues/{parent_n}/sub_issues/priority -X PATCH --input -` |

Progress summary (GraphQL): `subIssuesSummary { total completed percentCompleted }` on the parent issue.

## Dependencies (Blocked By / Blocking)

Formal relationships, visible in the UI — use these for execution order, not prose or milestone grouping. The URL path takes the blocked issue's **number**; the payload takes the blocking issue's **ID**.

```bash
# What blocks issue {n}?
gh api repos/{owner}/{repo}/issues/{n}/dependencies/blocked_by

# Mark {n} as blocked by another issue
echo '{"issue_id": BLOCKING_ISSUE_ID}' | \
  gh api repos/{owner}/{repo}/issues/{n}/dependencies/blocked_by -X POST --input -

# Remove the dependency
gh api repos/{owner}/{repo}/issues/{n}/dependencies/blocked_by/{blocking_issue_id} -X DELETE
```

Both directions at once (GraphQL): `blockedBy(first: 10)` and `blocking(first: 10)` on the issue. Task-list references (`- [ ] #123`) create read-only `trackedIssues` relationships automatically — no API to manage them.

## Milestones

A milestone groups issues into a deliverable; it does not order them. API operations use the milestone **number**, not its title.

| Operation | Command |
|-----------|---------|
| List | `gh api "repos/{owner}/{repo}/milestones?state=all&per_page=100" --paginate --jq '.[] | {number, title, state, due_on}'` |
| Create | `gh api repos/{owner}/{repo}/milestones -X POST -f title="..." -f description="..." -f due_on="2026-12-01T00:00:00Z"` |
| Update / close | `gh api repos/{owner}/{repo}/milestones/{m} -X PATCH -f state=closed` |
| Assign issue | `gh api repos/{owner}/{repo}/issues/{n} -X PATCH -F milestone={m}` |
| Unassign issue | `gh api repos/{owner}/{repo}/issues/{n} -X PATCH -F milestone=null` |
| Issues in milestone | `gh api "repos/{owner}/{repo}/issues?milestone={m}&state=all&per_page=100" --paginate --jq '.[] | select(.pull_request == null) | {number, title, state}'` |

The issues endpoint also returns PRs — filter out entries with `pull_request` as above. Delete a milestone only on explicit request.

## Label Administration

`gh label list` returns 30 by default — **always pass `--limit 1000`** when the answer decides whether a label exists.

| Operation | Command |
|-----------|---------|
| List / search | `gh label list --limit 1000 --search "triage" --json name,color,description` |
| Create | `gh label create "needs-triage" --color FBCA04 --description "Awaiting review"` |
| Create-or-update (idempotent) | add `--force` |
| Rename / recolor | `gh label edit "needs-triage" --name "triage" --color D93F0B` |
| Clone from another repo | `gh label clone {owner}/{source-repo}` |
| Replace ALL labels on issue | `gh api repos/{owner}/{repo}/issues/{n}/labels -X PUT -f 'labels[]=bug'` |
| Delete | `gh label delete "triage" --yes` — removes it from every issue; explicit request only |

Rules: color is six hex chars without `#`; description ≤ 100 chars; names match case-insensitively; quote names with spaces. Prefer `--add-label`/`--remove-label` (partial) over `PUT` (replaces the whole set).
