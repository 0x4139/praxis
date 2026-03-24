---
name: frontend-patterns
description: Frontend development patterns for React, Next.js, state management, performance optimization, and UI best practices.
user-invocable: false
---

# Frontend Development Patterns

Modern frontend patterns for React, Next.js, and performant user interfaces.

## When to Activate

- Building React components (composition, props, rendering)
- Managing state (useState, useReducer, Zustand, Context)
- Implementing data fetching (SWR, React Query, server components)
- Optimizing performance (memoization, virtualization, code splitting)
- Working with forms (validation, controlled inputs, Zod schemas)
- Building accessible, responsive UI patterns

## Component Patterns

### Composition Over Inheritance
Build UIs by composing small components (`Card`, `CardHeader`, `CardBody`) rather than extending base classes. Pass `children` for flexibility.

### Compound Components
Share state via Context between tightly coupled components (e.g., `Tabs` + `TabList` + `Tab`). The parent provides context, children consume it.

### Render Props
Pass a function as children for flexible data rendering. Useful for components that manage loading/error/data states.

## Custom Hooks

- **useToggle**: Boolean state with stable toggle function
- **useDebounce**: Delay value updates for search inputs
- **useQuery**: Data fetching with loading/error/refetch states

## State Management

### Context + Reducer
For complex state shared across a subtree:
- Define `State` type and `Action` union
- Create `reducer` function
- Wrap in `Context.Provider`
- Expose via custom hook with error boundary

### When to Use What
| Scope | Tool |
|-------|------|
| Single component | `useState` |
| Complex local state | `useReducer` |
| Subtree shared state | Context + Reducer |
| Global client state | Zustand |
| Server state | React Query / SWR |

## Performance Optimization

### Memoization
- `useMemo` for expensive computations
- `useCallback` for functions passed as props
- `React.memo` for pure components that re-render often

### Code Splitting & Lazy Loading
- `lazy(() => import('./HeavyComponent'))` with `<Suspense fallback={...}>`
- Split by route, by feature, or by viewport visibility

### Virtualization
Use `@tanstack/react-virtual` for long lists. Render only visible items + overscan buffer.

## Form Handling

Controlled forms with validation:
- State per field, errors per field
- Validate on submit (or on blur for UX)
- Zod schema validation for complex forms

## Error Boundaries

Class component with `getDerivedStateFromError` and `componentDidCatch`. Wrap feature sections to isolate failures. Provide retry mechanism.

## Animation Patterns

Framer Motion for declarative animations:
- `AnimatePresence` for enter/exit
- `motion.div` with `initial`, `animate`, `exit`
- Stagger children with `transition.delay`

## Accessibility

### Keyboard Navigation
Handle `ArrowDown`, `ArrowUp`, `Enter`, `Escape` in custom dropdowns and menus. Use `role`, `aria-expanded`, `aria-haspopup`.

### Focus Management
Save focus on modal open, restore on close. Use `tabIndex={-1}` and `ref.focus()` for programmatic focus. Always support Escape to close.

For full React code examples, see `react-patterns.md`.

## Related Skills

- `design-system` — Design tokens, visual audit
- `typescript-standards` — TS naming and linting
- `slides` — HTML presentation generation