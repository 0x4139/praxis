---
name: typescript-standards
description: TypeScript and JavaScript coding conventions covering naming, typing, ESLint configuration, and project structure. Use as reference when writing or reviewing TS/JS code.
user-invocable: false
---

# TypeScript Coding Standards

Naming conventions, type safety rules, formatting, and linting configuration for TypeScript and JavaScript projects.

## When to Activate

- Writing or reviewing TypeScript/JavaScript code
- Setting up a new TS/JS project
- Configuring ESLint, Prettier, or TypeScript compiler
- Enforcing naming or structural consistency

## Naming Conventions

### Variables and Functions
- `camelCase` for variables and functions: `marketSearchQuery`, `fetchMarketData`
- `PascalCase` for types, interfaces, classes, enums, React components: `Market`, `UserService`, `MarketCard`
- `SCREAMING_SNAKE_CASE` for constants: `MAX_RETRIES`, `DEBOUNCE_DELAY_MS`
- Boolean variables: `is`, `has`, `should` prefix: `isAuthenticated`, `hasPermission`
- Functions: verb-noun pattern: `fetchMarkets`, `calculateSimilarity`, `isValidEmail`

### Files
- React components: `PascalCase.tsx`: `MarketCard.tsx`, `UserProfile.tsx`
- Hooks: `camelCase` with `use` prefix: `useAuth.ts`, `useDebounce.ts`
- Utilities: `camelCase.ts`: `formatDate.ts`, `parseConfig.ts`
- Types: `camelCase.types.ts`: `market.types.ts`
- Tests: `.test.ts` or `.spec.ts` suffix

### Imports
- Named imports over default imports (better refactoring, tree-shaking)
- Group: node builtins, external packages, internal modules, relative imports
- No circular imports

## Type Safety

### Rules
- Never use `any` — use `unknown` and narrow, or define a proper type
- Prefer `interface` for object shapes, `type` for unions/intersections
- Use discriminated unions over optional fields for mutually exclusive states
- Use `as const` for literal types
- Use `satisfies` for type checking without widening

### Patterns

```typescript
// Discriminated union over optional fields
type Result<T> =
  | { success: true; data: T }
  | { success: false; error: string }

// Zod for runtime validation at system boundaries
const CreateMarketSchema = z.object({
  name: z.string().min(1).max(200),
  description: z.string().min(1),
  endDate: z.string().datetime(),
})
type CreateMarket = z.infer<typeof CreateMarketSchema>
```

## Immutability

- Use `const` by default, `let` only when mutation is required, never `var`
- Spread for object/array updates: `{ ...obj, key: value }`, `[...arr, item]`
- Use `readonly` for function parameters that should not be mutated
- Use `Readonly<T>` and `ReadonlyArray<T>` where appropriate

## Error Handling

- Always handle errors from async operations
- Use typed error classes for domain errors
- `try/catch` at boundaries, not around every call
- `Promise.all` for parallel async, not sequential awaits
- Never swallow errors silently

## Project Structure

```text
src/
├── app/              # Next.js App Router / entry points
├── components/       # React components
│   ├── ui/          # Generic UI components
│   ├── forms/       # Form components
│   └── layouts/     # Layout components
├── hooks/           # Custom React hooks
├── lib/             # Utilities and configs
│   ├── api/        # API clients
│   ├── utils/      # Helper functions
│   └── constants/  # Constants
├── types/           # Shared TypeScript types
└── styles/         # Global styles
```

## ESLint Configuration

### Recommended Rules

```json
{
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:@typescript-eslint/recommended-type-checked"
  ],
  "rules": {
    "@typescript-eslint/no-explicit-any": "error",
    "@typescript-eslint/no-unused-vars": ["error", { "argsIgnorePattern": "^_" }],
    "@typescript-eslint/consistent-type-imports": "error",
    "@typescript-eslint/no-floating-promises": "error",
    "no-console": ["warn", { "allow": ["warn", "error"] }],
    "prefer-const": "error",
    "no-var": "error"
  }
}
```

### Prettier Integration

```json
{
  "semi": false,
  "singleQuote": true,
  "trailingComma": "es5",
  "printWidth": 100,
  "tabWidth": 2
}
```

## Anti-Patterns

- `any` as an escape hatch instead of proper typing
- `// @ts-ignore` without explanation
- Mutation of function parameters or shared state
- `var` declarations
- Default exports (harder to refactor)
- Deep nesting — use early returns
- Magic numbers without named constants
- Long functions (>50 lines) — split into smaller functions
- Copy-paste code — extract to shared utilities

## Quick Reference

| Topic | Convention |
|-------|-----------|
| Variables/functions | `camelCase` |
| Types/interfaces/classes | `PascalCase` |
| Constants | `SCREAMING_SNAKE_CASE` |
| React components | `PascalCase` |
| Hooks | `useCamelCase` |
| Files (components) | `PascalCase.tsx` |
| Files (utilities) | `camelCase.ts` |
| Booleans | `is/has/should` prefix |
| Functions | verb-noun pattern |
| Never | `any`, `var`, `// @ts-ignore` |

## Related Skills

- `frontend-patterns` — React component and state patterns
- `bun-backend` — Bun/TS backend architecture
- `api-design` — API contract design