# Project Guidelines

## Language & Stack
- **Language**: TypeScript (strict mode)
- **Runtime**: Node.js
- **Build**: tsx / tsup

## Commands
- Dev: `npm run dev`
- Build: `npm run build`
- Test: `npm test`
- Lint: `npm run lint`

## Code Style
- Use `interface` for object shapes, `type` for unions/intersections
- No `any` — use `unknown` and narrow
- Named exports only
- Use `node:` prefix for built-in modules (`node:fs`, `node:path`)
- Async/await over raw promises
- Validate external input at boundaries with zod or similar

## Architecture
- `src/` — source code
- `src/index.ts` — entry point, keep thin
- `src/lib/` — core logic
- `src/utils/` — pure helpers
- `src/types/` — shared types
- `tests/` — test files mirroring src structure
