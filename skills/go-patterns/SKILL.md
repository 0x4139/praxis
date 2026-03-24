---
name: go-patterns
description: Idiomatic Go patterns, best practices, and conventions for building robust, efficient, and maintainable Go applications.
user-invocable: false
---

# Go Development Patterns

Idiomatic Go patterns and best practices for building robust, efficient, and maintainable applications.

## When to Activate

- Writing new Go code
- Reviewing Go code
- Refactoring existing Go code
- Designing Go packages/modules

## Core Principles

### 1. Simplicity and Clarity
Go favors simplicity over cleverness. Code should be obvious and easy to read. Write clear, direct functions — avoid nested closures and one-liner tricks.

### 2. Make the Zero Value Useful
Design types so their zero value is immediately usable without initialization. `sync.Mutex`, `bytes.Buffer`, and `int` all work at zero value. Avoid types that require `init()` or constructor calls to be safe.

### 3. Accept Interfaces, Return Structs
Functions should accept interface parameters (for flexibility) and return concrete types (for clarity). Define interfaces where they're consumed, not where they're implemented.

## Error Handling Patterns

- **Wrap with context**: `fmt.Errorf("load config %s: %w", path, err)`
- **Custom error types**: `ValidationError` with `Field` and `Message`
- **Sentinel errors**: `var ErrNotFound = errors.New("resource not found")`
- **Check with `errors.Is` and `errors.As`**: Never compare errors with `==`
- **Never ignore errors**: Handle or explicitly document why it's safe to ignore

## Concurrency Patterns

- **Worker Pool**: Fixed goroutine count consuming from a channel
- **Context for Cancellation**: `context.WithTimeout` for deadline propagation
- **Graceful Shutdown**: `signal.Notify` + `server.Shutdown(ctx)`
- **errgroup**: `golang.org/x/sync/errgroup` for coordinated goroutines with error collection
- **Avoid Goroutine Leaks**: Use buffered channels or `select` with `ctx.Done()` to prevent blocked sends

## Interface Design

- **Small interfaces**: Prefer single-method interfaces (`Reader`, `Writer`, `Closer`)
- **Compose interfaces**: `ReadWriteCloser` embeds `Reader`, `Writer`, `Closer`
- **Define at consumer**: The package that uses the interface defines it, not the implementor
- **Optional behavior**: Use type assertions for extended capabilities (`if f, ok := w.(Flusher); ok`)

## Package Organization

See `go-standards` for project structure, naming conventions, and linting configuration.

## Struct Design

- **Functional Options**: `NewServer(addr, WithTimeout(60*time.Second), WithLogger(l))`
- **Embedding for Composition**: Embed types to promote methods without delegation boilerplate

## Memory and Performance

- **Preallocate slices**: `make([]T, 0, len(items))` when size is known
- **sync.Pool**: Reuse frequently allocated objects (buffers)
- **strings.Builder**: For string concatenation in loops (or `strings.Join`)

## Quick Reference

| Idiom | Description |
|-------|-------------|
| Accept interfaces, return structs | Flexible input, concrete output |
| Errors are values | First-class values, not exceptions |
| Don't communicate by sharing memory | Use channels for coordination |
| Make the zero value useful | No init required |
| A little copying > a little dependency | Avoid unnecessary deps |
| Clear is better than clever | Readability first |
| Return early | Handle errors first, keep happy path unindented |

For anti-patterns, see `go-standards`. For full code examples, see `examples.md`.

## Related Skills

- `go-standards` — Naming, formatting, linting, anti-patterns
- `go-testing` — Testing patterns and TDD
- `go-backend` — HTTP handlers, middleware, service layer