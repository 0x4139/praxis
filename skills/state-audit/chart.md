# Chart

Turn one candidate into an explicit machine on paper. Charting is reading, not writing — the code does not change in this stage, and the chart may well conclude that there is no machine here.

Do one candidate at a time, and finish it before starting the next.

## Find the real states before naming them

Start from the writes, not the reads. Collect every site that assigns to the candidate's variables, then ask what combination holds *after* each write. Those combinations, deduplicated, are the states the code can be in. Name each one for the mode it represents, not for the flag values that encode it: `awaiting-upload`, not `notLoadingNotDone`.

Two tests that a state is real:

- Some code behaves differently in it. A combination no reader distinguishes is not a state, it is noise.
- You can say what the system is *waiting for* in it. A state with nothing pending and no edge out is a terminal state — mark it, and check whether it should be terminal.

## Split orthogonal concerns immediately

Before building a table, check whether the candidate is one machine or several. Two concerns are orthogonal when every state of one can coexist with every state of the next: connection status and edit mode, locomotion and combat, playback state and mute.

Chart orthogonal concerns as separate machines. Forcing them into one enum multiplies states and transitions for nothing, and the resulting table is the artifact that makes people distrust this whole practice. If the candidate splits, say so — "this is three machines, not one" is one of the most valuable findings available here.

## Build the transition table

Rows are states, columns are events, cells are the destination state plus any guard. Write the table *total*: every state-event pair gets a cell, and the ones that should not happen get an explicit marker rather than a blank.

```
state           event            ->  next state       guard
--------------  ---------------  --  ---------------  ---------------------------
idle            submit           ->  validating       -
validating      valid            ->  submitting       -
validating      invalid          ->  idle             (errors surfaced)
submitting      ok               ->  done             -
submitting      fail             ->  idle             retries < 3
submitting      fail             ->  failed           retries >= 3
submitting      cancel           ->  ILLEGAL          request already in flight
submitting      submit           ->  UNHANDLED        second submit is silently dropped
done            *                ->  TERMINAL         -
```

Three cell markers carry the finding:

- `ILLEGAL` — the pair must never occur and the code rejects it.
- `UNHANDLED` — the pair can occur and the code does nothing, or does something by accident. These are the candidates `reach.md` will test.
- `MISSING` — there is no event at all that leaves this state. A dead end.

The events are the hard part, and they are not all user actions. Timeouts, network failures, a second click, a page refresh mid-flow, a websocket drop, a job retry, a deploy restarting the process — every one is an event, and the unmodelled ones are where the UNHANDLED cells come from.

## Write the invariants

Three to six sentences, each of the form "never X" or "always Y", each about the whole machine rather than one state. These are what `reach.md` tests against.

> Never submitting and done at once. Never a persisted row in `processing` with no worker heartbeat for 10 minutes. Always exactly one of the four statuses. Always an edge out of every non-terminal state within 30s or by user action.

Invariants come from what the system is *for*. "An order marked shipped has a shipping address" is not readable from the flags; it is readable from knowing what shipping is.

## Close the chart

Per machine, hand over: the state list, the orthogonality verdict, the total transition table, the invariants, and the `UNHANDLED`/`MISSING` cells as *candidate* violations — explicitly not yet confirmed reachable.

If charting concluded there is no machine — independent attributes, or a two-state toggle with no illegal transitions — say that plainly and send it to `decide.md` for a `delete` or `tolerate` verdict. A candidate that charts to nothing is a successful chart.

Next: `reach.md`.
