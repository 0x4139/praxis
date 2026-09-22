---
name: project-management
description: Manage the lifecycle of software work — write specifications, turn them into machine-readable implementation plans, and track execution as GitHub issues. Use when the user asks for a spec, requirements doc, or data contract; an implementation plan, plan file, or task breakdown; or to create/update GitHub issues, file a bug or feature request, break a feature into sub-issues, or manage labels, milestones, issue types, or blocked-by dependencies. Triggers on "write a spec", "plan this feature", "create an issue", "break this down", "track this work".
---

# Project Management

Software work moves through three artifacts: a **specification** pins down what must be true, an **implementation plan** turns it into deterministic executable tasks, and **GitHub issues** make the work trackable. Each artifact is self-contained — readable by an agent or human with no access to the conversation that produced it. Enter the lifecycle wherever the user is; don't force earlier stages that weren't asked for.

## Routing

Read only the file for the stage at hand:

| User wants | Read |
|------------|------|
| Spec, requirements doc, interface definition, data contract | `specification.md` |
| Implementation plan, plan file, phased task breakdown | `implementation-plan.md` |
| Create/update issues, bug report, feature request, epic + sub-issues, labels, milestones, dependencies | `issues.md` |

Each stage hands off to the next: a spec is executed via a plan; a plan's phases and tasks become issues (epic + sub-issues) when the user wants them tracked on GitHub.

## Shared Rules

- **Self-containment.** No artifact may rely on chat history, "as discussed", or "the current approach". A cold reader with the artifact and the repo can proceed.
- **Identifier discipline.** Structured identifiers (`REQ-001`, `TASK-001`, `AC-001`, …) are declared exactly once and referenced freely. Traceability runs spec → plan → issue.
- **No placeholders shipped.** Template brackets are filled or the section is deleted.
- **Ask, don't invent.** Missing requirements, repro steps, or acceptance criteria come from the user, not imagination.

## Related Skills

- `blueprint` — multi-session, multi-agent construction plans with per-step context briefs and adversarial review; use it instead of `implementation-plan.md` when work spans many sessions or agents.
- `api-design` — REST conventions for the interfaces a spec describes.
- `conventional-commits` — commit messages once execution starts.
