# Verdicts

The rubric behind `decide.md`: how to score the three experiences, how to break the tie, which tier to build at, and when the right answer is to leave the machine alone.

## Scoring UX, DX, AX

Concrete questions only. A score with no named consequence is a feeling with a number attached.

**UX — what the user experiences in the reachable bad states.**

- Can a user arrive somewhere with no edge out? Name the state.
- Does a failure surface, or does the UI sit in a state that looks like progress?
- Can work be lost — a form reset, a draft dropped, a submission that may or may not have landed?
- Can the user tell which state they are in? Two states that render identically are one state to them, and that may be the bug.
- Can they be charged, emailed, or committed to something twice?

"No reachable violations" is a legitimate and common answer. Write it rather than inventing a UX cost to justify the work.

**DX — what it costs to change this code.**

- How many sites must change to add one mode? Count them.
- Is the illegal combination currently typable? (A DX cost, never by itself a reachable violation.)
- Is there one place that decides transitions, or several that must agree?
- Does the last person to touch this have to re-derive the rules from the writes?

**AX — what an agent can know without guessing.**

- How many files must it read to learn the rules? One reducer and its tests is the target.
- Does adding a state produce a compile error at every site that must change, or a silent fallthrough? This is the only AX property that enforces itself.
- Are the states named for modes, or for flag values? `notLoadingNotDone` tells an agent nothing and invites it to invent.
- Is there a pointer from the code and from `AGENTS.md` to where the rules live?

## The tiebreak

Usually all three rise together, which is why this audit is worth running. When they conflict: **UX > DX > AX.**

A user in a dead end cannot route around it. A developer can read more files. An agent can be handed a pointer. The ordering is about who is stuck, not about who matters.

Record the loss in one sentence when it happens. A verdict claiming all three rose in a case where one fell is the failure mode this ordering exists to prevent — and the honest trades are small: a machine kept flat and slightly verbose because splitting it would confuse the UI copy; an extra intermediate state that costs a developer a branch and saves a user a lost form.

## The tool ladder

A `model` verdict names the lowest tier that holds the invariants. "Use a state machine" is not a decision — tier 2 and tier 6 are both state machines and differ by three orders of magnitude in cost.

```
1  One boolean              Two genuinely exclusive modes, no illegal transitions, no guards.
                            Leave it. A state machine here is a crane lifting a coffee cup.

2  Union + exhaustive       3-5 states, transitions obvious at the call site, no entry
   switch                   actions. The highest-value tier in this skill: nearly free,
                            and the compiler enumerates what a new state breaks.

3  Reducer / transition      Transitions need guards, or several callers must agree. One
   function                 function owns every edge; callers request, never assign.

4  Explicit transition      Illegal edges must be rejected loudly rather than ignored.
   table                    Persisted status, entry actions, a history row per transition.
                            Guard every write with compare-and-set on the expected state.

5  Statechart library       Orthogonal regions, nested states, history, timers as
                            first-class events. Reach for it when a hand-rolled table has
                            started to multiply rows for concerns that are independent.

6  Durable execution        The machine outlives the process and must survive restarts and
   engine                   deploys. Payments, multi-day onboarding, long-running jobs.
```

Name the tier above the one you chose and say in one clause why it is not needed. That sentence is what stops the refactor growing during `migrate.md`.

## Orthogonal, never flat

Before any tier above 1, check whether the candidate is one machine or several. Two concerns are orthogonal when every state of one can coexist with every state of the other.

Flattening N independent two-state concerns into one enum needs 2^N states and a transition count that grows worse. Harel invented orthogonal regions in 1987 for exactly this, and a flat enum over orthogonal concerns is a downgrade from the flags it replaced — it makes the audit look wrong to everyone who reviews it.

Split them. "This is three machines, not one" is one of the most valuable outputs of a chart.

## When to leave it implicit

`tolerate` is a real verdict, and these are its grounds:

- **Zero reachable violations.** The code already guards what the types don't. Record the suspicion and the guards; spend the risk elsewhere.
- **Stable and untouched.** No churn in a year, no bugs filed. Formalizing it spends regression risk to buy tidiness.
- **Not actually modes.** Independent attributes, physics facts, permissions. `isGrounded` is a fact about the world; `isAdmin` has no transition rules. A plain record is correct.
- **Owned elsewhere.** A query library, the framework, or the upstream service already owns this machine. Shadowing it is the defect; adding a second formal machine makes two sources of truth.
- **The boundary is honest.** An event producer that assumes nothing about what happens next — an input handler at an isolated I/O edge — is not an implicit machine. It is a message.

A register of nine tolerated machines with reasons is a genuinely useful document. It tells the next audit what was already examined, and it is the difference between a practice and a one-off refactor.
