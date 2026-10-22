# Model

Understand the system before looking for anything wrong with it. This stage has one hard rule that makes it work:

**Naming a vulnerability here is forbidden.** Not discouraged — forbidden. The output is what the system *intends* and what actually enforces it. An auditor who starts naming bugs during modelling stops modelling, anchors on the first three things it noticed, and hands the hunting stage a list instead of a map. Bugs noticed anyway go in a holding note and are not developed.

## 1. Recon, in Parallel

Four agents, each with a narrow question and a word budget. None of them is looking for vulnerabilities.

| Agent | Question |
|-------|----------|
| **Product** | What is this for, what is the stack, how is it built and deployed? |
| **Principals** | Who are the actors, what authority does each hold, and which controls grant or withhold it? |
| **Surfaces** | Where does untrusted data enter, where does it get copied, and which dangerous operations does it reach? |
| **Feasibility** | What can be observed here — is there a test suite, a sandbox, a local run, a way to check a claim? |

Returns collapse into one `architecture.md` in the audit directory, about a thousand words. Longer than that and no hunter will read it; the detail belongs in the ledger instead.

## 2. Record Invariants and Assumptions

The real deliverable. For every rule the system depends on, write the rule, then what enforces it, then where.

```md
| Invariant | Established by | Where |
|-----------|----------------|-------|
| A task is readable only by members of its project | `requireProjectMember` middleware | `api/mw/auth.go:88` |
| An upload is under 10 MB | nothing found | — |
| A refund never exceeds the original charge | partial — checked in the handler, not in the batch job | `billing/refund.go:41` |
```

Three markers carry the signal:

- **`nothing found`** — the system depends on this and nothing was located that enforces it. This is the highest-value output of the entire stage. Hand every one of these to hunting as a lead.
- **`partial`** — enforced on some paths and not others. A precondition established on three paths out of four is an assumption, not an invariant, and the fourth path is where to look.
- **A named enforcer with a file and line** — settled, and a hunter that reports a finding contradicting it must cite why that enforcement does not hold on its path.

Also record the **assumptions the code makes about its callers** — validation it believes happened elsewhere. Every one of those is a question for whoever calls it.

## 3. Draw the Trust Boundaries

Name each boundary, which direction data crosses it, and what revalidates on the far side. These seed the chained-and-boundary class, which finds what no single-lens hunter can: two harmless halves that compose.

For each entry point, fix the **attacker position** by tracing back to the first untrusted principal — by barrier, never by transport. That position, not the protocol, is what `severity.md` rates.

## 4. Seed the Coverage Ledger

One row per unit of work, where a unit is a surface crossed with a boundary crossed with a class. The ledger is the coverage claim, and it is what turns "we reviewed auth" — which is not evidence of anything — into something a reader can check.

```md
| id | surface | boundary | class | status | evidence |
|----|---------|----------|-------|--------|----------|
| u1 | POST /tasks | anon → tenant | injection-and-input | open | — |
| u2 | POST /tasks | anon → tenant | auth-and-access | open | — |
| u3 | tools/exec | model → shell | agentic-and-ai | open | — |
```

Statuses: `open`, `hunted` (with the files read), `found` (with candidate ids), `excluded` (with a reason), `not-reached` (with what stopped it). A unit is roughly one hunter's worth of work, which makes the remaining spend countable rather than guessed.

Every top-level directory of the target must land in a component that is either covered or explicitly excluded. A directory skipped on purpose is disclosure; a directory nobody mentions is a hole in the audit that the report will silently paper over.

## Exit

`architecture.md`, `invariants.md`, the boundary list, and a seeded `ledger.md`. Summarise for the user in a few lines — what the system does, who can reach it, and **how many invariants came back `nothing found`**, since that number predicts what hunting will return better than anything else at this point. Then hand to `hunt.md`.
