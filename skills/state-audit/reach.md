# Reach

The stage that makes this audit worth anything. A charted machine hands you candidate violations — `UNHANDLED` cells, `MISSING` edges, invariants that look breakable. Here each one becomes **reachable with a path** or **unreachable**, and nothing stays in between.

The failure this prevents is specific and common: a fluent, plausible, well-drawn state chart describing a bug that cannot occur. It reads as rigour, it survives review, and it buys a refactor against nothing.

## Default to unreachable

The burden is on the violation. Carry it or drop it.

What does **not** discharge the burden:

- The type permits the combination. That is a DX observation. Record it as one; it is not a reachable violation.
- The flags arithmetically allow it. 2^N is not evidence.
- "A user could double-click." Not unless you found the handler that lacks the guard.
- "Under a race condition." Name the two paths and what interleaves.
- You cannot see what prevents it. Absence of a visible guard is not absence of a guard — the guard may be upstream, in a disabled attribute, in a router redirect, in a DB constraint, in a queue's at-most-once delivery.

## Carrying the burden

For each candidate violation, write a path: an ordered list of concrete steps, each naming a `file:line`, that arrives in the bad state.

```
VIOLATION  submitting + cancel is UNHANDLED; cancel clears the form while the request is in flight
PATH       1. user submits                        CheckoutForm.tsx:84  setSubmitting(true)
           2. request begins, no abort retained   api/checkout.ts:31
           3. cancel button stays enabled         CheckoutForm.tsx:142  (no disabled={submitting})
           4. cancel resets form state            CheckoutForm.tsx:97   reset()
           5. response resolves against reset form CheckoutForm.tsx:88  setDone(true)
RESULT     done=true over an empty form; the charge succeeded server-side
VERDICT    REACHABLE
```

A path with a step you could not locate is not a path. Mark that violation `UNPROVEN` and say which step broke — that is honest and still useful, and it tells the next person exactly where to look.

## Preferred evidence, in order

1. **A failing test you wrote.** The strongest and often the cheapest: drive the machine into the state and assert the violated invariant. One test beats a page of reasoning, and it becomes the regression test in `migrate.md`.
2. **A reproduction the user confirms.** Steps in the running app.
3. **A log, trace, or database row showing the state already happened in production.** For persisted machines this is decisive — `select status, count(*)` against the invariant finds states nobody designed.
4. **A traced code path, as above.** Static reading. Say that it is static; a path that *can* execute is not a path you observed executing.

Do not escalate past what the violation is worth. A `MISSING` timeout edge on an async flow needs no test — the absence of any timer in the file is the evidence, and the consequence is self-evident.

## Check the invariants against reality

For persisted machines, query. The invariant "never `processing` with no heartbeat for 10 minutes" is either already violated in the table or it is not, and that answer is one query away. Rows that violate an invariant are the highest-grade evidence in this skill, because they are not a prediction.

Count them. "Reachable" and "reached 1,840 times last month" lead to different verdicts.

## Close the stage

Per machine, a violation ledger:

| Violation | Verdict | Evidence | Consequence when it happens |
|-----------|---------|----------|-----------------------------|

Then two counts, stated plainly: how many candidate violations were confirmed reachable, and how many were dropped as unreachable. A machine where everything dropped is a good outcome — it means the code already guards what the types don't, and the verdict is likely `tolerate`.

Report the dropped ones. A chart that only lists what survived hides the fact that the charting over-produced, and the next audit will over-produce the same way.

Next: `decide.md`.
