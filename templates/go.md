# Project Guidelines

## Language & Stack
- **Language**: Go 1.22+

## Commands
- Build: `go build ./...`
- Test: `go test ./...`
- Test verbose: `go test -v ./...`
- Lint: `golangci-lint run`
- Run: `go run .`

## Code Style
- Accept interfaces, return structs
- Errors are values — check them, don't ignore
- Use `fmt.Errorf("context: %w", err)` for error wrapping
- Short variable names in small scopes, descriptive in large
- Table-driven tests
- No `init()` functions unless absolutely necessary
- Use `context.Context` as first parameter for cancellation

## Architecture
- `cmd/` — entry points (one per binary)
- `internal/` — private packages
- `pkg/` — public packages (if any)
- Keep `main.go` thin — wire dependencies and call `run()`
- One package per directory
- Interfaces close to the consumer, not the implementer
