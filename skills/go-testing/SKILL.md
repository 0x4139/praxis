---
name: go-testing
description: Go testing patterns including table-driven tests, subtests, benchmarks, fuzzing, and test coverage. Follows TDD methodology with idiomatic Go practices.
user-invocable: false
---

# Go Testing Patterns

Go testing patterns for writing reliable, maintainable tests following TDD methodology.

## When to Activate

- Writing new Go functions or methods
- Adding test coverage to existing code
- Creating benchmarks for performance-critical code
- Implementing fuzz tests for input validation

## TDD Workflow

```
RED     → Write a failing test first
GREEN   → Write minimal code to pass the test
REFACTOR → Improve code while keeping tests green
REPEAT  → Continue with next requirement
```

## Table-Driven Tests

The standard pattern for Go tests. Define test cases as a slice of structs, iterate with `t.Run`:

- Each case gets a `name` field for clear subtest output
- Include both success and error cases in the same table
- Use `wantErr bool` for error path testing

## Subtests and Parallel Tests

- **Subtests** (`t.Run`): Group related tests sharing setup
- **Parallel** (`t.Parallel()`): Run independent subtests concurrently
- Capture loop variables with `tt := tt` before `t.Run`

## Test Helpers

- `t.Helper()` — marks function as helper, fixes line reporting
- `t.Cleanup(func())` — register cleanup that runs when test finishes
- `t.TempDir()` — auto-cleaned temporary directory
- Generic helpers: `assertEqual[T comparable](t, got, want)`

## Golden Files

Store expected output in `testdata/*.golden`. Use `-update` flag to regenerate:
```go
var update = flag.Bool("update", false, "update golden files")
```

## Interface-Based Mocking

Define interfaces for dependencies, create mock implementations with function fields:
```go
type MockUserRepo struct {
    GetUserFunc func(id string) (*User, error)
}
func (m *MockUserRepo) GetUser(id string) (*User, error) {
    return m.GetUserFunc(id)
}
```

## Benchmarks

- `b.ResetTimer()` after setup to exclude setup time
- `b.Run` for sub-benchmarks with different sizes
- `-benchmem` flag for allocation tracking
- Compare implementations (concat vs builder vs join)

## Fuzzing (Go 1.18+)

- `f.Add(...)` for seed corpus
- `f.Fuzz(func(t *testing.T, input string) { ... })` for property testing
- Run: `go test -fuzz=FuzzName -fuzztime=30s`

## Test Coverage

```bash
go test -cover ./...                    # Basic coverage
go test -coverprofile=coverage.out ./...  # Profile
go tool cover -html=coverage.out        # Browser view
go tool cover -func=coverage.out        # Per-function
```

| Code Type | Target |
|-----------|--------|
| Critical business logic | 100% |
| Public APIs | 90%+ |
| General code | 80%+ |
| Generated code | Exclude |

## HTTP Handler Testing

Use `httptest.NewRequest` and `httptest.NewRecorder` for handler tests. Table-driven pattern works well with `method`, `path`, `body`, `wantStatus`, `wantBody` fields.

## Testing Commands

```bash
go test ./...                      # All tests
go test -v ./...                   # Verbose
go test -run TestAdd ./...         # Specific test
go test -run "TestUser/Create"     # Specific subtest
go test -race ./...                # Race detector
go test -short ./...               # Short tests only
go test -timeout 30s ./...         # With timeout
go test -bench=. -benchmem ./...   # Benchmarks
go test -count=10 ./...            # Flaky detection
```

## Best Practices

**DO:**
- Write tests FIRST (TDD)
- Use table-driven tests
- Test behavior, not implementation
- Use `t.Helper()` in helpers
- Use `t.Parallel()` for independent tests
- Clean up with `t.Cleanup()`

**DON'T:**
- Test private functions directly
- Use `time.Sleep()` in tests
- Ignore flaky tests
- Mock everything (prefer integration tests)
- Skip error path testing

## CI/CD Integration

```yaml
- name: Run tests
  run: go test -race -coverprofile=coverage.out ./...
- name: Check coverage
  run: |
    go tool cover -func=coverage.out | grep total | awk '{print $3}' | \
    awk -F'%' '{if ($1 < 80) exit 1}'
```

For full code examples, see `examples.md`.

## Related Skills

- `go-patterns` — Language patterns and idioms
- `go-standards` — Naming, formatting, linting
- `go-backend` — Backend architecture patterns