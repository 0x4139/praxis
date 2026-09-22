# Issue Body Templates

Pick by request type, fill every bracket, delete sections that don't apply.

| User request sounds like | Template |
|--------------------------|----------|
| Bug, error, broken, crash, not working | Bug Report |
| Feature, enhancement, add, support for | Feature Request |
| Task, chore, refactor, upgrade, migrate | Task |
| Big feature, initiative, multi-issue work | Epic |
| Quick note, small fix | Minimal |

## Bug Report

```markdown
## Description
[Clear description of the bug]

## Steps to Reproduce
1. [First step]
2. [Second step]
3. [And so on...]

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Environment
- Browser: [e.g., Chrome 120]
- OS: [e.g., macOS 14.0]
- Version: [e.g., v1.2.3]

## Screenshots/Logs
[If applicable]

## Additional Context
[Any other relevant information]
```

## Feature Request

```markdown
## Summary
[One-line description of the feature]

## Motivation
[Why is this feature needed? What problem does it solve?]

## Proposed Solution
[How should this feature work?]

## Acceptance Criteria
- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

## Alternatives Considered
[Other approaches considered and why they weren't chosen]

## Additional Context
[Mockups, examples, or related issues]
```

## Task

```markdown
## Objective
[What needs to be accomplished]

## Details
[Detailed description of the work]

## Checklist
- [ ] [Subtask 1]
- [ ] [Subtask 2]
- [ ] [Subtask 3]

## Dependencies
[Any blockers or related work]

## Notes
[Additional context or considerations]
```

## Epic

Parent issue for work that spans multiple sub-issues.

```markdown
## Outcome
[What is true when this epic is done — user-visible result, not a task list]

## Why Now
[The problem or opportunity driving this work]

## Scope
- [Included area 1]
- [Included area 2]

## Out of Scope
- [Explicitly excluded, to stop scope creep]

## Breakdown
Formal sub-issues track progress; this list is the map. Plain-text titles only — `#N` task-list checkboxes would double-track linked sub-issues:
- [Sub-issue title 1]
- [Sub-issue title 2]

## Risks / Open Questions
[Anything that could change the plan]
```

## Minimal

For simple issues:

```markdown
## Description
[What and why]

## Tasks
- [ ] [Task 1]
- [ ] [Task 2]
```
