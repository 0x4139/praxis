---
name: distill
description: Guided pipeline that turns a messy idea dump into executable, ordered work through four stages — elicit, specify, slice, triage. Use when the user has a raw brain dump, a pile of tangled ideas, or a vague feature wish and wants it refined into a spec and trackable issues; when they ask to stress-test a plan with questions; when a spec or conversation needs breaking into ordered tickets; or when existing issues need triage. Triggers on "distill", "brain dump", "break this down", "stress-test my idea", "turn this into tickets", "triage the backlog".
---

# Distill

Raw ideas become executable work through staged refinement, the way crude feed becomes product: **elicit → specify → slice → triage**. Each stage produces a durable artifact — settled decisions, a spec file, ordered issues, a labeled backlog — so the pipeline is resumable at any point and nothing lives only in chat. You are the still operator: announce the map, locate the user on it, run the stage, and hand them to the next one.

## The Pipeline

| Stage | Input | Output | File |
|-------|-------|--------|------|
| **Elicit** | Messy idea dump, vague plan | Every decision settled, nothing silently assumed | `elicit.md` |
| **Specify** | The elicitation conversation | A spec file — synthesis only, no re-interview | `specify.md` |
| **Slice** | A spec (or a clear enough conversation) | Vertical-slice tickets with blocking edges, grouped into milestones | `slice.md` |
| **Triage** | Existing issues | Each issue in exactly one state: ready-for-agent, ready-for-human, needs-info, wontfix | `triage.md` |

## Conducting

1. **Locate the user.** What exists already? A raw dump and open questions → elicit. Decisions settled in conversation → specify. A spec file or approved decisions → slice. Issues on the tracker → triage. Invoked bare, show the pipeline map and confirm the entry point; invoked with content, name the stage you're entering in one line and start it.
2. **Run one stage at a time.** Read only that stage's file (plus the files it explicitly references). Never run two stages in one breath — each stage ends with the user's confirmation of its artifact.
3. **Hand off explicitly.** Close every stage by naming the artifact produced and offering the next stage: "Spec written to `spec/…`. Next: slice it into tickets?"
4. **Respect entry points.** A user arriving with a finished spec doesn't need elicitation; a user asking only for triage gets only triage. Never force earlier stages — but if slicing exposes unsettled decisions, drop back to a short elicitation round rather than guessing.

## Shared Rules

- **Synthesis stages never re-interview.** Specify and slice work from what elicitation already settled; a question there means elicitation missed it — ask it as one targeted round, not a new interrogation.
- **Facts are yours, decisions are the user's.** Anything discoverable from the repo or tools, look up yourself (subagents welcome); anything that's a judgment call, put to the user with a recommended answer.
- **Artifacts over chat.** Decisions land in the spec; work lands in issues; states land in labels. If it only exists in the conversation, it isn't done.
- **Issue plumbing lives in `project-management`.** Publishing tickets, sub-issues, blocked-by edges, milestones, and labels all use the commands in the `project-management` skill (`../project-management/issues.md`, `../project-management/issues-advanced.md`) — don't improvise gh calls.

## Related Skills

- `project-management` — the artifact machinery this pipeline publishes through; also formal REQ-/AC- specs and implementation plans when contract-level rigor is needed.
- `ideation` — divergent option generation *before* distilling; distill converges, ideation diverges.
- `blueprint` — multi-session construction plans; use after slicing when execution spans many sessions.
