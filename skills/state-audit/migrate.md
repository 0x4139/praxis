# Migrate

Runs only when the user asks, on one machine at a time, in the order `decide.md` ranked. This is the only stage that writes to the user's code.

## The split that makes this safe

"Without breaking anything" is not one requirement. It is two, and conflating them is how this audit breaks production.

| | **Representation change** | **Behavior change** |
|---|---|---|
| What | Three booleans become one union. Transitions move into one function. The same states, the same edges | A reachable invalid state is closed. An `UNHANDLED` cell gets a handler. A `MISSING` timeout appears |
| Observable effect | None. Every existing test must stay green | The app does something different in exactly the cases `reach.md` proved reachable |
| Needs | Nothing but a green suite | The user's explicit sign-off, per change |
| Commit | Its own, labelled `refactor` | Its own, labelled `fix`, with the reachable path in the body |

**Never one commit.** When both land together, a failing test cannot tell you whether you broke the refactor or fixed the bug, and a revert takes the fix out with the mistake.

## Pin behavior before changing it

Characterization tests record what the code does *now*, warts and all. Write them against the transition table from `chart.md`: for each state-event pair, drive the machine there and assert the current destination — including the `UNHANDLED` cells, where you assert the wrong behavior on purpose, with a comment saying so.

```
// CHARACTERIZATION: current behavior, not desired. submitting+submit silently
// double-posts (see STATE-MACHINES.md, upload-pipeline, violation V2).
// This assertion is expected to change in the fix commit.
```

That comment is the whole trick. A pinned bug is a test that must *fail* when you fix it, and a fix with no failing test never proved it fixed anything. If a test still passes after you closed a reachable bad state, the test never reached it — go back to `reach.md`.

Pin the reachable violations first; they are the ones that matter. Do not attempt full matrix coverage before the refactor on a machine with twelve states, or the pinning becomes the project.

## Change the representation

1. **Introduce the type beside the old flags, not instead of them.** Expand, migrate, contract: add the state type and derive it from the existing flags, so both representations are live and agreeing.
2. **Move readers over one at a time,** running the suite between. Each reader that switches to the union gets an exhaustive switch — no `default` branch that swallows new states.
3. **Move the writers last,** and to one transition function rather than to the new type directly. Scattered writes to a tidy type is the same defect in better clothes.
4. **Delete the old flags** once nothing reads them. This is the contract step, and skipping it leaves two sources of truth — strictly worse than the flag soup you started with.

For a **persisted** machine the same sequence applies with migrations: add the column, backfill from the flags, dual-write while both exist, cut readers over, then drop. The invariant goes in as a `CHECK` or enum constraint *before* the backfill, so the backfill tells you how many rows already violate it. Guard the write with a compare-and-set on the current state — `where status = $expected` — or concurrent transitions will corrupt the machine the day you ship it.

## Then change the behavior, one violation at a time

Per reachable violation from the ledger: flip its characterization test to the correct assertion, watch it fail, make it pass, commit with the path in the body.

Decide out loud what the closed state becomes. A state that can no longer be entered has to do something else instead — reject loudly, fall back, or retry — and that choice is a product decision, not a refactor detail. Silently dropping an event is how an `UNHANDLED` cell becomes a `MISSING` edge.

Add the four edges while you are here if `chart.md` found them missing: timeout, retry, cancel, recovery. These are the UX half of the audit and they are usually the smallest diff in it.

## Verify, then stop

- Full suite green, and the characterization tests you flipped are the only ones whose assertions changed.
- Every switch over the state type is exhaustive — add a state locally and confirm the build breaks everywhere it should. If it compiles, the AX claim is false.
- Grep for the deleted flags. Zero hits outside tests.
- For persisted machines, re-run the invariant query. Zero violating rows, and the constraint is in place to keep it so.
- The register entry updated with what actually landed.

Then stop and hand back. Do not continue to the next machine on momentum — return to `decide.md`'s ordering and let the user choose, because the suite is green now and that is a good place to be left.

Next: `register.md`.
