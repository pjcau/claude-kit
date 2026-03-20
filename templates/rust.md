# Project Guidelines

## Language & Stack
- **Language**: Rust
- **Edition**: 2021+

## Commands
- Build: `cargo build`
- Test: `cargo test`
- Test single: `cargo test test_name`
- Lint: `cargo clippy -- -W warnings`
- Format: `cargo fmt`
- Run: `cargo run`

## Code Style
- Use `thiserror` for library errors, `anyhow` for application errors
- Prefer `&str` over `String` in function parameters
- Use `impl Trait` for return types when the concrete type is complex
- Derive `Debug` on all public types
- No `unwrap()` in production code — use `?` or proper error handling
- Group imports: std, external crates, internal modules
- Write tests in the same file using `#[cfg(test)]` module

## Architecture
- Keep `main.rs` thin — delegate to `lib.rs`
- One module per file, use `mod.rs` only for re-exports
- Public API in `lib.rs`, implementation details in submodules
