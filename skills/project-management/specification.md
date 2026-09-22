# Specification

A spec defines **what** must be true — requirements, constraints, interfaces, acceptance criteria — not how to build it. It is written to be executed against by people and AI agents who have no access to the conversation that produced it, so it must be precise, self-contained, and structured for parsing.

## When to Activate

- The user asks for a specification, requirements doc, data contract, or interface definition
- Requirements need to be agreed before an implementation plan or code
- Behavior must be unambiguous across teams, agents, or sessions

**Not this skill:** the build plan itself (`implementation-plan.md`), REST endpoint design conventions (the `api-design` skill), or architecture narratives for humans only.

## Output

- Location: `spec/` directory at the repo root (create it if missing)
- Name: `spec-[purpose]-[description].md` where purpose is one of `schema|tool|data|infrastructure|process|architecture|design` — e.g. `spec-data-user-events.md`
- Format: the template in `spec-template.md` — all sections filled or explicitly marked not applicable

## Writing Rules

- Precise, explicit, unambiguous language; no idioms, metaphors, or context-dependent references ("the current system", "as discussed")
- Distinguish requirements (**REQ-**, must), security requirements (**SEC-**), constraints (**CON-**, hard limits), guidelines (**GUD-**, should), and patterns (**PAT-**) — never blur them; the template carries the full prefix list
- Define every acronym and domain term in the Definitions section
- Structure content as headings, lists, and tables; schemas and payloads as code blocks
- Acceptance criteria are testable, Given/When/Then where it fits — "fast" is not a criterion; "p95 < 200ms at 100 RPS" is
- Include examples and edge cases: empty input, boundary values, failure modes
- Dependencies name capabilities, not packages: "OAuth 2.0 authorization code flow", not a library version — pin a version only when it is itself an architectural constraint
- Self-contained: a reader with only the spec and the repo can implement and verify it

## Workflow

1. **Scope first.** One component or capability per spec. State audience and assumptions in Purpose & Scope.
2. **Interview the gaps.** Missing constraint, undefined term, unmeasurable criterion — ask the user; never invent requirements.
3. **Fill the template** top to bottom, keeping identifier discipline: each `REQ-`/`CON-`/`AC-`/etc. declared once, referenced freely.
4. **Trace acceptance criteria to requirements.** A requirement no criterion verifies is untestable; a criterion tied to no requirement is scope creep.
5. **Hand off.** A spec is executed via `implementation-plan.md` and tracked as issues via `issues.md`.

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| "Should be fast/robust/scalable" | Numbers: latency, throughput, error budget |
| Requirements mixed with implementation choices | REQ says *what*; the plan says *how* |
| Terms the team "just knows" | Define them — an agent reading cold does not |
| Acceptance criteria that restate the requirement | Write the observable test that proves it |
| Pinning library versions as dependencies | Name the capability; pin only architectural constraints |
| Spec depends on chat history | Self-contained or it isn't done |
