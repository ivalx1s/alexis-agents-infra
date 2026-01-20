# Diagrams Rules

**Mandatory.**

## General

* Do not put "everything" into one diagram/file.
* Prefer multiple small, focused diagrams over one large unreadable diagram.
* Each diagram must have a clear title and narrow purpose.

---

## Structurizr DSL (C4) — required pattern

**Goal:** keep the DSL maintainable and LLM-friendly (diffable, reviewable), not a monolith.

### Rules

* Do **not** keep the whole model/views/styles in one big `workspace.dsl`.
* Use an entrypoint `workspace.dsl` that delegates via `!include`.
* Split by responsibility:
  * `model/*` defines elements and relationships,
  * `views/*` defines views,
  * `styles/*` defines styles/theme,
  * `docs/*` and `adrs/*` optional, if used.
* Includes must be ordered so definitions come before use:
  * define elements first,
  * then relationships,
  * then views.
* Keep each view focused; split into multiple views rather than "include everything" once it becomes messy.
* Prefer `autolayout` unless there is a strong reason not to.
* Prefer stable identifiers and structure; avoid noisy diffs.

### Recommended layout

```
diagrams/c4/structurizr/
  workspace.dsl                 # entrypoint only
  model/
    people.dsl
    systems.dsl
    containers.dsl
    components-*.dsl
    relationships.dsl
  views/
    context.dsl
    containers.dsl
    components-*.dsl
  styles/
    styles.dsl
  docs/                         # optional
  adrs/                         # optional
  output/                       # generated artifacts (keep out of git if desired)
```

### Example `workspace.dsl` (pattern)

```dsl
workspace "..." "..." {

  model {
    !include model
  }

  views {
    !include views
    !include styles
  }
}
```

---

## PlantUML — required pattern

**Goal:** one diagram file per scenario/purpose; shared includes separated.

### Rules

* One diagram file = one scenario / flow / purpose.
* Do not create mega-files with many unrelated flows.
* Use `_includes/` for shared styling/macros (theme/common/macros).
* Use stable, descriptive filenames (`feature-scenario`, `domain-action`).
* Keep diagrams readable; split if too dense.

### Recommended layout

```
diagrams/plantuml/
  _includes/
    theme.puml
    macros.puml
    common.puml
  sequence/
    auth-enrollment.puml
    login-totp.puml
  protocol/
    apdu-sign.puml
  infra/
    network-nat.puml
```
