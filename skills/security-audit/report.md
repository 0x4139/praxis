# Report

The one artifact written as prose rather than assembled, and it has a specific reader: an engineer who owns this code, is busy, and will decide in about ninety seconds whether to act on each finding. Everything here serves that reader.

Write to `REPORT.md` in the audit directory.

## Shape

```md
# Security audit — <target>

<One paragraph: what was audited, against which base, at which profile, and the headline.
If nothing was found, say that here and mean it.>

## Coverage
## Findings
## Pre-existing          (changes mode, if any)
## Hardening notes       (if any)
## Out of scope
## Positive controls observed
## What was verified
```

## The Finding Block

```md
### F1 — Tenant isolation bypass on task listing (HIGH, confidence medium)

**Impact.** Any authenticated user can read every task in every other tenant, including
titles and attachment URLs. Lead with this — it is what decides priority.

**Where.** `api/handlers/task.go:142` in `ListTasks` — CWE-639

**Link to the change.** `api/handlers/task.go:139` added the `project_id` query parameter
that reaches the unguarded query. (Changes mode only; name the line, never quote it.)

**What.** Two or three sentences. Name the untrusted source, the dangerous operation, and
why nothing between them stops it.

**Exploit scenario.** Concretely what is sent, what happens, what comes back. Not "an
attacker could enumerate tenants" — the request, the response, the data obtained.

**Preconditions.** Bullets: what must be true. Any authenticated account? A non-default
config? Victim interaction? An empty list means none, and that is worth stating.

**Fix.** What to change, in outcome terms — the root cause at the sink, not a patch at one
caller.

**Evidence.** statically-confirmed · 3/3 lens verifiers confirmed
```

Rules that hold for every block:

- **Order by severity, then confidence.** The reader stops partway down. Put what matters at the top.
- **Every finding cites a real `file:line`.** A finding pointing at the wrong line costs more than a missed one: the reader loses trust in the whole report while chasing it.
- **Severity is exploitability and impact; uncertainty lives in confidence.** Where a cap from `severity.md` fired, say which and why.
- **No hedging and no padding.** Do not soften a real finding to be polite about the code, and do not inflate a nit to look thorough.
- **Above about twenty findings, write in batches.** A single write holding everything can exceed the output limit, and a truncated write is refused whole — losing the entire report rather than part of it.
- **Only `\n` and `\t`.** This is read in a terminal, where an escape sequence can rewrite what a human sees. Where such a byte genuinely appears in the audited source, describe it instead of reproducing it.

## Coverage

The section that makes everything else trustworthy: a reader who knows what was not examined can calibrate the rest. **A report silent about lost coverage reads as a clean audit.**

Report, from the ledger: components audited; components skipped, each with its reason; hunters dispatched versus returned, and why any were lost; candidates raised but never verified; classes pruned and why — including memory safety pruned for a managed language; whether every top-level directory landed in a covered or excluded component, or whether that could not be checked; the working tree's state; and in changes mode, the base and the fact that commits already pushed were not part of this review.

A directory skipped on purpose is disclosure, not failure. State the reason and the area stays accounted for; omit it and the area silently vanishes, which is exactly the coverage a "no findings" would overstate.

## Out of Scope

What was deliberately not looked at, and why. Dependency CVEs and version currency belong here by default — they are a separate process with its own tooling, not an audit finding. So does anything the user excluded, and anything in `exclusions.md` that the reader might otherwise expect to see.

## Positive Controls Observed

The defenses that *are* in place and were verified: parameterized queries throughout the data layer, an auth middleware that genuinely cannot be bypassed, a CSP that holds, constant-time comparison where it matters.

Rarely included and worth including. It tells the reader which of their existing defenses were confirmed rather than assumed, it stops the report reading as pure indictment, and it means a future audit need not re-derive what was already settled.

## What Was Verified

The honest provenance paragraph, and it is not optional.

Say which findings are `statically-confirmed` and which are `reproduced`, and that **nothing in a read-only audit executed the repository's code** — no tests were run, no exploit fired, no proof-of-concept validated. Every finding derives from reading. Say so rather than letting a confident tone imply a demonstration.

And the sentence that belongs in every security report: **the absence of findings does not indicate the target is secure.** It indicates what this audit covered, at this depth, within this budget.

## Secrets

File and line, never the value. Findings get pasted into tickets, decks, and committed markdown — copying a credential into a report multiplies the exposure the audit exists to find.

Where identifying it needs a fragment, mask to a short prefix: `AKIA****`, `postgres://app_user:****@db-prod…`. A variable name is not a value. `${API_KEY}` and `<your-token>` are not values. In a `user:password` pair only the password is. Both halves of a key pair are. A truncated or encoded copy of a secret is still the secret.

A hardcoded-credential finding gets **no** "Link to the change" line — the changed line it would name *is* the credential.

## The Clean Run

A run with no confirmed findings is a complete and valuable result. Write it as one: the headline says nothing was confirmed, Coverage says exactly what was examined and what was not, Positive controls says what held, and no LOW findings are invented to fill the page.

A clean report that is honest about its coverage is worth more than a page of maybes, and it is the harder of the two to write.

## Exit

Give the user the path and a three-line summary: how many findings at what severities, what was covered, and the single thing to do first. Then offer `patch.md` if they want fixes drafted, or `distill` if the findings should become tracked work.
