# PlantUML Component Diagram Reference

## Basic Components

```plantuml
@startuml
[Component]
[Another Component] as AC
component "Named Component" as NC
@enduml
```

## Interfaces

```plantuml
() "Interface"
() "Named Interface" as NI
interface "Full Interface" as FI
```

## Connections

### Basic

```plantuml
[Component] --> Interface
[Component] ..> Interface : uses
Interface -- [Component]
```

### Arrow Types

```plantuml
A --> B       # Solid arrow
A ..> B       # Dotted arrow
A --  B       # Solid line
A ..  B       # Dotted line
A --o B       # Aggregation
A --* B       # Composition
A <|-- B      # Inheritance
```

### Direction Control

```plantuml
[A] -left-> [B]
[A] -right-> [B]
[A] -up-> [B]
[A] -down-> [B]

# Short forms
[A] -l-> [B]
[A] -r-> [B]
[A] -u-> [B]
[A] -d-> [B]
```

## Containers

### Package

```plantuml
package "API Layer" {
  [REST Controller]
  [GraphQL Controller]
}
```

### Node

```plantuml
node "Server" {
  [Application]
  [Cache]
}
```

### Folder

```plantuml
folder "Services" {
  [User Service]
  [Order Service]
}
```

### Frame

```plantuml
frame "Module" {
  [Component A]
  [Component B]
}
```

### Cloud

```plantuml
cloud "AWS" {
  [Lambda]
  [S3]
}
```

### Database

```plantuml
database "PostgreSQL" {
  [Users Table]
  [Orders Table]
}
```

## Ports

```plantuml
component Component {
  port p1
  portin p2
  portout p3
}

[Client] --> p1
p2 --> [Internal]
p3 --> [External]
```

## Notes

```plantuml
[Component]
note left of Component: Left note
note right of Component: Right note
note top of Component: Top note
note bottom of Component: Bottom note

note "Floating note" as N1
Component .. N1
```

## Colors

```plantuml
[Component] #lightblue
[Warning Component] #red

package "Styled" #lightgreen {
  [Inner] #yellow
}
```

## Stereotypes

```plantuml
[Service] <<Service>>
[Controller] <<REST>>

component "Auth" <<Security>> {
  [JWT Handler]
}
```

## Skinparam

```plantuml
skinparam component {
  BackgroundColor #EFEFEF
  BorderColor #333333
  ArrowColor #333333
}

skinparam componentStyle rectangle
' Options: uml1, uml2, rectangle
```

## Complete Example

```plantuml
@startuml
!theme plain

title API Server Architecture

package "Presentation Layer" {
  [REST Controller] as REST
  [GraphQL Controller] as GQL
  () "HTTP" as HTTP
}

package "Business Layer" {
  [User Service] as UserSvc
  [Order Service] as OrderSvc
  [Auth Service] as AuthSvc
}

package "Data Layer" {
  [User Repository] as UserRepo
  [Order Repository] as OrderRepo
}

database "PostgreSQL" as DB {
  [users]
  [orders]
}

cloud "External" {
  [Payment Gateway] as Payment
  [Email Service] as Email
}

' Presentation to Business
HTTP -- REST
HTTP -- GQL
REST --> UserSvc
REST --> OrderSvc
GQL --> UserSvc
GQL --> OrderSvc

' Cross-cutting
REST ..> AuthSvc : validates
GQL ..> AuthSvc : validates

' Business to Data
UserSvc --> UserRepo
OrderSvc --> OrderRepo

' Data to DB
UserRepo --> DB
OrderRepo --> DB

' External integrations
OrderSvc --> Payment : process payment
UserSvc --> Email : send notifications

@enduml
```

## Layer Pattern

```plantuml
@startuml
!theme plain

package "Client" #LightBlue {
  [Mobile App]
  [Web App]
}

package "API Gateway" #LightGreen {
  [Kong]
}

package "Services" #LightYellow {
  [Service A]
  [Service B]
  [Service C]
}

package "Data" #LightPink {
  database "DB A"
  database "DB B"
  queue "Message Queue"
}

[Mobile App] --> [Kong]
[Web App] --> [Kong]

[Kong] --> [Service A]
[Kong] --> [Service B]

[Service A] --> [DB A]
[Service B] --> [DB B]
[Service A] --> [Message Queue]
[Service C] --> [Message Queue]

@enduml
```

## Microservices Pattern

```plantuml
@startuml
!theme plain

actor User

node "Load Balancer" as LB

node "Service Mesh" {
  [API Gateway] as GW

  frame "User Domain" {
    [User Service] as US
    database "User DB" as UDB
  }

  frame "Order Domain" {
    [Order Service] as OS
    database "Order DB" as ODB
  }

  frame "Inventory Domain" {
    [Inventory Service] as IS
    database "Inventory DB" as IDB
  }

  queue "Event Bus" as EB
}

User --> LB
LB --> GW

GW --> US
GW --> OS
GW --> IS

US --> UDB
OS --> ODB
IS --> IDB

US --> EB
OS --> EB
IS --> EB

@enduml
```
