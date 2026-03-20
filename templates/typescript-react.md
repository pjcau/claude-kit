# Project Guidelines

## Language & Stack
- **Language**: TypeScript (strict mode)
- **Framework**: React
- **Build**: Vite

## Commands
- Dev: `npm run dev`
- Build: `npm run build`
- Test: `npm test`
- Lint: `npm run lint`
- Format: `npx prettier --write .`

## Code Style
- Functional components only, no class components
- Use `interface` for object shapes, `type` for unions/intersections
- No `any` — use `unknown` and narrow, or define proper types
- Named exports (no default exports)
- Co-locate tests: `Component.test.tsx` next to `Component.tsx`
- CSS modules or Tailwind — no inline styles for non-dynamic values

## Architecture
- `src/components/` — reusable UI components
- `src/pages/` or `src/routes/` — page-level components
- `src/hooks/` — custom hooks
- `src/lib/` or `src/utils/` — pure utility functions
- `src/types/` — shared type definitions
- `src/api/` — API client and request functions
