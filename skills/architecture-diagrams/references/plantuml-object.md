# PlantUML Object Diagram Reference

## Basic Object

```plantuml
@startuml
object User
object "Named Object" as NO
@enduml
```

## Object with Fields

```plantuml
object user {
  id = 123
  name = "John Doe"
  email = "john@example.com"
  active = true
}
```

## Field Types

```plantuml
object config {
  host = "localhost"
  port = 8080
  timeout = 30000
  debug = false
  tags = ["api", "v1"]
}
```

## Links Between Objects

### Basic Link

```plantuml
object user
object order
user --> order
```

### Labeled Link

```plantuml
object user
object order
user --> order : places
```

### Link Types

```plantuml
user --> order      ' Association
user o-- profile    ' Aggregation
user *-- session    ' Composition
user <|-- admin     ' Inheritance
```

## Multiple Objects

```plantuml
@startuml
object user1 {
  id = 1
  name = "Alice"
}

object user2 {
  id = 2
  name = "Bob"
}

object team {
  id = 100
  name = "Engineering"
}

team *-- user1 : member
team *-- user2 : member
@enduml
```

## Packages/Namespaces

```plantuml
package "User Domain" {
  object user {
    id = 1
    name = "John"
  }

  object profile {
    bio = "Developer"
    avatar = "img.png"
  }
}

package "Order Domain" {
  object order {
    id = 1001
    total = 99.99
  }
}

user --> order : places
user --> profile : has
```

## Map (Dictionary) Objects

```plantuml
map UserRoles {
  admin => Full access
  editor => Edit content
  viewer => Read only
}

map Config {
  host => localhost
  port => 8080
  env => production
}

object user {
  name = "John"
  role = "admin"
}

user --> UserRoles : has role
```

## JSON-like Structures

```plantuml
object request {
  method = "POST"
  path = "/api/users"
  headers = {
    "Content-Type": "application/json"
  }
  body = {
    "name": "John",
    "email": "john@example.com"
  }
}
```

## Notes

```plantuml
object user {
  name = "John"
}

note left of user
  Created from
  registration form
end note

note right of user : Active user

note "Floating note" as N1
user .. N1
```

## Colors and Styling

```plantuml
object active #lightgreen {
  status = "active"
}

object inactive #lightgray {
  status = "inactive"
}

object error #pink {
  status = "error"
}
```

## Skinparam

```plantuml
skinparam object {
  BackgroundColor #EFEFEF
  BorderColor #333333
  FontSize 12
}

skinparam objectArrow {
  Color #333333
}
```

## Complete Example: E-commerce Snapshot

```plantuml
@startuml
!theme plain

title Order System - Object Diagram

package "Customer" {
  object customer {
    id = 1001
    name = "John Smith"
    email = "john@example.com"
    loyaltyTier = "Gold"
  }

  object address {
    street = "123 Main St"
    city = "New York"
    zipCode = "10001"
    country = "USA"
  }
}

package "Order" {
  object order {
    id = 5001
    status = "Processing"
    createdAt = "2024-01-15"
    total = 149.97
  }

  object item1 {
    productId = 201
    name = "Wireless Mouse"
    quantity = 1
    price = 29.99
  }

  object item2 {
    productId = 202
    name = "USB-C Cable"
    quantity = 2
    price = 9.99
  }

  object item3 {
    productId = 203
    name = "Laptop Stand"
    quantity = 1
    price = 99.99
  }
}

package "Payment" {
  object payment {
    id = 8001
    method = "Credit Card"
    status = "Completed"
    amount = 149.97
    last4 = "4242"
  }
}

customer --> address : shippingAddress
customer --> order : places
order *-- item1
order *-- item2
order *-- item3
order --> payment : paidWith

note right of order
  Discount applied:
  10% loyalty discount
end note

@enduml
```

## Complete Example: API Response

```plantuml
@startuml
!theme plain

title API Response Object Diagram

object response {
  status = 200
  statusText = "OK"
}

object headers {
  Content-Type = "application/json"
  X-Request-Id = "abc-123"
  Cache-Control = "max-age=3600"
}

object body {
  success = true
  message = "Users retrieved"
}

object pagination {
  page = 1
  perPage = 20
  total = 156
  totalPages = 8
}

object user1 {
  id = 1
  name = "Alice"
  role = "admin"
}

object user2 {
  id = 2
  name = "Bob"
  role = "user"
}

object user3 {
  id = 3
  name = "Charlie"
  role = "user"
}

response *-- headers
response *-- body
body *-- pagination
body *-- user1 : data[0]
body *-- user2 : data[1]
body *-- user3 : data[2]

@enduml
```

## Complete Example: Config Snapshot

```plantuml
@startuml
!theme plain

title Application Configuration Snapshot

object appConfig {
  name = "MyApp"
  version = "2.1.0"
  env = "production"
}

object serverConfig {
  host = "0.0.0.0"
  port = 8080
  workers = 4
}

object dbConfig {
  driver = "postgresql"
  host = "db.example.com"
  port = 5432
  database = "myapp_prod"
  poolSize = 20
}

object cacheConfig {
  driver = "redis"
  host = "cache.example.com"
  port = 6379
  ttl = 3600
}

object logConfig {
  level = "info"
  format = "json"
  output = "stdout"
}

map features {
  darkMode => true
  betaFeatures => false
  analytics => true
  notifications => true
}

appConfig *-- serverConfig
appConfig *-- dbConfig
appConfig *-- cacheConfig
appConfig *-- logConfig
appConfig --> features : featureFlags

@enduml
```

## When to Use Object Diagrams

1. **Snapshot of System State** — Show concrete instances at a point in time
2. **Test Case Visualization** — Illustrate test data setup
3. **API Response Documentation** — Show example payloads
4. **Configuration Documentation** — Show concrete config values
5. **Debug Visualization** — Understand object relationships during debugging

## Comparison: Class vs Object

```plantuml
@startuml
!theme plain

title Class Diagram (Template)

class User {
  +id: Int
  +name: String
  +email: String
}

class Order {
  +id: Int
  +total: Decimal
}

User "1" --> "*" Order

@enduml
```

```plantuml
@startuml
!theme plain

title Object Diagram (Instance)

object user1 {
  id = 1
  name = "John"
  email = "john@example.com"
}

object order1 {
  id = 101
  total = 49.99
}

object order2 {
  id = 102
  total = 149.99
}

user1 --> order1
user1 --> order2

@enduml
```
