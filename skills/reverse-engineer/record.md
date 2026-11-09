# Record

Write `FINDINGS.md` into the workspace. This is the stage leanrea and most RE tooling skip entirely — they answer in chat and the understanding evaporates. The document is the deliverable, because the next person to ask this question should not have to re-derive it.

Load `evidence.md` before writing. Every claim gets a label and a locator; that is not a style preference, and `close.md` checks it.

## Shape

```md
# <artifact name> — findings

**Artifact.** `<path>`, <size>, `sha256:<hash>`
**Identified as.** <format>, on <what basis>
**Question.** <the numbered fact list from frame>
**Instruments used.** <what was actually available and used>
**Date.** <when>

## Answers
## Map
## Open questions
## Coverage
## Notes
```

## Answers

One subsection per fact-list item, in the order they were asked, each carrying its label and locator.

```md
### 1. What does it talk to over the network?

**Observed.** `https://api.example.com/v2/` — string at `MacOS/App:0x1f8a20`.
**Observed.** `https://telemetry.example.net/ingest` — string at `MacOS/App:0x1f8c40`.
**Observed.** Links `libcurl.4.dylib` — `otool -L`.
**Inferred (high).** Both hosts are contacted over HTTPS. Both strings are passed to a
function that calls `curl_easy_setopt` at `0x1000b120`; no plain-HTTP path found.
**Unknown.** Whether telemetry can be disabled. No preference key for it was found in
`Info.plist` or the defaults domain, and the app was not run.
```

An item answered in one line gets one line. An item whose honest answer is `Unknown` gets the `Unknown` and its blocker — never a plausible guess dressed as a finding.

## Map

Structure the reader needs in order to use the answers: the components, the boundaries between them, and what crosses each. Short, and only what was actually established.

This is where the four questions from `inventory.md` land — ways in, who is on the other side, state that persists, and calls you could not see inside. That last one is load-bearing: a map that does not mark its own opaque regions reads as complete when it is not.

## Open Questions

Everything you could not settle, each with what would settle it.

**Finishing with open questions is a complete analysis. Finishing with open questions you never wrote down is not.** This section is the difference between handing someone a map and handing them a map with the unexplored parts quietly trimmed off.

## Coverage

What you examined, and what you did not.

- Files or regions read, and at what rung of the cost ladder.
- What was extracted but not examined.
- What an instrument could not reach — bytecode that will not decompile, functions the decompiler returned empty, an architecture slice not analyzed.
- Whether the artifact was run.

Without this, a reader cannot tell a clean region from an unread one, and every negative statement in the document becomes unreadable.

## Notes

Things noticed that were outside the fact list. One line each, undeveloped. The user decides whether any of them becomes the next run's question — the alternative is scope creep wearing the costume of thoroughness.

## Exit

`FINDINGS.md` written. Hand to `close.md` for the review that enforces what this stage promised.
