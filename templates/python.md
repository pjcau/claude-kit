# Project Guidelines

## Language & Stack
- **Language**: Python 3.11+
- **Package Manager**: uv or pip

## Commands
- Test: `pytest -v`
- Lint: `ruff check .`
- Format: `ruff format .`
- Type check: `mypy .`
- Run: `python -m app`

## Code Style
- Type hints on all public function signatures
- Use dataclasses or Pydantic for data structures
- No bare `except:` — catch specific exceptions
- f-strings over `.format()` or `%`
- Use `pathlib.Path` over `os.path`
- Use `logging` module, not `print()` for diagnostics

## Architecture
- `src/` or package name directory for source
- `tests/` — pytest tests mirroring source structure
- `pyproject.toml` for project configuration
- One class per file for complex classes
