# Implementation Plan Template

Copy verbatim. All front matter fields present, section headers exact (case-sensitive), tables with all columns, no placeholder text in the final plan. Status badge colors: `Completed` brightgreen, `In progress` yellow, `Planned` blue, `Deprecated` red, `On Hold` orange. URL-encode spaces in the badge path (`In%20progress`, `On%20Hold`).

```md
---
goal: [Concise Title Describing the Implementation Plan's Goal]
version: [Optional: e.g., 1.0, Date]
date_created: [YYYY-MM-DD]
last_updated: [Optional: YYYY-MM-DD]
owner: [Optional: Team/Individual responsible for this plan]
status: 'Completed'|'In progress'|'Planned'|'Deprecated'|'On Hold'
tags: [Optional: e.g., `feature`, `upgrade`, `chore`, `architecture`, `migration`, `bug`]
---

# Introduction

![Status: <status>](https://img.shields.io/badge/status-<status>-<status_color>)

[A short concise introduction to the plan and the goal it is intended to achieve.]

## 1. Requirements & Constraints

- **REQ-001**: Requirement 1
- **SEC-001**: Security requirement 1
- **CON-001**: Constraint 1
- **GUD-001**: Guideline 1
- **PAT-001**: Pattern to follow 1

## 2. Implementation Steps

### Implementation Phase 1

- GOAL-001: [Goal of this phase, e.g., "Implement feature X", "Refactor module Y"]

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-001 | [Specific change: file path, function, exact values] | | |
| TASK-002 | ... | | |

### Implementation Phase 2

- GOAL-002: [Goal of this phase]

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-003 | ... | | |

## 3. Alternatives

- **ALT-001**: [Alternative approach considered and why it was not chosen]

## 4. Dependencies

- **DEP-001**: [Library, framework, or component the plan relies on]

## 5. Files

- **FILE-001**: [File affected and how]

## 6. Testing

- **TEST-001**: [Test to implement to verify the work]

## 7. Risks & Assumptions

- **RISK-001**: [Risk]
- **ASSUMPTION-001**: [Assumption]

## 8. Related Specifications / Further Reading

[Link to related spec]
[Link to relevant external documentation]
```

Mark a task done by filling its columns: `| TASK-001 | ... | ✅ | 2026-09-22 |`.
