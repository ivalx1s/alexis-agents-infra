# Software Systems

# Main system being documented
mainSystem = softwareSystem "Main System" "Core system description" {

  # Web application container
  webapp = container "Web Application" "User interface" "React/TypeScript" {
    tags "WebApp"

    # Components
    authModule = component "Auth Module" "Handles authentication UI" "React"
    dashboardModule = component "Dashboard Module" "Main user interface" "React"
    apiClient = component "API Client" "Backend communication" "TypeScript"
  }

  # API container
  api = container "API Server" "REST API backend" "Node.js/Express" {
    tags "API"

    authController = component "Auth Controller" "Authentication endpoints" "Express"
    userController = component "User Controller" "User management endpoints" "Express"
    authService = component "Auth Service" "Authentication logic" "TypeScript"
    userService = component "User Service" "User business logic" "TypeScript"
    userRepository = component "User Repository" "Data access" "TypeORM"
  }

  # Database container
  database = container "Database" "Stores application data" "PostgreSQL" {
    tags "Database"
  }

  # Optional: Message queue
  # queue = container "Message Queue" "Async processing" "RabbitMQ" {
  #   tags "Queue"
  # }
}

# External systems
# externalAuth = softwareSystem "Identity Provider" "External auth service" {
#   tags "External"
# }

# externalPayment = softwareSystem "Payment Gateway" "Payment processing" {
#   tags "External"
# }
