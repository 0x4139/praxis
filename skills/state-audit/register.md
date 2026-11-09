# Register

One file, at the repo root: `STATE-MACHINES.md`. Every machine the audit touched, decided or not, migrated or not. It is the artifact the audit exists to produce — the charts and ledgers are working papers, this is the thing that survives.

Write it whether or not anything was migrated.

## Shape

A census table first, so the file answers "what modes does this app have" without being read end to end:

```
| Machine | Layer | Location | Verdict | Tier | Violations | Status |
|---------|-------|----------|---------|------|-----------|--------|
| upload-pipeline | jobs | worker/upload.ts:40 | model | transition table | 2 reachable | migrated 2026-11-09 |
| subscription-status | db | schema/subs.sql:12 | model | guarded enum | 1 reachable (1,840 rows) | pending |
| auth-session | auth | lib/session.ts:22 | tolerate | - | 0 reachable | stable, revisit if touched |
| banner-dismissed | ui | Banner.tsx:8 | delete | - | - | not a machine: independent attribute |
```

Then one section per charted machine, in consequence order:

- **Where it lives** — the declaration and every write site, as `file:line`.
- **States** — named for modes, with what each is waiting for, terminal states marked.
- **Events** — including the ones that are not user actions: timeouts, failures, double submits, refreshes, restarts.
- **Transition table** — total, with `ILLEGAL` / `UNHANDLED` / `MISSING` markers intact. Keep the pre-migration table and mark what changed; a table showing only the fixed version destroys the evidence that the fix was needed.
- **Invariants** — the "never X" / "always Y" list.
- **Violations** — the ledger from `reach.md`, each with its path and its verdict. Keep the ones dropped as unreachable, with why.
- **Decision** — verdict, tier, reason, and the recorded trade if UX, DX, or AX lost.

Surveyed-not-charted candidates get one line each in a closing section, with location and smell codes. That list is the next audit's starting point, and it is why the next audit will not re-survey from nothing.

## Keep the evidence

The temptation is to write the register as a design document — clean tables, current state only. Don't. Strip the paths and counts and the register becomes unfalsifiable, which means the next person cannot tell a charted machine from an imagined one, and the whole discipline resets.

Specifically: keep the `file:line` paths, keep the row counts, keep the dropped violations, and keep the dates. "1,840 rows violated this invariant on 2026-11-09" is the sentence that makes the register trustworthy a year later.

## Wire it for agents

The register is only AX if it is found. Three lines of plumbing, and they are the cheapest part of the audit:

1. **A pointer in `AGENTS.md` or `CLAUDE.md`** — one directive sentence, not a description: *"Before changing any lifecycle, mode, or status field, read `STATE-MACHINES.md`. Machines listed there have transition tables; do not add a boolean flag beside one."* Directive, short, and placed where the agent already reads.
2. **A back-pointer from the code** — one comment at each modelled machine's transition function naming the register section. An agent arriving from a stack trace never sees the root of the repo.
3. **The exhaustive switch as the real enforcement.** Documentation drifts; a compile error does not. If adding a state to the union does not break every site that must change, the AX claim in the register is false — fix the switches, not the prose.

For a `model` verdict, also link the transition tests. "One reducer and its tests" is the entire AX case for this work: an agent reads two files and knows the rules, instead of reconstructing them from nine scattered writes and getting it subtly wrong.

## Close the audit

Report, in a few lines: candidates surveyed, machines charted, violations confirmed reachable versus dropped, verdicts by kind, what migrated. Then the honest remainder — what is pending, and the one thing you would do next.

If `decide.md` produced more `model` verdicts than one session carries, hand off to `blueprint` with the register as the context brief. Each machine is already a self-contained unit of work with its states, its table, its proven violations, and its tier — which is most of what a blueprint step needs.
