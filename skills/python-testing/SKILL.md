---
name: python-testing
description: Python testing patterns using pytest including parametrize, fixtures, mocking, async testing, and coverage. Follows TDD methodology with idiomatic Python practices.
user-invocable: false
---

# Python Testing Patterns

pytest-based testing patterns for writing reliable, maintainable tests following TDD methodology.

## When to Activate

- Writing new Python functions or classes
- Adding test coverage to existing code
- Testing async code with `pytest-asyncio`
- Configuring coverage targets

## TDD Workflow

```
RED     → Write a failing test first
GREEN   → Write minimal code to pass the test
REFACTOR → Improve code while keeping tests green
REPEAT  → Continue with next requirement
```

## Parametrize (Table-Driven Tests)

The pytest equivalent of Go's table-driven tests. Use `@pytest.mark.parametrize` to express multiple cases declaratively:

```python
import pytest

@pytest.mark.parametrize("a,b,expected", [
    (1, 2, 3),
    (0, 0, 0),
    (-1, 1, 0),
])
def test_add(a: int, b: int, expected: int) -> None:
    assert add(a, b) == expected
```

For complex cases, use named tuples or `pytest.param` with an `id`:

```python
@pytest.mark.parametrize("input,expected", [
    pytest.param("hello", "HELLO", id="lowercase"),
    pytest.param("WORLD", "WORLD", id="already-upper"),
    pytest.param("", "", id="empty"),
])
def test_upper(input: str, expected: str) -> None:
    assert upper(input) == expected
```

## Fixtures

Fixtures are pytest's dependency injection system. Prefer fixtures over `setUp`/`tearDown`.

```python
import pytest

@pytest.fixture
def user() -> User:
    return User(id=1, name="Alice", active=True)

@pytest.fixture
def db(tmp_path):
    database = Database(path=tmp_path / "test.db")
    database.migrate()
    yield database
    database.close()

def test_save_user(db: Database, user: User) -> None:
    db.save(user)
    assert db.get(user.id) == user
```

### Fixture Scopes

| Scope | Lifetime |
|-------|----------|
| `function` (default) | Per test |
| `class` | Per test class |
| `module` | Per file |
| `session` | Entire test run |

### Useful Built-in Fixtures

- `tmp_path` — `pathlib.Path` to a temp directory, auto-cleaned
- `monkeypatch` — Patch attributes, env vars, and builtins safely
- `capsys` — Capture stdout/stderr
- `caplog` — Capture log output

## Mocking

Use `unittest.mock` from stdlib. Avoid mocking things you don't own.

```python
from unittest.mock import AsyncMock, MagicMock, patch

def test_send_notification(monkeypatch):
    mock_send = MagicMock(return_value=True)
    monkeypatch.setattr("myapp.notifications.send_email", mock_send)

    notify_user(user_id=1, message="Hello")

    mock_send.assert_called_once_with(to="user@example.com", body="Hello")
```

### Async Mocking

```python
@pytest.mark.asyncio
async def test_fetch_user():
    mock_repo = AsyncMock(spec=UserRepository)
    mock_repo.get.return_value = User(id=1, name="Alice")

    result = await get_user(repo=mock_repo, user_id=1)

    assert result.name == "Alice"
    mock_repo.get.assert_awaited_once_with(1)
```

### Rules
- Use `spec=` in mocks to catch attribute typos at test time
- Prefer `monkeypatch` over `patch` decorator for readability
- Mock at the boundary (HTTP clients, DB drivers, external services), not internal logic

## Testing Async Code

Install `pytest-asyncio`. Configure in `pyproject.toml`:

```toml
[tool.pytest.ini_options]
asyncio_mode = "auto"
```

With `asyncio_mode = "auto"`, all `async def test_*` functions run automatically:

```python
async def test_fetch_markets(http_client: httpx.AsyncClient) -> None:
    response = await http_client.get("/api/markets")
    assert response.status_code == 200
    assert len(response.json()) > 0
```

## Coverage

```bash
pytest --cov=src --cov-report=term-missing
pytest --cov=src --cov-report=html          # Browser view at htmlcov/index.html
```

| Code Type | Target |
|-----------|--------|
| Critical business logic | 100% |
| Public APIs | 90%+ |
| General code | 80%+ |
| Generated / migration code | Exclude |

Exclude generated files in `pyproject.toml`:

```toml
[tool.coverage.run]
omit = ["src/*/migrations/*", "src/*/generated/*"]

[tool.coverage.report]
fail_under = 80
```

## HTTP Handler Testing

Use `httpx.AsyncClient` with ASGI transport for FastAPI / Starlette:

```python
import pytest
import httpx
from myapp.main import app

@pytest.fixture
async def client() -> httpx.AsyncClient:
    async with httpx.AsyncClient(app=app, base_url="http://test") as c:
        yield c

@pytest.mark.parametrize("method,path,status", [
    ("GET", "/api/markets", 200),
    ("GET", "/api/markets/999", 404),
    ("POST", "/api/markets", 422),  # missing body
])
async def test_market_routes(client, method, path, status):
    response = await client.request(method, path)
    assert response.status_code == status
```

## CI Integration

```yaml
- name: Run tests
  run: pytest --cov=src --cov-report=xml -q

- name: Check coverage
  run: pytest --cov=src --cov-fail-under=80 -q
```

## Testing Commands

```bash
pytest                          # All tests
pytest -v                       # Verbose
pytest -k "test_user"           # Match by name
pytest tests/unit/              # Specific directory
pytest --tb=short               # Short tracebacks
pytest -x                       # Stop on first failure
pytest --lf                     # Re-run last failed
pytest -n auto                  # Parallel (pytest-xdist)
pytest --cov=src -q             # With coverage
```

## Best Practices

**DO:**
- Write tests FIRST (TDD)
- Use `@pytest.mark.parametrize` for multiple cases
- Use fixtures for shared setup and teardown
- Use `spec=` when creating mocks
- Test behavior, not implementation details
- Test error paths explicitly

**DON'T:**
- Use `time.sleep()` in tests — use `freezegun` or mock time
- Mock things you don't own (stdlib, language builtins)
- Ignore flaky tests — fix the root cause
- Assert on implementation internals (private methods, call counts of internal helpers)
- Skip async tests with `asyncio.run()` inside sync tests — use `pytest-asyncio`

## Related Skills

- `python-patterns` — Language patterns and idioms
- `python-standards` — Naming, formatting, linting
