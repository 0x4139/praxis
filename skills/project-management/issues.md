# GitHub Issues

Issues are the unit of trackable work. A good issue is self-contained: someone who wasn't in the conversation can pick it up, understand why it exists, and know when it's done. Every operation here runs through the `gh` CLI — no MCP server required.

## When to Activate

- Filing a single issue: bug, feature request, task, or chore
- Converting a plan, review findings, or a TODO list into a set of issues
- Structuring a feature as a parent issue with sub-issues and dependencies
- Managing issue metadata: labels, milestones, assignees, issue types, state

## Workflow

1. **Confirm the repository.** Use the current repo's `origin` unless the user names another. Never guess an owner/repo.
2. **Learn the repo's taxonomy before writing.** Check what exists — matching the repo's conventions beats inventing your own:
   ```bash
   gh label list --limit 1000                  # default limit is 30; always pass --limit
   gh api "repos/{owner}/{repo}/milestones?state=open&per_page=100" --paginate --jq '.[] | {number, title}'
   gh api graphql -f query='{ organization(login: "ORG") { issueTypes(first: 10) { nodes { name } } } }' \
     --jq '.data.organization.issueTypes.nodes[].name' 2>/dev/null   # empty = no issue types
   ```
   Substitute `ORG` with the repo owner (`gh repo view --json owner -q .owner.login`) — gh does not fill GraphQL bodies. Issue types are organization-level; user-owned repos never have them, and the query's failure there (masked above) correctly means "no types".
3. **Pick a body template** from `issue-templates.md` — bug report, feature request, task, epic, or minimal. Fill every bracket or delete the section; never ship placeholder text.
4. **Write the title**: specific and actionable, under 72 characters, no redundant `[Bug]`/`[Feature]` prefixes when an issue type carries that information. `Login fails with SSO enabled`, not `[BUG] login problem`.
5. **Create**, then **report the issue URL** to the user.

Ask for missing critical information (a bug's repro steps, a feature's constraints) rather than inventing it. For a breakdown, proposing a split and confirming it with the user counts as asking — draft the issues, don't silently create them.

## Creating an Issue

`gh api` supports everything, including issue types (`gh issue create` has no `--type` flag):

```bash
gh api repos/{owner}/{repo}/issues \
  -X POST \
  -f title="Login fails with SSO enabled" \
  -f type="Bug" \
  -f 'labels[]=high-priority' \
  -f 'assignees[]=username' \
  -F milestone=3 \
  -f body="$(cat <<'EOF'
## Description
...
EOF
)" \
  --jq '{number, html_url}'
```

- Quote the whole `'labels[]=value'` pair — unquoted `[]` breaks in zsh. Repeat the flag for multiple labels or assignees.
- `-f` sends strings; use `-F` for numbers like `milestone`.
- Prefer issue types (`Bug`, `Feature`, `Task`, `Epic`) over equivalent labels when the org has them configured. If no configured type fits, use the closest existing type or an existing label; create a new label (with color and description) only when the repo's taxonomy has no fit at all.
- Milestones go by **number**, not title.

## Updating an Issue

`PATCH` with only the fields that change:

```bash
gh api repos/{owner}/{repo}/issues/{number} -X PATCH -f state=closed --jq '{number, html_url}'
gh issue edit {number} --add-label "bug" --remove-label "needs-triage"   # partial label changes
```

## Breaking Work Down

For a feature or plan that becomes multiple issues:

1. Create the parent with the **Epic template** — outcome, scope, out-of-scope.
2. Create each child with the **Task template** — its Checklist carries the child's acceptance criteria. Capture each child's `number` and `id`, then link it as a sub-issue of the parent (two-step loop in `issues-advanced.md`).
3. Order execution with **blocked-by dependencies**, not prose. A milestone groups a deliverable; it does not order work.
4. Keep each child independently completable.
5. Update the parent's Breakdown section with the children's plain-text titles — not `- [ ] #N` task-list references, which double-track issues already linked as sub-issues.

Commands for sub-issues, dependencies, milestones, and label administration: `issues-advanced.md`.

## Quick Reference

| Operation | Command |
|-----------|---------|
| Create issue | `gh api repos/{owner}/{repo}/issues -X POST -f title=... -f body=...` |
| Update / close | `gh api repos/{owner}/{repo}/issues/{n} -X PATCH -f state=closed` |
| Comment | `gh api repos/{owner}/{repo}/issues/{n}/comments -X POST -f body=...` |
| List / search | `gh issue list --state open --label bug` · `gh search issues "query"` |
| View | `gh issue view {n} --json title,body,labels,milestone` |
| Add/remove label | `gh issue edit {n} --add-label X --remove-label Y` |

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Assuming a label exists | `gh label list --limit 1000` first — the default 30 silently hides the rest |
| `[Bug]` prefix and a `bug` label and `type=Bug` | One categorization: prefer the issue type |
| `-f milestone=3` returns 422 | `-f` sends strings; numbers need `-F` |
| Sub-issue linked by issue *number* | Sub-issue and dependency endpoints take the numeric issue **ID** (`.id` field) |
| Shipping `[Clear description of the bug]` placeholders | Fill or delete every bracketed section |
| Deleting labels/milestones as cleanup | Deletion propagates to every issue; only on explicit request |
| Creating issues in a guessed repo | Confirm owner/repo from git remote or the user first |
