# Specification Template

Copy verbatim; fill every section or mark it explicitly not applicable. No placeholder text may remain.

````md
---
title: [Concise Title Describing the Specification's Focus]
version: [Optional: e.g., 1.0, Date]
date_created: [YYYY-MM-DD]
last_updated: [Optional: YYYY-MM-DD]
owner: [Optional: Team/Individual responsible for this spec]
tags: [Optional: e.g., `infrastructure`, `process`, `design`, `app`]
---

# Introduction

[Short, concise introduction to the specification and the goal it achieves.]

## 1. Purpose & Scope

[Purpose and scope of application. Intended audience and assumptions.]

## 2. Definitions

[Every acronym, abbreviation, and domain-specific term used in this spec.]

## 3. Requirements, Constraints & Guidelines

- **REQ-001**: Requirement 1
- **SEC-001**: Security requirement 1
- **CON-001**: Constraint 1
- **GUD-001**: Guideline 1
- **PAT-001**: Pattern to follow 1

## 4. Interfaces & Data Contracts

[APIs, data contracts, integration points. Schemas and examples as code blocks or tables.]

## 5. Acceptance Criteria

- **AC-001**: Given [context], When [action], Then [expected outcome]
- **AC-002**: The system shall [specific behavior] when [condition]

## 6. Test Automation Strategy

- **Test Levels**: Unit, Integration, End-to-End
- **Frameworks**: [repo's stack — e.g., `go test` + testify for Go; Vitest or `bun test` for TypeScript]
- **Test Data Management**: [creation and cleanup approach]
- **CI/CD Integration**: [where automated tests run, e.g., GitHub Actions]
- **Coverage Requirements**: [minimum thresholds, if any]
- **Performance Testing**: [load/performance approach, if applicable]

## 7. Rationale & Context

[Reasoning behind the requirements, constraints, and guidelines; context for design decisions.]

## 8. Dependencies & External Integrations

[What is needed architecturally, not how it's packaged. Name capabilities ("OAuth 2.0 authorization code flow"), not library versions, unless the version is itself a constraint. Include only the categories that apply.]

### External Systems
- **EXT-001**: [System] — [purpose and integration type]

### Third-Party Services
- **SVC-001**: [Service] — [required capabilities and SLA]

### Infrastructure Dependencies
- **INF-001**: [Component] — [requirements and constraints]

### Data Dependencies
- **DAT-001**: [Source] — [format, frequency, access]

### Technology Platform Dependencies
- **PLT-001**: [Platform/runtime] — [version constraints and rationale]

### Compliance Dependencies
- **COM-001**: [Regulation/standard] — [impact on implementation]

## 9. Examples & Edge Cases

```code
// Example demonstrating correct application of the requirements,
// including boundary values, empty input, and failure modes
```

## 10. Validation Criteria

[Whole-spec compliance gate: checks that verify the implemented solution conforms to this spec as a whole — distinct from §5's per-requirement acceptance criteria.]

## 11. Related Specifications / Further Reading

[Link to related spec]
[Link to relevant external documentation]
````
