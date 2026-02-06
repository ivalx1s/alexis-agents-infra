# Workflow

## Version Control

* **Never commit or stage files automatically.**
* When work is ready to commit, stop and ask for review.
* **Never add Co-Authored-By lines** or any AI attribution to commits.

---

## Task Tracking

* For projects with `project-management` skill active — use `task-board` CLI (epics, stories, tasks). Don't use `.temp/tasks.md`.
* For projects without a board — create a task plan in `.temp/tasks.md` before starting work.
* Track progress in the same file.
* Update/append to the existing plan — **don't create new task files each session**.
* Purpose: resume smoothly if the session breaks.

---

## Logging

* Store logs in `.temp/` with numbered naming:
  * `pod-lint-01.log`, `spm-build-01.log`, etc.
* Document log locations in your notes/tasks.
