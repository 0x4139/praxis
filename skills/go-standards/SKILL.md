---
name: go-standards
description: Go coding conventions covering naming, formatting, project structure, and linting configuration. Use as reference when writing or reviewing Go code.
user-invocable: false
---

# Go Coding Standards

Naming conventions, formatting rules, and linting configuration for Go projects.

## When to Activate

- Writing or reviewing Go code
- Setting up a new Go project
- Configuring linters and formatters
- Enforcing naming or structural consistency

## Naming Conventions

### Packages
- Short, lowercase, single-word names: `http`, `json`, `user`
- No underscores, no mixedCaps
- Avoid stuttering: `http.Server` not `http.HTTPServer`

### Exported vs Unexported
- Exported: `PascalCase` — `GetUser`, `Config`, `ErrNotFound`
- Unexported: `camelCase` — `parseInput`, `defaultTimeout`
- Acronyms stay uppercase: `HTTPClient`, `ID`, `URL`

### Variables
- Short names in small scopes: `i`, `n`, `err`, `ctx`
- Descriptive names in larger scopes: `userCount`, `requestTimeout`
- Receivers: one or two letter abbreviation of type: `func (s *Server)`, `func (c *Client)`

### Interfaces
- Single-method interfaces: name by method + "er": `Reader`, `Writer`, `Closer`
- Avoid "I" prefix: `Reader` not `IReader`

### Errors
- Sentinel errors: `Err` prefix with `PascalCase`: `ErrNotFound`, `ErrUnauthorized`
- Error types: descriptive name ending in `Error`: `ValidationError`, `TimeoutError`
- Error messages: lowercase, no punctuation: `fmt.Errorf("get user %s: %w", id, err)`

### Files
- Lowercase with underscores: `user_handler.go`, `market_service.go`
- Test files: `_test.go` suffix: `user_handler_test.go`
- Platform-specific: `file_linux.go`, `file_windows.go`

## Formatting

- `gofmt` is mandatory — no exceptions
- `goimports` for import grouping: stdlib, external, internal
- Import groups separated by blank lines:
  ```go
  import (
      "context"
      "fmt"

      "github.com/lib/pq"
      "golang.org/x/sync/errgroup"

      "myproject/internal/service"
  )
  ```
- No trailing commas omitted in multi-line composite literals (Go requires them)

## Project Structure

```text
cmd/           # Entry points (main packages)
internal/      # Private application code
pkg/           # Public library code (use sparingly)
api/           # API definitions (proto, OpenAPI)
testdata/      # Test fixtures
```

- Prefer `internal/` over `pkg/` — most code should be private
- Group by domain, not by layer: `internal/user/` over `internal/handlers/`
- One `main.go` per binary in `cmd/<binary-name>/`

## Code Organization

- One type per file when the type has methods
- Group related functions in the same file
- Keep files under 500 lines — split if larger
- `doc.go` for package-level documentation

## Linting Configuration

### Recommended `.golangci.yml`

```yaml
linters:
  enable:
    - errcheck
    - gosimple
    - govet
    - ineffassign
    - staticcheck
    - unused
    - gofmt
    - goimports
    - misspell
    - unconvert
    - unparam

linters-settings:
  errcheck:
    check-type-assertions: true
  govet:
    enable-all: true

issues:
  exclude-use-default: false
```

### Essential Commands

```bash
gofmt -w .
goimports -w .
go vet ./...
golangci-lint run
```

## Anti-Patterns

- Package-level mutable state (`var db *sql.DB` with `init()`)
- Naked returns in functions longer than a few lines
- Using `panic` for control flow
- Passing `context.Context` in structs (always first parameter)
- Mixing value and pointer receivers on the same type
- `interface{}` / `any` when a specific type or interface would work
- Import dot (`. "pkg"`) outside tests
- `log.Fatal` / `log.Panic` outside `main` (suppresses deferred cleanup)
- `init()` for side effects beyond simple validation

## Related Skills

- `go-patterns` — Language patterns and idioms
- `go-testing` — Testing patterns
- `go-backend` — Backend architecture patterns

## Quick Reference

| Topic | Convention |
|-------|-----------|
| Package names | `lowercase`, no underscores |
| Exported names | `PascalCase` |
| Unexported names | `camelCase` |
| Acronyms | Stay uppercase in PascalCase: `HTTPClient`, `ID` |
| Error variables | `ErrSomething` |
| Error types | `SomethingError` |
| Receivers | 1-2 letter type abbreviation |
| File names | `snake_case.go` |
| Formatting | `gofmt` mandatory |
| Imports | stdlib / external / internal groups |