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
| epic, story, task, board, task-board, work planning | `project-management` | Use `task-board` CLI. NEVER create board files manually. |
| feature development, implementation + board exists | `project-management` | Pick tasks from board, assign agents, update statuses. |
| spec, SPEC.md, requirements, breakdown | `project-management` | Break down spec into epics/stories/tasks via CLI. |
| architecture diagram, C4, structurizr, plantuml, sequence/component/class diagram | `architecture-diagrams` | Follow skill for patterns, folder structure, rendering. |
| iOS UI test, screenshot validation, XCUITest, snapshot test iOS | `ios-testing-tools` | Follow skill for Page Object, accessibility IDs, screenshots. |
| Android UI test, espresso, compose test, screenshot validation Android | `android-testing-tools` | Follow skill for test tags, Page Object, screenshots. |

---

## Workflow Details

For project management workflow (board setup, phases, sub-agent orchestration, prompts, review) — follow the `project-management` skill. It covers the full cycle: spec → board → phases → sub-agents → supervision.
