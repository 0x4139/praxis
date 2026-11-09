# Smells

Eight tells. Each is cheap to check and each is *checked*, not felt — `survey.md` records the codes, and the count is the candidate's score. Two tells is a candidate. Four is almost always a real machine.

None of these is a defect on its own. They mark a place where modes and transition rules exist without being named, which is a different claim from "this code is wrong".

## `F` — Flag cluster

Two or more booleans read together in the same condition, or set together in the same handler. The cluster is the machine; the states are the combinations the code actually produces.

Count the combinations and count the ones with meaning. Three flags is eight combinations; if four are meaningful, the other four are states the type permits and nothing names. **This is arithmetic, not a finding** — `reach.md` decides which of the four the code can write.

## `W` — Many writers

One state variable assigned from three or more sites. The transition function exists; it is just distributed, and no single place knows all the rules.

The count is the signal and it is literal. Grep the setter name and count hits. One declaration with nine writers is the strongest cheap tell in this list.

## `D` — Derived duplicate

A stored value that could be computed from other state. `isEmpty` beside a list. `hasUnsavedChanges` beside a comparison. `total` beside line items. Every writer is re-implementing a function by hand, and they will disagree.

The fix here is usually `delete`, not `model`. Computing it from one owner removes the machine instead of formalizing it.

## `E` — Post-event assumption

A producer fires an event, calls a setter, or dispatches an action and then proceeds as though the world is in the resulting state. The assumption is a state nobody owns, and it is invisible because it lives in the ordering of two statements.

Look for a dispatch or emit followed by code that reads the state it was meant to change. Look for `setTimeout(..., 0)` and `queueMicrotask` and `nextTick` around state updates — each one is an assumption about ordering, written as a delay.

## `R` — Remote gap

The authoritative state lives across a network: another service, a payment provider, the browser's server component boundary, a websocket peer. The local copy is a shadow, the gap is real, and failures there are silent.

Shadowing a remote machine is normal. Shadowing it with no reconciliation step, no "unknown" state, and no handling for out-of-order updates is the finding. Webhooks arrive out of order. Ask what moves the local state backwards and whether anything prevents it.

## `L` — Borrowed lifecycle

The code depends on a framework's or runtime's ordering without being able to ask about it: mount order, effect order, hydration, `activeInHierarchy`, module initialization, connection pool warmup, a DI container's construction sequence. The engine owns a machine your code reads implicitly.

Null-reference crashes at startup and "works on refresh but not on first load" are this smell's signature.

## `M` — Missing edge

A state with no way out. Check every async or waiting state for the four edges: **timeout, retry, cancel, recovery**. Missing ones are the UX half of the entire audit, and unlike most findings here they need no reachability proof — the absence of any timer in the file is the evidence.

A spinner with no timeout is a dead end a user sits in until they reload and lose their work.

## `S` — Stringly status

A status field — column, enum, constant, string literal — with no rules about which transitions are legal. The values are enumerated; the edges are not. An enum constrains the *set*, never the *sequence*, and that gap is where `shipped` with no shipping address comes from.

Persisted instances of this smell outrank every other finding in the audit, because the invalid rows are already there and a query will show you how many.

## Symptom to machine

When the user arrives with a bug rather than an audit request, work backwards. Each of these symptoms is a machine with a specific shape of defect:

```
"spinner sometimes never stops"        async machine, M (no timeout) or an unhandled failure event
"double charge / duplicate record"     missing guard on a submitting state, or W on a persisted status
"stuck and have to reload"             M: a state with no edge out
"works on refresh, not first load"     L: borrowed initialization order
"the two panels disagree"              D: derived state with several writers
"it says shipped but there's no address" S: enum with no transition rules, invariant unenforced
"sometimes the job runs twice"         queue machine with no lease, or retry state held in memory
"logged in but nothing loads"          auth machine with an unnamed partial state
"fixed it by adding another flag"       F and W compounding — the machine is fighting itself
"works locally, breaks in prod"         R: a remote gap that latency makes visible
```

The last one in the list is the strongest signal in this file. A bug whose last fix was a new boolean is a machine that has already told you it needs naming.
