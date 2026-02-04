# Skill Triggers

Automatic skill activation rules. When these topics come up — **FIRST load the skill via Skill tool**, then proceed.

## Language Policy

- **Specs, docs, code comments:** English only
- **Sub-agent prompts:** English only
- **Task/story/epic descriptions:** English only
- **User communication:** Match user's language (default: English)

---

## Triggers

| Triggers | Skill | Action |
|----------|-------|--------|
| epic, story, task, board, task-board, "create a task", work planning | `project-management` | Use `task-board` CLI for all operations. NEVER create files manually. |
| feature development, implementation, "write code" + board exists | `project-management` | Pick tasks from board, assign agents via `task-board assign`, update statuses. |
| spec, SPEC.md, requirements, breakdown | `project-management` | Break down spec into epics/stories/tasks via CLI. |

---

## Workflow: Development with Board

1. Create epic/stories/tasks via `task-board create`
2. Set up dependencies via `task-board link`
3. **Show plan to user for approval:** `task-board plan EPIC-XX` — wait for user confirmation before executing
4. `task-board assign TASK-XX --agent "agent-name"` — assign agent before spawning
5. Spawn sub-agent via Task tool
6. On completion: `task-board progress status TASK-XX done`

---

## Sub-agent Requirements (CRITICAL)

When spawning sub-agents for task implementation:

**Coordinator (you) responsibilities:**
- Coordinator is a **SUPERVISOR** — does NOT write implementation code itself
- ALL implementation work goes to sub-agents
- Use `task-board assign` before spawning
- Monitor via `task-board agents --stale 30`

**Sub-agent prompt MUST include:**
```
You MUST use task-board CLI to track your progress:
- BEFORE starting a task: `task-board progress status TASK-XXX progress`
- AFTER completing a task: `task-board progress status TASK-XXX done`
- If blocked: `task-board progress status TASK-XXX blocked`
- Add notes: `task-board progress notes TASK-XXX "your notes"`
```

**Sub-agent naming:**
- Use meaningful names: `agent-auth`, `agent-encoding`, `agent-tests`
- NOT generic: `agent-1`, `agent-2`

**Verification:**
- After sub-agent completes, check `task-board agents` and `task-board list tasks --story STORY-XX`
- If statuses not updated — sub-agent didn't follow the protocol
