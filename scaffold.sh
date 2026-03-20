#!/usr/bin/env bash
set -euo pipefail

# claude-kit scaffold — Bootstrap a new project with Claude Code skills & agents

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

print_header() {
    echo -e "${BOLD}${CYAN}"
    echo "  ╔═══════════════════════════════════╗"
    echo "  ║         claude-kit scaffold        ║"
    echo "  ╚═══════════════════════════════════╝"
    echo -e "${NC}"
}

prompt_choice() {
    local prompt="$1"
    shift
    local options=("$@")

    echo -e "${BOLD}${prompt}${NC}"
    for i in "${!options[@]}"; do
        echo -e "  ${GREEN}$((i+1)))${NC} ${options[$i]}"
    done

    while true; do
        read -rp "  > " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#options[@]} )); then
            echo "${options[$((choice-1))]}"
            return
        fi
        echo -e "  ${RED}Invalid choice. Pick 1-${#options[@]}${NC}"
    done
}

prompt_text() {
    local prompt="$1"
    local default="${2:-}"
    echo -en "${BOLD}${prompt}${NC}"
    if [[ -n "$default" ]]; then
        echo -en " ${BLUE}[$default]${NC}"
    fi
    echo ""
    read -rp "  > " value
    echo "${value:-$default}"
}

print_header

# Step 1: Project name
PROJECT_NAME=$(prompt_text "Project name?")
if [[ -z "$PROJECT_NAME" ]]; then
    echo -e "${RED}Project name is required${NC}"
    exit 1
fi

# Step 2: Language
LANG=$(prompt_choice "Language?" "Rust" "TypeScript" "Python" "Go")

# Step 3: Framework/type based on language
case "$LANG" in
    "Rust")
        PROJECT_TYPE=$(prompt_choice "Project type?" "CLI (clap)" "API (axum)" "Library")
        TEMPLATE="rust"
        ;;
    "TypeScript")
        PROJECT_TYPE=$(prompt_choice "Project type?" "React (Vite)" "Node.js API" "CLI" "Library")
        case "$PROJECT_TYPE" in
            "React (Vite)") TEMPLATE="typescript-react" ;;
            *) TEMPLATE="typescript-node" ;;
        esac
        ;;
    "Python")
        PROJECT_TYPE=$(prompt_choice "Project type?" "FastAPI" "CLI (click/typer)" "Library" "Script")
        case "$PROJECT_TYPE" in
            "FastAPI") TEMPLATE="python-fastapi" ;;
            *) TEMPLATE="python" ;;
        esac
        ;;
    "Go")
        PROJECT_TYPE=$(prompt_choice "Project type?" "API" "CLI" "Library")
        TEMPLATE="go"
        ;;
esac

# Step 4: Select skills
echo -e "\n${BOLD}Which skills do you want?${NC}"
AVAILABLE_SKILLS=()
for skill_file in "$SCRIPT_DIR"/skills/*.md; do
    skill_name=$(basename "$skill_file" .md)
    AVAILABLE_SKILLS+=("$skill_name")
done

SELECTED_SKILLS=()
echo -e "  ${BLUE}Available: ${AVAILABLE_SKILLS[*]}${NC}"
echo -e "  ${GREEN}a)${NC} All skills"
echo -e "  ${GREEN}s)${NC} Select individually"
read -rp "  > " skill_choice

if [[ "$skill_choice" == "a" ]]; then
    SELECTED_SKILLS=("${AVAILABLE_SKILLS[@]}")
else
    for skill in "${AVAILABLE_SKILLS[@]}"; do
        read -rp "  Include ${skill}? [Y/n] " yn
        if [[ "${yn,,}" != "n" ]]; then
            SELECTED_SKILLS+=("$skill")
        fi
    done
fi

# Step 5: Select agents
echo -e "\n${BOLD}Which agents do you want?${NC}"
AVAILABLE_AGENTS=()
for agent_file in "$SCRIPT_DIR"/agents/*.md; do
    agent_name=$(basename "$agent_file" .md)
    AVAILABLE_AGENTS+=("$agent_name")
done

SELECTED_AGENTS=()
echo -e "  ${BLUE}Available: ${AVAILABLE_AGENTS[*]}${NC}"
echo -e "  ${GREEN}a)${NC} All agents"
echo -e "  ${GREEN}s)${NC} Select individually"
read -rp "  > " agent_choice

if [[ "$agent_choice" == "a" ]]; then
    SELECTED_AGENTS=("${AVAILABLE_AGENTS[@]}")
else
    for agent in "${AVAILABLE_AGENTS[@]}"; do
        read -rp "  Include ${agent}? [Y/n] " yn
        if [[ "${yn,,}" != "n" ]]; then
            SELECTED_AGENTS+=("$agent")
        fi
    done
fi

# Step 6: Create project
echo -e "\n${BOLD}${GREEN}Creating project: ${PROJECT_NAME}${NC}"
echo -e "  Language: ${LANG}"
echo -e "  Type: ${PROJECT_TYPE}"
echo -e "  Skills: ${SELECTED_SKILLS[*]}"
echo -e "  Agents: ${SELECTED_AGENTS[*]}"
echo ""

TARGET_DIR="$(pwd)/$PROJECT_NAME"
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

# Initialize git
git init -q

# Add claude-kit as submodule
git submodule add -q "$SCRIPT_DIR" .claude-kit 2>/dev/null || \
git submodule add -q "https://github.com/USER/claude-kit.git" .claude-kit 2>/dev/null || \
echo -e "${BLUE}Note: Add claude-kit submodule manually after pushing the repo${NC}"

# Create .claude directory
mkdir -p .claude/skills .claude/agents

# Copy selected skills
for skill in "${SELECTED_SKILLS[@]}"; do
    if [[ -f "$SCRIPT_DIR/skills/${skill}.md" ]]; then
        cp "$SCRIPT_DIR/skills/${skill}.md" ".claude/skills/"
    fi
done

# Copy selected agents
for agent in "${SELECTED_AGENTS[@]}"; do
    if [[ -f "$SCRIPT_DIR/agents/${agent}.md" ]]; then
        cp "$SCRIPT_DIR/agents/${agent}.md" ".claude/agents/"
    fi
done

# Generate CLAUDE.md from template
if [[ -f "$SCRIPT_DIR/templates/${TEMPLATE}.md" ]]; then
    cp "$SCRIPT_DIR/templates/${TEMPLATE}.md" CLAUDE.md

    # Append skill references
    echo "" >> CLAUDE.md
    echo "## Skills" >> CLAUDE.md
    for skill in "${SELECTED_SKILLS[@]}"; do
        echo "<!-- @.claude/skills/${skill}.md -->" >> CLAUDE.md
    done

    echo "" >> CLAUDE.md
    echo "## Agents" >> CLAUDE.md
    for agent in "${SELECTED_AGENTS[@]}"; do
        echo "<!-- @.claude/agents/${agent}.md -->" >> CLAUDE.md
    done
fi

# Create .gitignore
cat > .gitignore << 'GITIGNORE'
# OS
.DS_Store
Thumbs.db

# IDE
.idea/
.vscode/
*.swp
*.swo

# Environment
.env
.env.local
GITIGNORE

# Add language-specific ignores
case "$LANG" in
    "Rust")
        cat >> .gitignore << 'GITIGNORE'

# Rust
/target/
Cargo.lock
GITIGNORE
        # Create Cargo.toml
        cat > Cargo.toml << EOF
[package]
name = "$PROJECT_NAME"
version = "0.1.0"
edition = "2021"

[dependencies]
EOF
        mkdir -p src
        echo 'fn main() {
    println!("Hello from {}!");
}' > src/main.rs
        sed -i '' "s/{}/$PROJECT_NAME/" src/main.rs 2>/dev/null || true
        ;;
    "TypeScript")
        cat >> .gitignore << 'GITIGNORE'

# Node
node_modules/
dist/
*.tsbuildinfo
GITIGNORE
        # Create package.json
        cat > package.json << EOF
{
  "name": "$PROJECT_NAME",
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "dev": "tsx src/index.ts",
    "build": "tsup src/index.ts",
    "test": "vitest"
  }
}
EOF
        cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "strict": true,
    "outDir": "dist",
    "rootDir": "src",
    "declaration": true,
    "esModuleInterop": true,
    "skipLibCheck": true
  },
  "include": ["src"]
}
EOF
        mkdir -p src
        echo "console.log('Hello from $PROJECT_NAME');" > src/index.ts
        ;;
    "Python")
        cat >> .gitignore << 'GITIGNORE'

# Python
__pycache__/
*.py[cod]
*.egg-info/
dist/
.venv/
venv/
GITIGNORE
        # Create pyproject.toml
        cat > pyproject.toml << EOF
[project]
name = "$PROJECT_NAME"
version = "0.1.0"
requires-python = ">=3.11"

[tool.ruff]
line-length = 100

[tool.pytest.ini_options]
testpaths = ["tests"]
EOF
        mkdir -p "src/$PROJECT_NAME" tests
        echo "" > "src/$PROJECT_NAME/__init__.py"
        echo "def main():
    print('Hello from $PROJECT_NAME')

if __name__ == '__main__':
    main()" > "src/$PROJECT_NAME/main.py"
        ;;
    "Go")
        cat >> .gitignore << 'GITIGNORE'

# Go
/bin/
/vendor/
GITIGNORE
        cat > go.mod << EOF
module github.com/user/$PROJECT_NAME

go 1.22
EOF
        mkdir -p cmd/$PROJECT_NAME
        echo "package main

import \"fmt\"

func main() {
	fmt.Println(\"Hello from $PROJECT_NAME\")
}" > cmd/$PROJECT_NAME/main.go
        ;;
esac

# Create settings.json
mkdir -p .claude
cat > .claude/settings.json << 'EOF'
{
  "permissions": {
    "allow": [],
    "deny": []
  }
}
EOF

echo -e "\n${BOLD}${GREEN}Done!${NC} Project created at ${BLUE}${TARGET_DIR}${NC}"
echo -e "\nNext steps:"
echo -e "  ${CYAN}cd ${PROJECT_NAME}${NC}"
echo -e "  ${CYAN}claude${NC}  — start coding with all your skills loaded"
