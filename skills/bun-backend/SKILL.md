---
name: bun-backend
description: Bun and TypeScript backend patterns for API routes, validation with Zod, caching, middleware, and database access. Use as reference when building Bun/TS APIs.
user-invocable: false
---

# Bun Backend Patterns

Backend architecture patterns for Bun/TypeScript services.

## When to Activate

- Writing API routes in Bun or TypeScript
- Implementing middleware, validation, or error handling in TS backends
- Working with Zod schemas for request/response validation
- Adding caching layers (Redis, in-memory)
- Structuring a Bun/TS backend service

## API Route Patterns

### Bun.serve Handler

```typescript
Bun.serve({
  port: 3000,
  async fetch(req) {
    const url = new URL(req.url)
    if (url.pathname === "/api/markets" && req.method === "GET") {
      return handleListMarkets(req)
    }
    return new Response("Not Found", { status: 404 })
  },
})
```

### Response Helpers

```typescript
function jsonResponse<T>(data: T, status = 200): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: { "Content-Type": "application/json" },
  })
}

function errorResponse(message: string, status: number): Response {
  return jsonResponse({ error: message }, status)
}
```

## Validation with Zod

```typescript
import { z } from "zod"

const CreateMarketSchema = z.object({
  name: z.string().min(1).max(200),
  description: z.string().min(1).max(2000),
  endDate: z.string().datetime(),
  categories: z.array(z.string()).min(1),
})

type CreateMarket = z.infer<typeof CreateMarketSchema>

async function handleCreateMarket(req: Request): Promise<Response> {
  const body = await req.json()
  const result = CreateMarketSchema.safeParse(body)
  if (!result.success) {
    return jsonResponse({ error: "Validation failed", details: result.error.flatten() }, 400)
  }
  const market = await marketService.create(result.data)
  return jsonResponse(market, 201)
}
```

### Shared Schema Patterns

```typescript
const PaginationSchema = z.object({
  limit: z.coerce.number().int().min(1).max(100).default(20),
  offset: z.coerce.number().int().min(0).default(0),
})

const SortSchema = z.object({
  sort: z.enum(["created_at", "volume", "name"]).default("created_at"),
  order: z.enum(["asc", "desc"]).default("desc"),
})

const ListMarketsSchema = PaginationSchema.merge(SortSchema).extend({
  status: z.enum(["active", "resolved", "closed"]).optional(),
})
```

## Middleware Pattern

```typescript
type Handler = (req: Request) => Promise<Response>
type Middleware = (next: Handler) => Handler

function withAuth(next: Handler): Handler {
  return async (req) => {
    const token = req.headers.get("authorization")?.replace("Bearer ", "")
    if (!token) return errorResponse("Unauthorized", 401)
    const user = await verifyToken(token)
    ;(req as any).user = user
    return next(req)
  }
}

function chain(...middlewares: Middleware[]): Middleware {
  return (handler) => middlewares.reduceRight((h, mw) => mw(h), handler)
}
```

## Service Layer

```typescript
interface MarketService {
  list(filters: ListMarketsInput): Promise<{ markets: Market[]; total: number }>
  get(id: string): Promise<Market>
  create(input: CreateMarket): Promise<Market>
}

class MarketServiceImpl implements MarketService {
  constructor(private repo: MarketRepository, private cache: CacheService) {}

  async get(id: string): Promise<Market> {
    const cached = await this.cache.get<Market>(`market:${id}`)
    if (cached) return cached

    const market = await this.repo.findById(id)
    if (!market) throw new AppError("Market not found", 404)

    await this.cache.set(`market:${id}`, market, 300)
    return market
  }
}
```

## Error Handling

```typescript
class AppError extends Error {
  constructor(message: string, public statusCode: number, public code?: string) {
    super(message)
  }
}

function handleError(err: unknown): Response {
  if (err instanceof AppError) {
    return errorResponse(err.message, err.statusCode)
  }
  if (err instanceof z.ZodError) {
    return jsonResponse({ error: "Validation failed", details: err.flatten() }, 400)
  }
  console.error("Unexpected error:", err)
  return errorResponse("Internal server error", 500)
}
```

## Caching

```typescript
interface CacheService {
  get<T>(key: string): Promise<T | null>
  set(key: string, value: unknown, ttlSeconds: number): Promise<void>
  del(key: string): Promise<void>
}

class RedisCacheService implements CacheService {
  constructor(private redis: RedisClient) {}

  async get<T>(key: string): Promise<T | null> {
    const data = await this.redis.get(key)
    return data ? JSON.parse(data) : null
  }

  async set(key: string, value: unknown, ttlSeconds: number): Promise<void> {
    await this.redis.setex(key, ttlSeconds, JSON.stringify(value))
  }

  async del(key: string): Promise<void> {
    await this.redis.del(key)
  }
}
```

## Database Access (PostgreSQL)

```typescript
import { Pool } from "pg"

const pool = new Pool({ connectionString: process.env.DATABASE_URL })

class PgMarketRepo implements MarketRepository {
  async findById(id: string): Promise<Market | null> {
    const { rows } = await pool.query(
      "SELECT id, name, status, created_at FROM markets WHERE id = $1",
      [id]
    )
    return rows[0] ?? null
  }
}
```

## Graceful Shutdown

```typescript
const server = Bun.serve({
  port: Number(process.env.PORT) || 3000,
  async fetch(req) {
    // ... route handling
  },
})

process.on("SIGTERM", () => {
  console.log("Shutting down...")
  server.stop()
  // Close database connections, flush queues, etc.
  process.exit(0)
})

process.on("SIGINT", () => {
  server.stop()
  process.exit(0)
})
```

## Configuration

```typescript
import { z } from "zod"

const EnvSchema = z.object({
  PORT: z.coerce.number().default(3000),
  DATABASE_URL: z.string().url(),
  REDIS_URL: z.string().url().optional(),
  LOG_LEVEL: z.enum(["debug", "info", "warn", "error"]).default("info"),
  NODE_ENV: z.enum(["development", "production", "test"]).default("development"),
})

export const env = EnvSchema.parse(process.env)
```

## Related Skills

- `bun-runtime` — Bun runtime specifics and APIs
- `typescript-standards` — Naming and linting conventions
- `api-design` — API design patterns and contracts
- `postgres-patterns` — Database query optimization and schema design