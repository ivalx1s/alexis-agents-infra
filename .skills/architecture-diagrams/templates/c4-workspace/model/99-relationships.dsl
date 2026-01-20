# Relationships
# Define all relationships here to ensure all elements exist first

# ============================================================================
# Person -> System relationships
# ============================================================================

user -> mainSystem "Uses"
admin -> mainSystem "Administers"

# ============================================================================
# Person -> Container relationships
# ============================================================================

user -> mainSystem.webapp "Uses" "HTTPS"
admin -> mainSystem.webapp "Manages" "HTTPS"

# ============================================================================
# Container -> Container relationships
# ============================================================================

mainSystem.webapp -> mainSystem.api "Calls" "REST/JSON"
mainSystem.api -> mainSystem.database "Reads/Writes" "SQL/TCP"

# ============================================================================
# Component -> Component relationships (within webapp)
# ============================================================================

mainSystem.webapp.authModule -> mainSystem.webapp.apiClient "Uses"
mainSystem.webapp.dashboardModule -> mainSystem.webapp.apiClient "Uses"

# ============================================================================
# Component -> Component relationships (within api)
# ============================================================================

mainSystem.api.authController -> mainSystem.api.authService "Uses"
mainSystem.api.userController -> mainSystem.api.userService "Uses"
mainSystem.api.authService -> mainSystem.api.userRepository "Uses"
mainSystem.api.userService -> mainSystem.api.userRepository "Uses"

# ============================================================================
# Cross-container component relationships
# ============================================================================

mainSystem.webapp.apiClient -> mainSystem.api.authController "POST /auth/*" "REST"
mainSystem.webapp.apiClient -> mainSystem.api.userController "GET/POST /users/*" "REST"

# ============================================================================
# External system relationships
# ============================================================================

# mainSystem.api -> externalAuth "Validates tokens" "OAuth 2.0"
# mainSystem.api -> externalPayment "Processes payments" "HTTPS"
