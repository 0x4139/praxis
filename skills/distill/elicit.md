# Elicit

Requirements elicitation as a **design tree**: every decision branches into the decisions that hang off it. The goal is a shared understanding with nothing silently assumed — interrogate until the tree has no unvisited branches.

## Method: Frontier Rounds

The **frontier** is every decision whose prerequisites are already settled — the questions askable *now* without guessing at answers not yet heard. Work in rounds:

1. **Separate before questioning.** A messy dump is usually several ideas glued together. First play back the dump as a numbered list of distinct ideas/decisions you heard, recommend which one to distill first (highest value or most blocking), and confirm the split and the pick. One distill run handles one idea; park the rest explicitly.
2. **Ask the whole frontier in one round.** Number each question, give your recommended answer with each. A question whose answer depends on another question still open in this round belongs to a later round.
3. **Wait for answers.** Each round reshapes the tree: settled decisions push the frontier outward and unblock dependent questions. Recompute and ask the next round.
4. **Fetch facts yourself.** When a frontier question needs a fact from the environment (codebase, config, API docs), dispatch a subagent — never ask the user for something you can look up. A running lookup is an unsettled prerequisite: only its downstream questions wait; ask the rest of the frontier now.
5. **Stop when the frontier is empty.** Every branch visited, nothing assumed. Summarize the settled decisions as a numbered list — including the parked ideas, so they survive the conversation (offer to file them as minimal issues) — and get the user's confirmation of shared understanding.

## Targeted Round

When a later stage (specify, slice, triage) hits a genuinely unsettled decision, it runs a **targeted round**: one round, only the questions that block the calling stage, recommended answers as usual — then return to the caller. No frontier recomputation, no follow-up rounds, no re-interview. If the answers expose a hole too big for one round, say so and let the user decide whether to reopen full elicitation.

## Round Format

```
❓ **Q1 — <question title>**: <question body; may include multiple choices>

➡️ <your recommended answer>

---

❓ **Q2 — <question title>**: …

➡️ …
```

## Question Discipline

- Every question forces a decision — no "any other thoughts?" filler
- Recommend an answer for every question; the user should be able to accept a round in a few words
- Surface hidden scope: "you said X *and* Y — same feature or two?"
- Chase the unstated: actors, failure modes, out-of-scope boundaries, success criteria, verification seams (where will this be tested?)
- 3–6 questions per round; a 12-question wall stalls the user

## Exit

Close with the settled-decision summary and hand off: the decisions are the input to **specify** (`specify.md`). Do not start writing the spec in the same breath — confirm first.
