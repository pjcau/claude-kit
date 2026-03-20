# claude-kit

A portable collection of Claude Code skills, agents, and project templates.
Designed to be included as a git submodule in any project.

## Structure

- `skills/` — Reusable skill definitions (.md files)
- `agents/` — Custom agent definitions (.md files)
- `templates/` — CLAUDE.md templates per language/framework
- `hooks/` — Reusable hook scripts
- `scaffold.sh` — CLI to bootstrap new projects with claude-kit

## Usage as submodule

```bash
# Add to a project
git submodule add git@github.com:USER/claude-kit.git .claude-kit

# In the project's CLAUDE.md, reference skills:
# @.claude-kit/skills/commit.md
# @.claude-kit/templates/rust.md
```
