---
name: conventional-commits
description: Conventional Commits specification for structured commit messages. Enforces type prefixes, scopes, breaking change notation, and SemVer correlation. Use when writing commit messages or reviewing commit history.
user-invocable: false
---

# Conventional Commits

Structured commit messages that enable automated changelogs and semantic versioning.

## When to Activate

- Writing any git commit message
- Reviewing commit history for consistency
- Setting up CI/CD that parses commits
- Deciding version bumps based on changes

## Commit Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Types

| Type | Purpose | SemVer |
|------|---------|--------|
| `feat` | New feature or capability | MINOR |
| `fix` | Bug fix | PATCH |
| `docs` | Documentation only | — |
| `style` | Formatting, whitespace, semicolons (no logic change) | — |
| `refactor` | Code change that neither fixes a bug nor adds a feature | — |
| `perf` | Performance improvement | — |
| `test` | Adding or updating tests | — |
| `build` | Build system or external dependencies | — |
| `ci` | CI configuration and scripts | — |
| `chore` | Maintenance tasks, tooling, config | — |

## Scope

Optional noun in parentheses describing the affected area:

```
feat(auth): add OAuth2 login flow
fix(api): handle empty response body
docs(readme): update installation steps
refactor(db): extract connection pooling
```

## Description

- Imperative mood: "add" not "added" or "adds"
- Lowercase first letter
- No period at end
- Keep under 72 characters

## Body

- Separated from description by a blank line
- Explain **what** and **why**, not how
- Free-form, can be multi-paragraph
- Wrap at 72 characters

## Footer

- Separated from body by a blank line
- Git trailer format: `Token: value` or `Token #value`
- Use hyphens in multi-word tokens (except `BREAKING CHANGE`)

```
Reviewed-by: Alice
Refs: #123
```

## Breaking Changes

Two ways to indicate a breaking change (MAJOR version bump):

```
# Option 1: ! after type/scope
feat(api)!: change authentication to OAuth2-only

# Option 2: BREAKING CHANGE footer
feat(api): change authentication to OAuth2-only

BREAKING CHANGE: basic auth is no longer supported, all clients must use OAuth2
```

Both can be combined. The `!` draws attention in `git log --oneline`.

## Examples

```
feat(markets): add cursor-based pagination to list endpoint

Replace offset pagination with cursor-based for consistent performance
on large datasets. Existing offset params still work but are deprecated.

Refs: #456
```

```
fix(auth): prevent token refresh race condition

Multiple concurrent requests could trigger parallel refresh calls,
causing token invalidation. Use mutex to serialize refresh.
```

```
chore: upgrade Go to 1.23
```

```
feat!: drop support for Node 18

BREAKING CHANGE: minimum Node version is now 20 LTS
```

```
docs(api-design): add rate limiting section
```

## Rules

1. Every commit MUST have a type prefix
2. Type MUST be followed by optional scope, optional `!`, then `: `
3. `feat` = MINOR, `fix` = PATCH, `BREAKING CHANGE` = MAJOR
4. Scope MUST be a noun in parentheses if present
5. Description MUST immediately follow the `: ` separator
6. Body MUST begin one blank line after description
7. Footers MUST begin one blank line after body
8. Breaking changes MUST be indicated by `!` and/or `BREAKING CHANGE:` footer
9. Commits without `feat` or `fix` types do not trigger version bumps

## Related Skills

- `go-standards` — Go naming and linting conventions
- `typescript-standards` — TypeScript naming and linting conventions