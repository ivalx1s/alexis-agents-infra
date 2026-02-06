#!/usr/bin/env zsh
#
# Package a skill into a distributable .skill file (zip).
#
# Usage:
#   package-skill.sh <path/to/skill> [output-dir]
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

red()   { print -P "%F{red}$1%f" }
green() { print -P "%F{green}$1%f" }

if [[ $# -lt 1 ]]; then
  echo "Usage: package-skill.sh <path/to/skill> [output-dir]"
  exit 1
fi

SKILL_PATH="$(cd "$1" && pwd)"
SKILL_NAME="$(basename "$SKILL_PATH")"
OUTPUT_DIR="${2:-$(pwd)}"

mkdir -p "$OUTPUT_DIR"
OUTPUT_FILE="$OUTPUT_DIR/$SKILL_NAME.skill"

# --- Validate first ---
print ""
green "Validating..."
if ! "$SCRIPT_DIR/validate-skill.sh" "$SKILL_PATH"; then
  red "Validation failed. Fix errors before packaging."
  exit 1
fi

# --- Package ---
print ""
green "Packaging $SKILL_NAME..."

# zip from parent so archive includes skill-name/ dir
PARENT_DIR="$(dirname "$SKILL_PATH")"
cd "$PARENT_DIR"
zip -r "$OUTPUT_FILE" "$SKILL_NAME" -x "*/.DS_Store" "*/.*"

print ""
green "Packaged: $OUTPUT_FILE"
