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
| epic, story, task, board, task-board, work planning, борд, доска, задачи, эпик, стори, таски | `project-management` | Use `task-board` CLI. NEVER create board files manually. |
| feature development, implementation, реализуй, запили, сделай, имплементируй, напиши фичу + board exists (.task-board/) | `project-management` | Pick tasks from board, assign agents, update statuses. |
| spec, SPEC.md, requirements, breakdown, спека, требования, декомпозиция, разбей на задачи, декомпозируй | `project-management` | Break down spec into epics/stories/tasks via CLI. |
| what's next, что дальше, какие задачи, статус, прогресс, status, progress, покажи борд, summary | `project-management` | Show board status via `task-board summary` or `task-board list`. |
| architecture diagram, C4, structurizr, plantuml, sequence/component/class diagram | `architecture-diagrams` | Follow skill for patterns, folder structure, rendering. |
| iOS UI test, screenshot validation, XCUITest, snapshot test iOS | `ios-testing-tools` | Follow skill for Page Object, accessibility IDs, screenshots. |
| Android UI test, espresso, compose test, screenshot validation Android | `android-testing-tools` | Follow skill for test tags, Page Object, screenshots. |
| currency exchange, обмен валют, драмы, рубли, AMD, RUB, rate.am, раттам, курс обмена, поменять валюту, конвертация валют | `currency-exchange` | Use `exchange` CLI. NEVER scrape rate sources manually. |

---

## Workflow Details

For project management workflow (board setup, phases, sub-agent orchestration, prompts, review) — follow the `project-management` skill. It covers the full cycle: spec → board → phases → sub-agents → supervision.
