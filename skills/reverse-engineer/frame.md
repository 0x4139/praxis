# Frame

Turn a vague ask into a finite list of facts to find. This stage costs one exchange and it is what makes everything after it terminable — the stop condition is "every item on the list has evidence", which only works if the list exists.

## 1. Enumerate the Question

Rewrite the request as numbered facts. "Figure out what this app does" is not answerable; the same ask decomposed is:

```md
1. What does it talk to over the network — hosts, endpoints, protocols?
2. What does it store locally, and where?
3. What native capability does it link against — crypto, camera, keychain?
4. How does it authenticate to its backend?
5. Is there telemetry, and what does it carry?
```

Five items, each independently answerable, each with its own stopping point. Put the list to the user and let them cut or add before any tool runs — the cheapest moment to discover you were about to answer the wrong question.

A single sharp question needs no ceremony: *"which endpoint does it post the licence key to"* is already one item. Frame it and move.

## 2. Confirm Authorization

Once, briefly. The user's own build, their employer's artifact, something they licensed, a research or CTF target, or a vendor artifact they are permitted to inspect. Understanding software you run, interoperating with it, and researching its security are ordinary legitimate work and need no justification beyond the confirmation.

Stop and ask if the target looks like someone else's private data rather than a shipped artifact — a database of real users, a capture of a third party's traffic, a process belonging to someone else.

Where a commercial decompiler is involved, the user supplies it and is responsible for its licence.

## 3. Set the Budget

State it before starting, because the funnel in `instruments.md` only works against a budget.

| Shape | Budget | Looks like |
|-------|--------|-----------|
| **One question** | a handful of calls: one batched recon, one or two targeted slices, answer | "what host does it call" |
| **Survey** | identity, inventory, then depth only where the fact list demands it | "what does this app do" |
| **Deep** | expect decompilation or runtime observation on specific functions | "how exactly is the token derived" |

A deep run is the only shape that should reach rung 6 or 7 of the cost ladder, and even then only for named functions rather than wholesale.

## 4. Declare the Artifact

Record what you were given, exactly: path, size, and the checksum. Everything downstream is a claim about *this* artifact, and a findings doc that does not say which build it describes is worth very little three months later.

```sh
shasum -a 256 TARGET || sha256sum TARGET
```

## Exit

A numbered fact list the user has agreed to, authorization confirmed, a budget, and the artifact identified by hash. Hand to `route.md`.
