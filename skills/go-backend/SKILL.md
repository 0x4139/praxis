---
name: go-backend
description: Go backend patterns for HTTP handlers, middleware, service layers, database access, and error handling with PostgreSQL. Use as reference when building Go APIs.
user-invocable: false
---

# Go Backend Patterns

Backend architecture patterns for Go services with PostgreSQL.

## When to Activate

- Writing HTTP handlers in Go
- Implementing middleware (auth, logging, rate limiting)
- Designing service and repository layers
- Working with PostgreSQL from Go (pgx, sqlc, database/sql)
- Structuring error handling for APIs
- Validating request input

## HTTP Handler Patterns

### Standard Handler Signature

```go
func (s *Server) handleCreateMarket(w http.ResponseWriter, r *http.Request) {
    var req CreateMarketRequest
    if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
        s.respondError(w, http.StatusBadRequest, "invalid request body")
        return
    }

    market, err := s.marketService.Create(r.Context(), req)
    if err != nil {
        s.handleServiceError(w, err)
        return
    }

    s.respondJSON(w, http.StatusCreated, market)
}
```

### Response Helpers

```go
func (s *Server) respondJSON(w http.ResponseWriter, status int, data any) {
    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(status)
    json.NewEncoder(w).Encode(data)
}

func (s *Server) respondError(w http.ResponseWriter, status int, message string) {
    s.respondJSON(w, status, map[string]string{"error": message})
}
```

### Router Setup (Go 1.22+ stdlib)

```go
mux := http.NewServeMux()
mux.HandleFunc("GET /api/markets", s.handleListMarkets)
mux.HandleFunc("GET /api/markets/{id}", s.handleGetMarket)
mux.HandleFunc("POST /api/markets", s.handleCreateMarket)
mux.HandleFunc("PUT /api/markets/{id}", s.handleUpdateMarket)
mux.HandleFunc("DELETE /api/markets/{id}", s.handleDeleteMarket)
```

## Middleware Patterns

### Middleware Signature

```go
type Middleware func(http.Handler) http.Handler

func LoggingMiddleware(logger *slog.Logger) Middleware {
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            start := time.Now()
            next.ServeHTTP(w, r)
            logger.Info("request",
                "method", r.Method,
                "path", r.URL.Path,
                "duration", time.Since(start),
            )
        })
    }
}
```

### Middleware Chain

```go
func Chain(middlewares ...Middleware) Middleware {
    return func(final http.Handler) http.Handler {
        for i := len(middlewares) - 1; i >= 0; i-- {
            final = middlewares[i](final)
        }
        return final
    }
}

handler := Chain(
    LoggingMiddleware(logger),
    RecoveryMiddleware(),
    AuthMiddleware(tokenVerifier),
)(mux)
```

## Service Layer

```go
type MarketService interface {
    List(ctx context.Context, filters MarketFilters) ([]Market, error)
    Get(ctx context.Context, id int64) (*Market, error)
    Create(ctx context.Context, req CreateMarketRequest) (*Market, error)
}

type marketService struct {
    repo   MarketRepository
    cache  Cache
    logger *slog.Logger
}

func NewMarketService(repo MarketRepository, cache Cache, logger *slog.Logger) MarketService {
    return &marketService{repo: repo, cache: cache, logger: logger}
}
```

## Repository Layer (PostgreSQL)

### Using pgx

```go
type pgMarketRepo struct {
    pool *pgxpool.Pool
}

func (r *pgMarketRepo) FindByID(ctx context.Context, id int64) (*Market, error) {
    var m Market
    err := r.pool.QueryRow(ctx,
        `SELECT id, name, status, created_at FROM markets WHERE id = $1`, id,
    ).Scan(&m.ID, &m.Name, &m.Status, &m.CreatedAt)
    if errors.Is(err, pgx.ErrNoRows) {
        return nil, ErrNotFound
    }
    if err != nil {
        return nil, fmt.Errorf("find market %d: %w", id, err)
    }
    return &m, nil
}
```

### Transaction Helper

```go
func WithTx(ctx context.Context, pool *pgxpool.Pool, fn func(tx pgx.Tx) error) error {
    tx, err := pool.Begin(ctx)
    if err != nil {
        return fmt.Errorf("begin tx: %w", err)
    }
    defer tx.Rollback(ctx)

    if err := fn(tx); err != nil {
        return err
    }
    return tx.Commit(ctx)
}
```

## Error Handling

### Domain Errors

```go
var (
    ErrNotFound     = errors.New("not found")
    ErrUnauthorized = errors.New("unauthorized")
    ErrForbidden    = errors.New("forbidden")
    ErrConflict     = errors.New("conflict")
)
```

### Error-to-HTTP Mapping

```go
func (s *Server) handleServiceError(w http.ResponseWriter, err error) {
    switch {
    case errors.Is(err, ErrNotFound):
        s.respondError(w, http.StatusNotFound, "not found")
    case errors.Is(err, ErrUnauthorized):
        s.respondError(w, http.StatusUnauthorized, "unauthorized")
    case errors.Is(err, ErrForbidden):
        s.respondError(w, http.StatusForbidden, "forbidden")
    default:
        var ve *ValidationError
        if errors.As(err, &ve) {
            s.respondError(w, http.StatusBadRequest, ve.Error())
            return
        }
        s.logger.Error("internal error", "error", err)
        s.respondError(w, http.StatusInternalServerError, "internal error")
    }
}
```

## Validation

```go
import "github.com/go-playground/validator/v10"

var validate = validator.New()

type CreateMarketRequest struct {
    Name        string   `json:"name" validate:"required,min=1,max=200"`
    Description string   `json:"description" validate:"required,min=1,max=2000"`
    EndDate     string   `json:"end_date" validate:"required,datetime=2006-01-02T15:04:05Z07:00"`
    Categories  []string `json:"categories" validate:"required,min=1,dive,min=1"`
}

func (s *Server) handleCreateMarket(w http.ResponseWriter, r *http.Request) {
    var req CreateMarketRequest
    if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
        s.respondError(w, http.StatusBadRequest, "invalid request body")
        return
    }
    if err := validate.Struct(req); err != nil {
        s.respondError(w, http.StatusUnprocessableEntity, err.Error())
        return
    }
    // ...
}
```

## Graceful Shutdown

```go
func Run(ctx context.Context, srv *http.Server) error {
    errCh := make(chan error, 1)
    go func() { errCh <- srv.ListenAndServe() }()

    select {
    case err := <-errCh:
        return err
    case <-ctx.Done():
        shutdownCtx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
        defer cancel()
        return srv.Shutdown(shutdownCtx)
    }
}
```

## Configuration

```go
type Config struct {
    Port        int           `env:"PORT" default:"8080"`
    DatabaseURL string        `env:"DATABASE_URL,required"`
    LogLevel    string        `env:"LOG_LEVEL" default:"info"`
    ReadTimeout time.Duration `env:"READ_TIMEOUT" default:"5s"`
}
```

## Related Skills

- `go-patterns` — Language patterns and idioms
- `go-testing` — Testing patterns
- `go-standards` — Naming and linting conventions
- `postgres-patterns` — Database query optimization and schema design