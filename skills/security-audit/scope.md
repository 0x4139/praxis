# Scope

Decide what is being audited, how hard, and what the run is allowed to spend — before any of it is spent. A run that discovers broadly and verifies nothing has produced nothing, so verification is reserved first and hunting gets the remainder.

## 1. Resolve the Mode

| Mode | When | What is in scope |
|------|------|------------------|
| **codebase** | A repository or a named path | Everything under the target, partitioned into components |
| **changes** | A branch, a PR, a commit range | The diff, read in the context of the whole files it touches |
| **adjudicate** | One finding to settle | That claim only — go straight to `verify.md` |

**In changes mode, resolve the base explicitly and name it in the report.** The three plausible defaults — merge base with the trunk, the upstream branch, the working tree — disagree, and a silent choice produces an audit of something other than what the user meant. State it: *auditing 14 commits against the merge base with `master`.*

Only committed work is diffable. If the tree is dirty, say so and offer the choice: commit or stash and audit the diff, or audit the files as they stand in codebase mode. Record the dirty state either way — it belongs in Coverage.

**The changes-mode rule that keeps cost down:** start from the changed lines, read the changed files whole, and follow data into and out of the change only as far as judging it requires. A flaw the change takes no part in — same source, same sink, same guards before and after — is not this audit's finding. Note it for a codebase run instead.

## 2. Map the Domain

Four questions, answered from the code rather than assumed. They decide which classes get hunters.

- **Ways in.** Routes, CLI arguments, queue consumers, webhooks, file and archive parsers, environment, IPC, scheduled jobs, model and tool surfaces.
- **Who is on the other side** of each one, and what they are trusted with. Anonymous internet, authenticated tenant, operator, another service, a model.
- **State that sticks around.** Databases, caches, filesystems, agent memory, vector stores, config and policy files.
- **Calls you cannot see inside.** Third-party services, FFI, subprocesses, model providers, MCP servers.

Then select classes from `classes.md`. Prune what the target does not have — and record each prune with its reason, because an unrun lens that nobody mentions is the difference between "clean" and "not examined".

## 3. Pick the Effort Profile

Profiles change **breadth and redundancy, never the evidence bar**. A finding confirmed in a quick run met the same standard as one confirmed in a deep run; there were simply fewer hunters looking.

| Profile | Hunting | Verification | Use when |
|---------|---------|--------------|----------|
| **quick** | One generalist sweep plus the obvious-things pass | Panel of 3 on each candidate | A diff, a single feature, a fast answer |
| **standard** | One hunter per selected class | Panel of 3, plus a boundary hunter | The default for a real audit |
| **deep** | Two waves — cheap triage, then deep hunters on hotspots — plus wildcard | Panel of 3, plus a second pass on anything upgraded | A codebase that has never been audited, or one about to be exposed |

One number is worth stating to the user up front: **a single run finds roughly half of what repeated runs find**, and what it finds skews toward the simpler bugs. Deep buys redundancy against that, not a different standard.

## 4. Reserve the Budget

Fix a total agent count, then take verification out of it first. For every candidate expected, three voters are owed; a final critic is reserved separately and cannot be spent on hunting. Hunters draw on what is left.

When the budget runs out mid-run, the run ends `incomplete` with a named reason and the ledger showing what was never reached. It does not end by quietly skipping verification — an unverified candidate is not a finding and must never be reported as one.

## 5. Set Up the Workspace

Create `audit/<date>-<target>/`. Everything the run produces lives there:

| Artifact | Written by | Holds |
|----------|-----------|-------|
| `architecture.md` | model | What the system is and who can reach it |
| `invariants.md` | model | The rules, what enforces each, and where |
| `ledger.md` | model, then hunt | One row per unit of work, with status and evidence |
| `candidates/C*.md` | hunt | One candidate per file |
| `votes/C*-<lens>.md` | verify | One vote per file, written before any tally |
| `REPORT.md` | report | The artifact a human reads |
| `patches/F*.diff` | patch | On request, never applied |

The lead is the only writer of shared files. Subagents write their own files and return a
path and an id — never a payload.

**Tell the user this directory will contain security findings** and should not be committed to a public repository without review. Add it to `.gitignore` unless they say otherwise.

## Exit

Confirm before dispatching anything: the mode and base, the classes selected and pruned, the profile, the budget, and where output lands. **Proceed is never the default** — a full audit spends real money and time, and the one question that precedes it is cheaper than a misaimed run. Then hand to `model.md`.
