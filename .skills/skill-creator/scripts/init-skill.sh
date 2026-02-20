#!/usr/bin/env zsh
#
# Initialize a new skill from template.
#
# Usage:
#   init-skill.sh <skill-name> --path <path>
#
# Example:
#   init-skill.sh my-new-skill --path agents/skills
#

set -euo pipefail

red()   { print -P "%F{red}$1%f" }
green() { print -P "%F{green}$1%f" }

# --- Args ---
STANDALONE=false

# Parse flags
args=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --standalone) STANDALONE=true; shift ;;
    *) args+=("$1"); shift ;;
  esac
done
set -- "${args[@]}"

if [[ $# -lt 3 ]] || [[ "$2" != "--path" ]]; then
  echo "Usage: init-skill.sh <skill-name> --path <path> [--standalone]"
  echo ""
  echo "  skill-name   Hyphen-case identifier (e.g. 'data-analyzer')"
  echo "  path         Directory where skill folder will be created"
  echo "  --standalone Generate setup.sh for standalone repo installation"
  echo ""
  echo "Examples:"
  echo "  init-skill.sh my-new-skill --path agents/skills"
  echo "  init-skill.sh api-helper --path /custom/location --standalone"
  exit 1
fi

SKILL_NAME="$1"
BASE_PATH="$3"

# --- Validate name ---
if [[ ! "$SKILL_NAME" =~ ^[a-z0-9]([a-z0-9-]*[a-z0-9])?$ ]]; then
  red "Error: name must be hyphen-case (lowercase, digits, hyphens, no leading/trailing hyphen)"
  exit 1
fi

if [[ ${#SKILL_NAME} -gt 64 ]]; then
  red "Error: name too long (${#SKILL_NAME} chars, max 64)"
  exit 1
fi

# --- Create dirs ---
SKILL_DIR="$(cd "$BASE_PATH" 2>/dev/null && pwd || mkdir -p "$BASE_PATH" && cd "$BASE_PATH" && pwd)/$SKILL_NAME"

if [[ -d "$SKILL_DIR" ]]; then
  red "Error: directory already exists: $SKILL_DIR"
  exit 1
fi

mkdir -p "$SKILL_DIR"/{scripts,references,assets}
green "Created: $SKILL_DIR"

# --- Title case ---
SKILL_TITLE=$(echo "$SKILL_NAME" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1')

# --- SKILL.md ---
cat > "$SKILL_DIR/SKILL.md" << SKILLEOF
---
name: $SKILL_NAME
description: |
  [TODO: What the skill does and when to use it. Include specific triggers/scenarios.]
---

# $SKILL_TITLE

## Overview

[TODO: 1-2 sentences explaining what this skill enables]

## [TODO: First Section]

[TODO: Add content. Choose a structure:
- **Workflow-based** — sequential steps (## Step 1 → ## Step 2)
- **Task-based** — operations/capabilities (## Quick Start → ## Task Category)
- **Reference** — standards/specs (## Guidelines → ## Specifications)
- **Capabilities** — interrelated features (## Core Capabilities → ### Feature)]

## Resources

- \`scripts/\` — executable code for automation
- \`references/\` — documentation loaded into context as needed
- \`assets/\` — files used in output (templates, images, etc.)

Delete unused resource directories.
SKILLEOF
green "Created: SKILL.md"

# --- Example files ---
cat > "$SKILL_DIR/references/README.md" << 'EOF'
# References

Documentation and reference material loaded into context as needed.

Replace this file with actual reference docs or delete if not needed.
EOF
green "Created: references/README.md"

cat > "$SKILL_DIR/assets/README.md" << 'EOF'
# Assets

Files used in output (templates, images, fonts, etc.) — not loaded into context.

Replace this file with actual assets or delete if not needed.
EOF
green "Created: assets/README.md"

# --- setup.sh (standalone repos) ---
if $STANDALONE; then
  cat > "$SKILL_DIR/setup.sh" << SETUPEOF
#!/usr/bin/env bash
set -euo pipefail

SKILL_NAME="$SKILL_NAME"
SKILL_DIR="\$(cd "\$(dirname "\$0")" && pwd)"

AGENTS_DIR="\$HOME/.agents/skills"
CLAUDE_DIR="\$HOME/.claude/skills"
CODEX_DIR="\$HOME/.codex/skills"

echo "Installing skill: \$SKILL_NAME"
echo "  Source: \$SKILL_DIR"

# 1. Copy skill into .agents/skills/ (installed copy, not a symlink)
if [ -L "\$AGENTS_DIR/\$SKILL_NAME" ]; then
  rm -f "\$AGENTS_DIR/\$SKILL_NAME"
fi
mkdir -p "\$AGENTS_DIR/\$SKILL_NAME"
rsync -a --delete "\$SKILL_DIR/" "\$AGENTS_DIR/\$SKILL_NAME/" --exclude='.git' --exclude='setup.sh'
echo "  Copied -> \$AGENTS_DIR/\$SKILL_NAME/"

# 2. Symlink from .claude/skills/ -> .agents/skills/
mkdir -p "\$CLAUDE_DIR"
rm -f "\$CLAUDE_DIR/\$SKILL_NAME"
ln -s "\$AGENTS_DIR/\$SKILL_NAME" "\$CLAUDE_DIR/\$SKILL_NAME"
echo "  Symlink -> \$CLAUDE_DIR/\$SKILL_NAME"

# 3. Symlink from .codex/skills/ -> .agents/skills/
mkdir -p "\$CODEX_DIR"
rm -f "\$CODEX_DIR/\$SKILL_NAME"
ln -s "\$AGENTS_DIR/\$SKILL_NAME" "\$CODEX_DIR/\$SKILL_NAME"
echo "  Symlink -> \$CODEX_DIR/\$SKILL_NAME"

echo ""
echo "Done. Installed \$(git -C "\$SKILL_DIR" describe --tags --always 2>/dev/null || echo 'unknown')"
SETUPEOF
  chmod +x "$SKILL_DIR/setup.sh"
  green "Created: setup.sh (standalone installation)"
fi

# --- Done ---
print ""
green "Skill '$SKILL_NAME' initialized at $SKILL_DIR"
print ""
echo "Next steps:"
echo "  1. Edit SKILL.md — fill in description and instructions"
echo "  2. Add scripts/references/assets as needed"
echo "  3. Run validate-skill.sh to check structure"
if $STANDALONE; then
  echo "  4. Run ./setup.sh to install"
fi
