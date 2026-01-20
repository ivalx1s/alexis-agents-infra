# Structurizr DSL Reference

Quick reference for Structurizr DSL syntax.

## Workspace

```dsl
workspace "Name" "Description" {
  !identifiers hierarchical    # dot notation: system.container.component
  !impliedRelationships false  # don't auto-create implied relationships

  model { }
  views { }
}
```

## Model Elements

### Person

```dsl
user = person "User" "Description" {
  tags "External"
}
```

### Software System

```dsl
system = softwareSystem "System Name" "Description" {
  tags "Internal"
  url "https://docs.example.com"
}
```

### Container

Inside a software system:

```dsl
system = softwareSystem "System" {
  webapp = container "Web App" "Description" "React/TypeScript" {
    tags "WebApp"
  }

  api = container "API" "REST API" "Node.js"

  db = container "Database" "Stores data" "PostgreSQL" {
    tags "Database"
  }
}
```

### Component

Inside a container:

```dsl
api = container "API" "REST API" "Node.js" {
  authController = component "Auth Controller" "Handles auth" "Express"
  userService = component "User Service" "User logic" "TypeScript"
  userRepo = component "User Repository" "Data access" "TypeORM"
}
```

## Relationships

```dsl
# Basic
source -> destination "Description"

# With technology
source -> destination "Description" "REST/JSON"

# With tags
source -> destination "Description" "HTTP" {
  tags "Async"
}
```

### Relationship Examples

```dsl
# Person to system
user -> system "Uses"

# System to system
system -> externalSystem "Integrates with" "API"

# Container to container (hierarchical)
system.webapp -> system.api "Calls" "REST"

# Component to component
system.api.controller -> system.api.service "Uses"
```

## Views

### System Landscape

```dsl
systemLandscape "key" "Title" {
  include *
  autolayout lr
}
```

### System Context

```dsl
systemContext system "key" "Title" {
  include *
  exclude externalSystem
  autolayout lr
}
```

### Container

```dsl
container system "key" "Title" {
  include *
  autolayout lr
}
```

### Component

```dsl
component system.container "key" "Title" {
  include *
  autolayout tb
}
```

### Dynamic

```dsl
dynamic system "key" "Title" {
  user -> system.webapp "1. Opens browser"
  system.webapp -> system.api "2. Calls API"
  system.api -> system.db "3. Queries"
  autolayout lr
}
```

### Deployment

```dsl
deployment system "Production" "key" "Title" {
  include *
  autolayout lr
}
```

## Deployment Model

```dsl
model {
  deploymentEnvironment "Production" {
    deploymentNode "AWS" "Amazon Web Services" "Cloud" {
      deploymentNode "ECS" "Container Service" "Docker" {
        containerInstance system.api
      }

      deploymentNode "RDS" "Database Service" "PostgreSQL" {
        containerInstance system.db
      }
    }
  }
}
```

## Include/Exclude

```dsl
# Include all
include *

# Include specific elements
include user system.webapp system.api

# Include element and related
include element ->
include -> element
include -> element ->

# Exclude
exclude system.db
exclude relationship.tag=="Async"
```

## Styles

```dsl
styles {
  element "Person" {
    shape person
    background #08427b
    color #ffffff
    fontSize 22
  }

  element "Software System" {
    background #1168bd
    color #ffffff
  }

  element "Container" {
    background #438dd5
    color #ffffff
  }

  element "Component" {
    background #85bbf0
    color #000000
  }

  element "Database" {
    shape cylinder
  }

  element "WebApp" {
    shape WebBrowser
  }

  element "Mobile" {
    shape MobileDeviceLandscape
  }

  relationship "Relationship" {
    thickness 2
    color #707070
    style dashed
  }

  relationship "Async" {
    style dotted
  }
}
```

## Shapes

Available shapes:
- `Box` (default)
- `RoundedBox`
- `Circle`
- `Ellipse`
- `Hexagon`
- `Cylinder`
- `Pipe`
- `Person`
- `Robot`
- `Folder`
- `WebBrowser`
- `MobileDevicePortrait`
- `MobileDeviceLandscape`
- `Component`

## Includes

```dsl
# Include file
!include path/to/file.dsl

# Include directory (all .dsl files)
!include model

# Include from URL
!include https://example.com/shared.dsl
```

## Documentation & ADRs

```dsl
workspace {
  !docs docs           # Markdown files in docs/ folder
  !adrs adrs           # ADRs in adrs/ folder
}
```

## Useful Directives

```dsl
!identifiers hierarchical  # Enable dot notation
!impliedRelationships false
!constant NAME "value"
!var name "value"
```

## Properties

```dsl
workspace {
  properties {
    "structurizr.groupSeparator" "/"
  }
}
```

## Groups

```dsl
model {
  group "External Systems" {
    externalA = softwareSystem "External A"
    externalB = softwareSystem "External B"
  }
}
```
