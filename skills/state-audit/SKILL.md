---
name: state-audit
description: Find the state machines hiding in an app — the modes and transitions that exist in the code without ever being named — prove which invalid states are actually reachable, decide what to do about each, and migrate without breaking behavior. Six stages: survey, chart, reach, decide, migrate, register. Use when boolean flags contradict each other, when a user gets stuck with no timeout or retry, when a status column has no rules about which transitions are legal, when a spinner never resolves, or when adding one mode means editing conditionals in a dozen files. Triggers on "implicit state machines", "find the state machines", "state machine audit", "boolean flags", "flag soup", "impossible states", "invalid state", "isLoading isError", "make this explicit", "status column", "stuck in loading", "stuck in this state", "can't get out of".
---

# State Audit

Every app has state machines. The question is only whether they are written down. The ones that aren't — modes reconstructed from boolean flags, transitions smeared across `if` conditions in files that never mention each other — are real, load-bearing, and unowned.

Finding them is the easy half and the dangerous half. A fluent model of a machine that cannot actually enter the state you drew is worse than no model: it buys a refactor with no bug behind it. Two rules carry this skill:

- **A violation you cannot reach is not a finding.** Every invalid state and illegal transition you report carries a concrete path through the code that arrives there — the call, the branch, the write. Default to unreachable. "The type permits it" is a DX observation, not a reachable violation.
- **Separate the representation change from the behavior change.** Renaming three booleans into one union is free and must leave every test green. Closing a state the app *actually reaches* changes what the app does there, and needs the user's sign-off. One commit never does both.

## The Pipeline

| Stage | Input | Output | File |
|-------|-------|--------|------|
| **Survey** | The app, or a named surface | A candidate list — one line each, scored by smell, nothing charted yet | `survey.md` |
| **Chart** | The candidates worth the cost | States, events, transition table, invariants — per machine | `chart.md` |
| **Reach** | A charted machine | Each violation marked reachable with a path, or unreachable | `reach.md` |
| **Decide** | Charted and reached machines | One verdict each — model, tolerate, or delete — with its reason | `decide.md` |
| **Migrate** | A machine verdicted `model` | The change landed, behavior split declared, tests pinned first | `migrate.md` |
| **Register** | Everything settled | `STATE-MACHINES.md`, and the pointer that makes agents find it | `register.md` |

Reference layer: `layers.md` (where machines hide, layer by layer, and what to grep), `smells.md` (the five tells and the symptom-to-machine map), `verdicts.md` (the UX/DX/AX rubric, the tiebreak, and the tool ladder).

**Survey is cheap, charting is expensive.** A real app surveys into dozens of candidates — one report on a mid-size codebase found 212 across ten layers. Charting all of them is weeks of work producing a document nobody reads. The funnel is mandatory: survey wide, chart few, migrate fewer.

## Conducting

1. **Read only the stage you are in,** plus the reference files it names. Never run two stages in one breath; each ends with the user confirming its artifact.
2. **Default to read-only.** Survey through decide touch nothing. `migrate` runs only when the user asks for it, one machine at a time.
3. **Never skip `reach`.** It is the stage that separates this skill from the prompt it came from. A chart with unverified violations goes to the user labelled as such or not at all.
4. **Stop early and often.** If survey finds one candidate that explains the bug the user is actually chasing, chart that one and go to register. Completeness is not the goal.
5. **Three verdicts, not one.** `delete` is the verdict every state-machine finder forgets — sometimes the state should not exist, because it is derivable, or because the two flags were independent attributes and never a machine at all.

## Elevating Three Things At Once

UX, DX, and AX usually move together here, which is why this audit is worth doing. They do not *always* move together, and a skill that claims they do will quietly sacrifice one.

- **UX** is the missing transitions. A machine with no timeout, no retry, no cancel, and no recovery edge is a dead end a user sits in. This is the only one of the three where a defect harms someone who cannot route around it.
- **DX** is whether the illegal combination can be typed at all, and whether transition logic lives in one place.
- **AX** is whether an agent can read the machine from one file instead of reconstructing it from scattered writes, and whether adding a state makes the compiler enumerate every site that must change.

When they conflict, **UX wins, then DX, then AX** — and `decide` records the trade in writing rather than pretending there wasn't one.

## Rationalizations to Reject

| Thought | Reality |
|---------|---------|
| "Three booleans means eight states, five of them invalid." | That is arithmetic, not a finding. Which of the five does code actually write? Show the line. Unreachable combinations are a DX note at most. |
| "I found 47 implicit state machines." | You found 47 candidates. A candidate becomes a machine when it has named states and a transition table, and most won't survive charting. |
| "Collapse the flags into one status enum." | Only if the concerns are mutually exclusive. Orthogonal concerns in a flat enum is the 2^N explosion statecharts were invented to fix. Split into parallel machines. |
| "Every boolean is a smell." | `isGrounded` is a physics fact. `isAdmin` is an attribute. A flag is a machine only when it has rules about what may follow what. |
| "The refactor preserves behavior." | Not if the invalid state was reachable. There you are *changing* behavior, and that is the point — declare it, don't bury it in a refactor commit. |
| "Tests pass, so nothing broke." | Characterization tests pin current behavior warts and all. If a test still passes after you closed a reachable bad state, the test never covered it. |
| "The machine is obvious from the code." | Then write it down in four lines and move on. If writing it down is hard, it was not obvious. |
| "This one is working fine, but it should be explicit." | `tolerate` is a legitimate verdict. Formalizing a stable machine nobody is editing spends risk to buy tidiness. |

## Related Skills

- `debug` — when there is one specific symptom to chase. Run that first; a state audit is the follow-up when the cause turns out to be an unowned mode.
- `typescript-standards` / `go-patterns` — the language-level encoding of a decided machine: discriminated unions, exhaustive switches, `as const`.
- `database-migrations` — when the machine is a persisted status column and the verdict requires a schema change.
- `security-audit` — its Logic and State class is the adversarial read of the same surface: not "can a user get stuck" but "can a dishonest user profit".
- `blueprint` — when `decide` produces more `model` verdicts than one session can carry.
