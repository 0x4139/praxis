# Inventory

The cheap facts, taken in one batched call. This stage routinely answers the whole question, and it is the reason the funnel exists: a small binary's imports and strings tell you what it does for the price of a single round trip.

Do not skip it because the question feels deep. Deep questions get cheaper after inventory.

## 1. Batch the Recon

One call, section-marked, everything capped. The exact probes come from the target's entry in `targets.md`; the shape is always the same:

```sh
echo '--- identity'; file -b T
echo '--- imports'; nm -u T 2>/dev/null | rg -v '^__Z|^_objc_' | head -40
echo '--- exports'; nm -gU T 2>/dev/null | head -30
echo '--- linked'; otool -L T 2>/dev/null || readelf -dW T | rg NEEDED
echo '--- strings/net'; strings -a T | rg -i 'https?://|\.com|token|secret' | head -30
echo '--- metadata'; go version -m T 2>/dev/null | head -20
```

Filter noise **in the pipeline, not in your context** — mangled symbols, framework prefixes, padding. What reaches you should already be the signal.

## 2. Read the Capability Map

**Imports bound what the artifact can do.** A binary that never links a crypto library is not doing crypto in-process; one that imports keychain, camera, or network APIs has those capabilities whether or not you have found the call sites yet.

This is the highest-value cheap read available, and it inverts the usual order: instead of hunting for a behavior and hoping to find it, you enumerate what is *possible* and narrow from there.

Treat it as a bound, not a behavior. A linked capability is `Observed` as linked; that it is *used* is a separate claim needing its own evidence.

## 3. Answer the Four Questions

The same four that `security-audit` asks of a codebase, and which a top-tier audit firm arrived at independently — answered here from the artifact rather than from source:

- **Ways in.** Endpoints, URL schemes, IPC channels, exported symbols, listening ports, registered handlers, file associations.
- **Who is on the other side** of each, and what it is trusted with.
- **State that sticks around.** Databases, caches, keychain items, preference files, logs.
- **Calls you cannot see inside.** Dynamically linked libraries, remote services, a runtime you have not instrumented, bytecode you cannot decompile.

The fourth is the one that produces honest `Unknown`s instead of invented answers.

## 4. Check the Fact List

Go back to `frame.md`'s numbered list and mark what inventory already settled, with locators. Then decide:

- **Every item has evidence** → go to `record.md`. You are done, and that is the common case for a focused question.
- **Some items remain** → `trace.md`, scoped to *only* those items. Not a general exploration.
- **An item is unanswerable with available instruments** → it is an `Unknown` with a named blocker, and it does not need a trace to establish that.

Resist re-verifying what inventory already showed. An agent that loops for reassurance burns the budget that the remaining items need.

## Exit

The fact list partly or wholly answered with locators, the four questions answered, and a short explicit list of what still needs tracing. Nothing is traced that inventory already settled.
