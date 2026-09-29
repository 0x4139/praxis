# Specify

Turn the elicitation conversation into a spec. **Synthesis only — do not interview again.** Everything the spec needs was settled during elicitation; if something is genuinely missing, ask it as a **targeted round** (see `elicit.md` § Targeted Round — one round, no frontier recomputation) and return here.

## Process

1. **Ground in the repo.** If the codebase hasn't been explored yet, do it now — the spec should use the project's existing vocabulary and respect its architectural decisions.
2. **Sketch the test seams.** Where will this feature be verified? Prefer existing seams; propose new ones at the highest point possible — the fewer seams, the better. Confirm the seams with the user before writing.
3. **Write the spec** using the template below, to `spec/spec-[purpose]-[description].md` (same convention as the `project-management` skill).
4. **Confirm and hand off.** Show the user the spec, apply their edits, then offer the next stage: slice it into tickets (`slice.md`).

When the work needs contract-level rigor — formal REQ-/AC- identifiers, interface schemas, compliance traceability — use the `project-management` skill's `specification.md` and its template instead; this template optimizes for speed from conversation to tickets.

## Spec Template

```md
---
title: [Feature name]
date_created: [YYYY-MM-DD]
status: draft
---

## Problem Statement

[The problem, from the user's perspective.]

## Solution

[The solution, from the user's perspective.]

## User Stories

[A thorough numbered list; cover all aspects of the feature.]

1. As a <actor>, I want <capability>, so that <benefit>

## Implementation Decisions

[Decisions settled during elicitation: modules built/modified, interfaces, architecture,
schema changes, API contracts, specific interactions. No file paths or code snippets —
they go stale fast. Exception: a snippet that encodes a decision more precisely than
prose (state machine, schema, type shape) may be inlined, trimmed to the decision-rich part.]

## Testing Decisions

[What makes a good test here (external behavior, not implementation details), which seams
are tested, prior art for similar tests in the codebase.]

## Out of Scope

[What this spec explicitly does not cover — the parked ideas from elicitation land here.]

## Further Notes

[Anything else that matters.]
```

## Rules

- Every Implementation Decision must trace to something the user actually said or confirmed — a decision that appears from nowhere is an elicitation gap, not creative license
- The Out of Scope section is mandatory; an empty one means the boundary was never drawn
- The spec is self-contained: a reader with only this file and the repo can slice and implement it
