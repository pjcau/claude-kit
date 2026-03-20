# Project Guidelines

## Language & Stack
- **Language**: Python 3.11+
- **Framework**: FastAPI
- **Package Manager**: uv or pip

## Commands
- Dev: `uvicorn app.main:app --reload`
- Test: `pytest -v`
- Lint: `ruff check .`
- Format: `ruff format .`
- Type check: `mypy .`

## Code Style
- Type hints on all function signatures
- Pydantic models for request/response schemas
- Use `async def` for route handlers
- Dependency injection via `Depends()`
- No bare `except:` — catch specific exceptions
- f-strings over `.format()` or `%`

## Architecture
- `app/main.py` — FastAPI app setup, keep minimal
- `app/routers/` — route handlers grouped by domain
- `app/models/` — SQLAlchemy/Pydantic models
- `app/schemas/` — request/response Pydantic schemas
- `app/services/` — business logic
- `app/deps.py` — shared dependencies
- `tests/` — pytest tests
