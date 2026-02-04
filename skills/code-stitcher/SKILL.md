---
name: code-stitcher
description: Utility to stitch project files into a single text file for analysis, search, or LLM context loading.
triggers:
  - need to search across many files
  - want to grep entire project
  - loading project context into LLM
  - serializing project structure
---

# Code Stitcher Skill

Utility for stitching project files into a single `.txt` file.

## When to Use

- **Search** — grep entire project with one query
- **Analysis** — understand structure, find where things are located
- **LLM context** — load entire project into a model
- **Archiving** — save project in readable flat format

---

## Location

```
~/.agents/skills/code-stitcher/
├── SKILL.md
├── scripts/
│   ├── code-stitcher/    # symlink to source repo
│   └── stitch.sh         # wrapper script
└── references/
```

Source repo: `/Users/aagrigore1/src/code-stitcher`

---

## Supported Extensions

- `.md` — Markdown
- `.swift` — Swift
- `.kt` — Kotlin
- `.txt` — Plain text

Files from `.gitignore` are excluded automatically.

---

## Output Format

```
/// File Start: path/to/file.md
<file content>
/// File End: path/to/file.md

/// File Start: path/to/another.swift
<file content>
/// File End: path/to/another.swift
```

---

## Usage

### Via wrapper script

```bash
~/.agents/skills/code-stitcher/scripts/stitch.sh <source_dir> <output_file>

# Examples:
~/.agents/skills/code-stitcher/scripts/stitch.sh ./src ./output.txt
~/.agents/skills/code-stitcher/scripts/stitch.sh .task-board .task-board/.temp/board.txt
```

### Directly via Swift

```bash
cd ~/.agents/skills/code-stitcher/scripts/code-stitcher

# Pack (read project → single file)
swift run CodeStitcher -- \
    mode:read \
    source:/path/to/project \
    destination:/path/to/output.txt

# Unpack (single file → project structure)
swift run CodeStitcher -- \
    mode:write \
    source:/path/to/input.txt \
    destination:/path/to/output/

# Dry run (simulate unpack)
swift run CodeStitcher -- \
    mode:writeDryRun \
    source:/path/to/input.txt \
    destination:/path/to/output/
```

---

## Common Scenarios

### Project-wide search

```bash
# Stitch
stitch.sh ./my-project ./my-project/.temp/all.txt

# Find all mentions
grep -n "ClassName" ./my-project/.temp/all.txt

# Find with context
grep -B2 -A5 "func doSomething" ./my-project/.temp/all.txt
```

### Loading context into LLM

```bash
# Stitch small project
stitch.sh ./small-lib ./context.txt

# Copy to clipboard (macOS)
cat ./context.txt | pbcopy
```

### Archiving/sharing

```bash
# Save project to single file
stitch.sh ./my-awesome-lib ./my-awesome-lib-v1.0.txt

# Restore
swift run CodeStitcher -- mode:write source:./my-awesome-lib-v1.0.txt destination:./restored/
```

---

## Tips

- For large projects output can be huge — use selectively
- `.gitignore` is respected — build artifacts won't be included
- Wrapper script creates output directory automatically
