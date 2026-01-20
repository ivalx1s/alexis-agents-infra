# Diagrams

Architecture diagrams for [Project Name].

## Structure

```
diagrams/
├── c4/                      # Structurizr DSL (C4 model)
│   ├── workspace.dsl        # Entrypoint
│   ├── model/               # Element definitions
│   ├── views/               # Diagram views
│   └── styles/              # Visual theme
├── plantuml/                # PlantUML diagrams
│   ├── sequence/            # Sequence diagrams
│   └── component/           # Component diagrams
└── artefacts/               # Generated outputs
    ├── c4/
    └── plantuml/
```

## Tools

### Structurizr CLI

```bash
# Install (macOS)
brew install structurizr-cli

# Validate
structurizr validate -workspace c4/workspace.dsl

# Export PNG
structurizr export -workspace c4/workspace.dsl -format png -output artefacts/c4

# Export SVG
structurizr export -workspace c4/workspace.dsl -format svg -output artefacts/c4
```

### PlantUML

```bash
# Download JAR
curl -L -o .temp/plantuml.jar https://github.com/plantuml/plantuml/releases/latest/download/plantuml.jar

# Render diagram
java -jar .temp/plantuml.jar plantuml/sequence/auth-flow.puml

# Render all
java -jar .temp/plantuml.jar -o ../artefacts/plantuml plantuml/**/*.puml

# Generate SVG
java -jar .temp/plantuml.jar -tsvg plantuml/sequence/auth-flow.puml
```

### Graphviz (optional, for some PlantUML diagrams)

```bash
brew install graphviz
```

## VSCode Extensions

- **PlantUML** (`jebbs.plantuml`) — Preview and export
- **Structurizr DSL** (`ciarant.vscode-structurizr`) — Syntax highlighting

## Diagrams

### C4 Model

| View | Description | File |
|------|-------------|------|
| System Context | High-level overview | `c4/views/context.dsl` |
| Containers | Major building blocks | `c4/views/containers.dsl` |
| Components | Internal structure | `c4/views/components.dsl` |

### Sequence Diagrams

| Diagram | Description | File |
|---------|-------------|------|
| Auth Flow | Authentication sequence | `plantuml/sequence/auth-flow.puml` |
| ... | ... | ... |

## Conventions

1. **One diagram = one purpose** — Don't overload diagrams
2. **Use autolayout** — Unless manual positioning is needed
3. **Name files descriptively** — `<domain>-<scenario>.<ext>`
4. **Keep model in sync** — Update relationships when structure changes
5. **Commit artifacts** — For easy review without tools
