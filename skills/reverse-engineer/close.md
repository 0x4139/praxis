# Close

The pass that makes the document trustworthy. leanrea states the evidence discipline and never checks it; nothing in that project validates that an answer carried labels. This stage is the check.

## 1. Enforce the Labels

Re-read `FINDINGS.md` against `evidence.md`, claim by claim. Reject and fix:

- **An unlabelled sentence.** Every claim is `Observed`, `Inferred` or `Unknown`. A sentence that asserts something with no label is a defect.
- **`Observed` with no locator.** The label is a promise that someone else can land where you did. No locator means it is an `Inferred`.
- **A cited name you generated.** A function label you or a tool invented is not a locator. Demote to the address, and move the name into the inference.
- **`Inferred` with no reasoning, or `high` with no alternative ruled out.** Confidence is an argument, not a feeling.
- **`Unknown` with no blocker.** Say what would resolve it, or it is just an omission.
- **A hedge.** "Probably", "seems to", "appears to", "should be" — each becomes a claim with a locator or an `Unknown`. No exceptions; hedges are unlabelled guesses.
- **An absence stated as a fact.** "Does not do X", "the versions are identical", "the feature was removed" — each needs the enumerated surface it rests on, or it becomes `Unknown`.
- **A static reading phrased as behavior.** "Sends the token" when you read a path that can send it. Rephrase as the path, or observe it.

## 2. Check the Gate

Two conditions, both required:

1. **Every fact-list item from `frame.md` is addressed** — with evidence, or with an `Unknown` carrying a blocker. An item silently missing is the one failure this pipeline must not produce.
2. **Coverage is stated**, including what was extracted but unexamined and what no instrument could reach.

Then stop. **Do not re-verify what you already saw.** An agent that re-reads settled facts for reassurance is spending the user's budget on its own comfort.

## 3. Report

Short, to the user, in the terminal:

- The path to `FINDINGS.md`.
- The answers to the fact list, one line each.
- The open questions, named — because those are what they will decide about next.
- What was not covered.

Lead with what they asked. The document holds the detail; the message holds the answer.

## 4. Hand Off

Name the next step rather than leaving it implicit:

- **`documentation`** — to turn settled understanding into committed codemaps in their own repo. This skill stays read-only on its target and writes only into its workspace; that agent owns in-repo docs.
- **`security-audit`** — where the question has turned from "what does this do" into "is this exploitable". The findings doc's map and boundaries seed its model stage directly.
- **`blueprint`** or **`distill`** — where the understanding is now the basis for building something.
- **Another run of this skill** — on a note from the findings doc, framed as its own fact list.

## A Clean Result

A run that answers every item and finds nothing surprising is a complete, valuable result. Say so plainly, keep the coverage section honest, and do not manufacture significance out of an ordinary artifact doing ordinary things.

And the line that belongs in any findings doc about an artifact you did not build: **this describes what was observed in this build, at this depth, with these instruments.** It is not a statement about what the software is capable of.
