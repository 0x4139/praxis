# Decide

One verdict per machine, with a written reason. No machine leaves this stage undecided, and "make it explicit" is not automatically the answer.

Read `verdicts.md` for the rubric, the tiebreak, and the tool ladder. This file is the procedure.

## The three verdicts

| Verdict | Means | Costs |
|---------|-------|-------|
| **model** | Make the machine explicit: named states, one transition function, illegal edges rejected loudly | Real work, real regression risk, needs `migrate.md` |
| **tolerate** | The machine is real and stays implicit. Recorded in the register with the reason | Nothing now; the suspicion is named so the next audit starts informed |
| **delete** | The machine should not exist | Usually the cheapest fix available |

`delete` is the verdict most finders never reach, and it applies more often than `model`:

- The state is **derivable** from other data. Remove the flag and compute it. Multiple writers to a derived value is the original defect; a machine around it is a bandage.
- The flags are **independent attributes**, not alternative modes. `isAdmin`, `isGrounded`, `hasAvatar` have no transition rules. A plain record is correct and a machine is a downgrade.
- The state is **unreachable** and should stay that way. Delete the branch that handles it rather than modelling a mode nobody enters.
- The machine is a **duplicate** of one the server, framework, or query library already owns. Two sources of truth for one mode is worse than either alone.

## Score before deciding

Per machine, one line each. Be concrete; a score with no named consequence is a feeling.

- **UX** — what a user experiences in the reachable bad states. Name the dead end, the stuck spinner, the lost form, the double charge. "None reachable" is a legitimate and common answer.
- **DX** — what it costs to change this code. Count the sites a new mode would have to touch. Say whether the illegal combination is currently typable.
- **AX** — how many files an agent must read to learn the rules, and whether adding a state produces a compiler error at every site that must change or silent fallthrough.

Then the trade, in one sentence, when one of the three loses. The ordering is **UX > DX > AX**: a user in a dead end cannot route around it, a developer can read more files, and an agent can be given a pointer. Record the loss rather than claiming all three rose.

## Decide

A machine earns `model` when both hold:

1. `reach.md` confirmed at least one reachable violation with a real consequence, **or** the machine has a `MISSING` edge on a flow a user waits in.
2. The cost of modelling is proportionate: the file is already being changed, or the consequence is money, data, or auth.

Otherwise `tolerate`, unless one of the `delete` conditions applies — check `delete` first, always, because it dominates `model` when it fits.

Churn breaks ties. A machine whose `git log` shows flags added to fight other flags will get worse on its own; a machine untouched for two years will not.

## Pick the tier at the same time

A `model` verdict is incomplete without the tier from `verdicts.md`. "Use a state machine" is not a decision — a union type with an exhaustive switch and a durable execution engine are both state machines and they differ by three orders of magnitude in cost.

Name the lowest tier that holds the invariants. Then name the tier above it and say in one clause why it is not needed; that sentence is what stops the refactor growing in `migrate.md`.

## Close the stage

A decision table, ordered by consequence:

| Machine | Verdict | Tier | Reachable violations | Reason | Trade recorded |
|---------|---------|------|---------------------|--------|----------------|

Then the honest total — "4 model, 9 tolerate, 3 delete, 26 surveyed-not-charted" — and the offer:

> Migrate the upload pipeline first? It is the only one with a reachable double-write, and it is 2 of the 4. The three deletes are each a one-line change and can go in the same pass.

Everything decided goes to `register.md` whether or not anything is migrated. A decided register with zero migrations is a complete, valuable outcome.

Next: `migrate.md` on request, otherwise `register.md`.
