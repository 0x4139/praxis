---
name: python-standards
description: Python coding conventions covering naming, type hints, formatting, project structure, and linting configuration. Use as reference when writing or reviewing Python code.
user-invocable: false
---

# Python Coding Standards

Naming conventions, type hint rules, formatting, and linting configuration for Python projects.

## When to Activate

- Writing or reviewing Python code
- Setting up a new Python project
- Configuring linters and formatters
- Enforcing naming or structural consistency

## Naming Conventions

### Modules and Packages
- Lowercase with underscores: `user_service.py`, `market_repository.py`
- Short, lowercase package names: `api`, `users`, `core`
- No hyphens in importable names

### Classes
- `PascalCase`: `UserService`, `MarketRepository`, `HTTPClient`
- Acronyms stay uppercase: `HTTPClient`, `URLParser`, `SQLQuery`
- Exception classes end in `Error`: `ValidationError`, `NotFoundError`

### Functions and Methods
- `snake_case`: `get_user`, `create_market`, `parse_response`
- Private: leading underscore `_parse_internal`
- Dunder (magic): `__init__`, `__repr__`, `__enter__`

### Variables
- `snake_case`: `user_count`, `request_timeout`
- Constants: `UPPER_SNAKE_CASE` — `MAX_RETRIES`, `DEFAULT_TIMEOUT`
- Loop variables: short names fine (`i`, `k`, `v`) in small scopes

### Type Variables
- Single uppercase letter or `PascalCase` + `T` suffix: `T`, `K`, `V`, `UserT`

## Type Hints

Follow PEP 484 / 526 / 604 / 673. Require type hints on all public functions and methods.

### Modern Syntax (Python 3.10+)
```python
# Union types
def get(id: int) -> User | None: ...

# Built-in generics (no need to import from typing)
def process(items: list[str]) -> dict[str, int]: ...

# Optional is just T | None
def find(key: str) -> str | None: ...
```

### Protocols for Structural Subtyping
```python
from typing import Protocol

class Readable(Protocol):
    def read(self, n: int = -1) -> bytes: ...
```

### TypeVar and Generic Classes
```python
from typing import TypeVar, Generic

T = TypeVar("T")

class Stack(Generic[T]):
    def push(self, item: T) -> None: ...
    def pop(self) -> T: ...
```

### Rules
- Never use `Any` unless interfacing with untyped third-party code — always add a comment explaining why
- Add `# type: ignore[code]` with a justification comment, never bare `# type: ignore`
- Use `Final` for constants: `MAX_SIZE: Final = 100`
- Use `TypeAlias` for complex type aliases: `Headers: TypeAlias = dict[str, str]`

## Formatting

- `black` is mandatory — no manual formatting debates
- `ruff` for linting and import sorting (replaces `flake8` + `isort`)
- Import order: stdlib → third-party → local, separated by blank lines:

```python
import asyncio
import json
from pathlib import Path

import httpx
import pydantic

from myapp.core import config
from myapp.users import models
```

## Project Structure

```text
src/
  myapp/
    __init__.py
    main.py           # Entry point
    core/             # Shared config, logging, DB
    users/            # Domain: models, service, repository
    api/              # HTTP handlers / routers
tests/
  unit/
  integration/
pyproject.toml        # Single source of truth for deps + tool config
```

- Prefer `src/` layout — prevents accidental imports of the local package
- Group by domain, not by layer: `users/` not `handlers/`
- One `__init__.py` per package; keep them minimal (no side effects)

## Linting Configuration

### Recommended `pyproject.toml`

```toml
[tool.ruff]
line-length = 88
target-version = "py311"

[tool.ruff.lint]
select = [
  "E",   # pycodestyle errors
  "W",   # pycodestyle warnings
  "F",   # pyflakes
  "I",   # isort
  "B",   # flake8-bugbear
  "C4",  # flake8-comprehensions
  "UP",  # pyupgrade
  "S",   # bandit (security)
  "ANN", # type annotation checks
]
ignore = ["ANN101", "ANN102"]  # skip self/cls annotations

[tool.mypy]
strict = true
python_version = "3.11"

[tool.black]
line-length = 88
target-version = ["py311"]
```

### Essential Commands

```bash
black .
ruff check . --fix
mypy . --strict
```

## Anti-Patterns

- **Mutable default arguments**: `def fn(items=[])` — silently shared across calls; use `None`
- **Bare `except:`**: Catches `KeyboardInterrupt` and `SystemExit`; always name the exception
- **`import *`**: Breaks static analysis and creates namespace ambiguity
- **`type: ignore` without code**: Use `# type: ignore[attr-defined]` not bare `# type: ignore`
- **`global` keyword**: Mutable global state; use dependency injection or module-level constants
- **`__init__.py` side effects**: Heavy imports or I/O at import time slows startup
- **`eval` / `exec` on user input**: Arbitrary code execution
- **`pickle` on untrusted data**: Arbitrary code execution via deserialization
- **Checking `type(x) == Foo`**: Use `isinstance(x, Foo)` to respect subclasses
- **`assert` for validation**: Stripped by the optimizer (`python -O`); use explicit `if/raise`

## Related Skills

- `python-patterns` — Language patterns and idioms
- `python-testing` — Testing patterns with pytest

## Quick Reference

| Topic | Convention |
|-------|-----------|
| Modules | `snake_case.py` |
| Classes | `PascalCase` |
| Functions | `snake_case` |
| Constants | `UPPER_SNAKE_CASE` |
| Private | `_leading_underscore` |
| Dunder | `__double_underscore__` |
| Union types | `str \| None` (3.10+) |
| Formatting | `black` mandatory |
| Linting | `ruff` + `mypy --strict` |
| Imports | stdlib / third-party / local |
