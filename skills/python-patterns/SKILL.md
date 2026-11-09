---
name: python-patterns
description: Idiomatic Python patterns and best practices for building robust, efficient, and maintainable applications covering dataclasses, context managers, async, and Protocol-based design.
user-invocable: false
---

# Python Development Patterns

Idiomatic Python patterns and best practices for building robust, efficient, and maintainable applications.

## When to Activate

- Writing new Python code
- Reviewing Python code
- Refactoring existing Python code
- Designing Python packages or modules

## Core Principles

### 1. Explicit Over Implicit
Follow PEP 20. Avoid magic, hidden state, and surprising behavior. If a function has a side effect, make it obvious from the name or signature.

### 2. Flat Over Nested
Prefer early returns to deep nesting. Each nesting level is a cognitive cost.

```python
# Bad
def process(user):
    if user:
        if user.is_active:
            if user.has_permission("write"):
                do_work(user)

# Good
def process(user):
    if not user:
        return
    if not user.is_active:
        return
    if not user.has_permission("write"):
        return
    do_work(user)
```

### 3. Errors Are Values
Raise specific, named exceptions. Catch at the boundary. Never swallow silently.

## Structured Data: Dataclasses and Pydantic

### Dataclasses (stdlib, no validation)
```python
from dataclasses import dataclass, field

@dataclass
class Market:
    id: int
    name: str
    tags: list[str] = field(default_factory=list)
    active: bool = True
```

### Pydantic (external, with validation)
```python
from pydantic import BaseModel, Field

class CreateMarketRequest(BaseModel):
    name: str = Field(min_length=1, max_length=200)
    description: str = Field(min_length=1)
    tags: list[str] = Field(default_factory=list)
```

- Use `dataclass` for internal data with no validation requirements
- Use `Pydantic` at system boundaries (HTTP input, config, external APIs)

## Context Managers

### Class-Based
```python
class DBConnection:
    def __enter__(self) -> "DBConnection":
        self._conn = connect()
        return self

    def __exit__(self, exc_type, exc_val, exc_tb) -> bool:
        self._conn.close()
        return False  # don't suppress exceptions
```

### Generator-Based (preferred for simple cases)
```python
from contextlib import contextmanager

@contextmanager
def managed_transaction(db):
    tx = db.begin()
    try:
        yield tx
        tx.commit()
    except Exception:
        tx.rollback()
        raise
```

## Generator and Iterator Patterns

- Prefer generators over building full lists when the caller may not consume all items
- Use `yield from` to delegate to sub-iterators

```python
def read_in_chunks(file_obj, chunk_size: int = 4096):
    while chunk := file_obj.read(chunk_size):
        yield chunk
```

- `itertools` for composition: `chain`, `islice`, `groupby`, `product`

## Functional Patterns

### Comprehensions vs Loops
- List comprehension: when building a new list with a simple transform
- Generator expression: when passing to a function or only iterating once
- Loop: when there are side effects or the logic is complex

```python
# Good: simple transform
names = [u.name for u in users if u.is_active]

# Good: avoid building intermediate list
total = sum(u.score for u in users)

# Use a loop when there are multiple side effects
for user in users:
    notify(user)
    audit_log(user)
```

### `functools`
- `functools.cache` / `functools.lru_cache` for memoization
- `functools.partial` for partial application
- `functools.reduce` sparingly — prefer explicit loops for clarity

## Async Patterns

### Basic Structure
```python
import asyncio

async def fetch_user(client: httpx.AsyncClient, user_id: int) -> User:
    response = await client.get(f"/users/{user_id}")
    response.raise_for_status()
    return User(**response.json())
```

### Concurrent Tasks (Python 3.11+ TaskGroup)
```python
async def fetch_all(ids: list[int]) -> list[User]:
    async with httpx.AsyncClient() as client:
        async with asyncio.TaskGroup() as tg:
            tasks = [tg.create_task(fetch_user(client, uid)) for uid in ids]
    return [t.result() for t in tasks]
```

### Rules
- Never call blocking I/O (`requests`, `time.sleep`, `open`) inside `async def` — use `asyncio.sleep`, `httpx.AsyncClient`, `aiofiles`
- Always `await` coroutines — an unawaited coroutine is silently discarded
- Store `asyncio.create_task` results in a variable; tasks without references can be GC'd
- Use `asyncio.run()` only at the top-level entry point

### Async Context Managers
```python
async with aiofiles.open("data.json") as f:
    content = await f.read()
```

## Protocol-Based Design (Structural Subtyping)

Define interfaces as `Protocol`s at the consumer side, not the implementor side:

```python
from typing import Protocol, runtime_checkable

@runtime_checkable
class UserRepository(Protocol):
    async def get(self, user_id: int) -> User | None: ...
    async def save(self, user: User) -> None: ...
```

- Any class implementing `get` and `save` with matching signatures satisfies `UserRepository` — no inheritance needed
- Use `@runtime_checkable` only when you need `isinstance` checks at runtime

## Dependency Injection

Pass dependencies explicitly rather than importing globals:

```python
# Bad
from myapp.db import db  # global

async def get_user(user_id: int) -> User:
    return await db.fetch_one(...)

# Good
async def get_user(repo: UserRepository, user_id: int) -> User:
    return await repo.get(user_id)
```

## Quick Reference

| Idiom | Description |
|-------|-------------|
| Explicit over implicit | No hidden state or surprising magic |
| Early return | Handle error cases first, keep happy path flat |
| Errors are values | Raise specific exceptions, catch at boundaries |
| Dataclass / Pydantic | Prefer structured data over raw dicts |
| Protocol | Define interfaces where consumed, not where implemented |
| Generator | Prefer lazy evaluation over building full lists |
| `async with` / `async for` | Always use async context managers in async code |
| DI over globals | Pass dependencies explicitly |

## Related Skills

- `python-standards` — Naming, formatting, linting, anti-patterns
- `python-testing` — Testing patterns with pytest
