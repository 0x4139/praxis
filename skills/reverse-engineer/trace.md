# Trace

The expensive stage, entered only for the fact-list items inventory could not settle, and scoped to those items. This is not where you explore — exploration here is how a run loses an afternoon.

## Traversals, Not Exploration

Follow a named path. Each of these is a defined route through a known architecture, which is why they terminate.

**String to owner.** You have a string — an endpoint, an error message, a key name — and want the code that uses it. Get its address from the literal-pool comments in the disassembly dump, then scan **upward** to the enclosing function label. The function that references a URL is usually the function that calls it.

**Boundary inward.** For an app with a fixed architecture, walk the known hops rather than searching. Electron: native call → its caller class → the `ipcMain` registration → the renderer or preload. Android: exported component → its handler → the native bridge. The hops are fixed by the framework, so the traversal is a lookup.

**Call sequence, not instructions.** Inside a function, read the names of what it calls and skip the arithmetic. A branch to `getpeereid` names a peer-authentication mechanism; a branch to `CCHmac` names a signature scheme. The callee names are a high-level trace of the function's purpose, and reading them is minutes rather than hours.

**Inventory diff.** Comparing two builds: diff exports, imports, module lists and manifests *before* diffing any code. Cheap, often the whole answer, and it tells you which functions are worth disassembling.

## Hypothesis Cards

When a question needs more than one hop, write it down as a card — the same primitive the `debug` agent uses, because it is the right one:

```md
**Hypothesis.** The licence check is enforced client-side only; the endpoint is telemetry.
**Evidence for.** `CCHmac` and the endpoint string sit in the same function (`0x10004a10`).
  No `SecKeyVerifySignature` call reachable from the launch path found so far.
**Evidence against.** `SecKeyVerifySignature` is in the import table, so something uses it.
**Test.** Find every caller of `SecKeyVerifySignature` in the dump.
**Result.** Two callers, both in the update path, not the licence path.
```

The card's value is `Evidence against`. Without it you confirm your first idea, which in reverse engineering is the standard failure — the symbol names suggested a story and you went looking for support.

A card with a filled `Result` is either a finding with locators or a refuted guess. Both are progress. A card you abandon half-filled is an `Unknown` with its blocker already written.

## Static to Runtime

Reading a path that *can* do something never establishes that it does. Where the fact list needs a behavioral claim and the target can be run, escalate deliberately:

- Confirm the user agrees and owns the target.
- Observe the narrowest thing that answers the item — one syscall filter, one request listener, one log predicate. Not a full trace.
- Record **what you ran** alongside **what you saw**. That pairing is what makes it an observation rather than a story.

Where runtime observation is not available, the honest result is the static claim phrased as a static claim, plus an `Unknown` for the behavioral question with "not run" as its blocker. That is a complete answer, not a failure.

## Economy

- **Never re-run the producer.** The disassembly is on disk; grep it. Re-running a decompiler to re-read what you already dumped costs a turn and tells you nothing new.
- **A decompiler returning nothing is a fact about the decompiler**, not about the function. Record it as a blocker and try a different instrument or a different rung.
- **Stop at the item, not at satisfaction.** When the fact list item has evidence, that item is done. The adjacent interesting thing you noticed goes in a note for the user to prioritise, not into this run.

## Exit

Each remaining fact-list item now carries evidence, or an `Unknown` with a named blocker. Hypothesis cards are resolved or explicitly abandoned. Hand to `record.md`.
