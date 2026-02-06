#!/usr/bin/env zsh
#
# Validate a skill directory structure and SKILL.md frontmatter.
#
# Usage:
#   validate-skill.sh <path/to/skill>
#

set -euo pipefail

red()   { print -P "%F{red}$1%f" }
green() { print -P "%F{green}$1%f" }

if [[ $# -lt 1 ]]; then
  echo "Usage: validate-skill.sh <path/to/skill>"
  exit 1
fi

SKILL_PATH="$1"
ERRORS=0

fail() {
  red "  FAIL: $1"
  ERRORS=$((ERRORS + 1))
}

ok() {
  green "  OK: $1"
}

print ""
green "=== Validating skill: $SKILL_PATH ==="
print ""

# --- Directory exists ---
if [[ ! -d "$SKILL_PATH" ]]; then
  fail "Directory not found: $SKILL_PATH"
  exit 1
fi

# --- SKILL.md exists ---
SKILL_MD="$SKILL_PATH/SKILL.md"
if [[ ! -f "$SKILL_MD" ]]; then
  fail "SKILL.md not found"
  exit 1
fi
ok "SKILL.md exists"

# --- Frontmatter ---
FIRST_LINE=$(head -1 "$SKILL_MD")
if [[ "$FIRST_LINE" != "---" ]]; then
  fail "No YAML frontmatter (first line must be ---)"
  exit 1
fi
ok "Frontmatter present"

# --- Extract frontmatter ---
FRONTMATTER=$(sed -n '2,/^---$/p' "$SKILL_MD" | sed '$d')

# --- Name ---
NAME=$(echo "$FRONTMATTER" | grep -E '^name:' | head -1 | sed 's/^name:[[:space:]]*//')
if [[ -z "$NAME" ]]; then
  fail "Missing 'name' in frontmatter"
else
  # Hyphen-case check
  if [[ ! "$NAME" =~ ^[a-z0-9]([a-z0-9-]*[a-z0-9])?$ ]]; then
    fail "Name '$NAME' must be hyphen-case (lowercase, digits, hyphens)"
  elif [[ ${#NAME} -gt 64 ]]; then
    fail "Name too long (${#NAME} chars, max 64)"
  else
    ok "Name: $NAME"
  fi

  # Name matches directory
  DIR_NAME=$(basename "$SKILL_PATH")
  if [[ "$NAME" != "$DIR_NAME" ]]; then
    fail "Name '$NAME' doesn't match directory '$DIR_NAME'"
  else
    ok "Name matches directory"
  fi
fi

# --- Description ---
DESC=$(echo "$FRONTMATTER" | grep -E '^description:' | head -1 | sed 's/^description:[[:space:]]*//')
if [[ -z "$DESC" ]]; then
  # Could be multiline (description: |)
  DESC_MARKER=$(echo "$FRONTMATTER" | grep -c '^description:' || true)
  if [[ "$DESC_MARKER" -eq 0 ]]; then
    fail "Missing 'description' in frontmatter"
  else
    ok "Description present (multiline)"
  fi
else
  if [[ ${#DESC} -gt 1024 ]]; then
    fail "Description too long (${#DESC} chars, max 1024)"
  else
    ok "Description present"
  fi
fi

# --- Body content ---
BODY=$(sed -n '/^---$/,$ p' "$SKILL_MD" | tail -n +2)
BODY_LINES=$(echo "$BODY" | wc -l | tr -d ' ')
if [[ "$BODY_LINES" -lt 3 ]]; then
  fail "SKILL.md body too short ($BODY_LINES lines)"
else
  ok "Body: $BODY_LINES lines"
fi

if [[ "$BODY_LINES" -gt 500 ]]; then
  fail "SKILL.md body over 500 lines — consider splitting into references/"
fi

# --- Result ---
print ""
if [[ $ERRORS -eq 0 ]]; then
  green "=== Valid! ==="
  exit 0
else
  red "=== $ERRORS error(s) found ==="
  exit 1
fi
