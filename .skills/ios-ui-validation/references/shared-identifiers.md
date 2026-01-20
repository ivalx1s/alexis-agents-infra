# Shared Identifiers (TestEnvShared)

Shared code between main app target and UI test target to avoid copy-paste.

## Folder Structure

```
TestEnvShared/
  UITest/
    UITest+Namespace.swift      // Root namespace
    UITest+Identifiers.swift    // All accessibility IDs
    UITest+EnvArgs.swift        // Launch arguments for tests
    UITest+Consts.swift         // Test constants (credentials, etc.)
```

## Files

### UITest+Namespace.swift

```swift
enum UITest {}
```

### UITest+Identifiers.swift

```swift
extension UITest {
    enum Identifier {}
}

extension UITest.Identifier {
    enum Auth {
        enum Initial {
            static let login_btn = "Auth initial Login button"
            static let signup_btn = "Auth initial Signup button"
        }
        enum PinWall {
            enum Create {
                static let page = "Auth pin wall Create pin page"
            }
            enum Confirm {
                static let page = "Auth pin wall Confirm pin page"
            }
            enum Enter {
                static let page = "Auth pin wall Enter pin page"
            }
        }
    }

    enum Main {
        static let page = "Main page"
        static let profile_btn = "Main Profile button"
        static let settings_btn = "Main Settings button"
    }

    enum Settings {
        static let page = "Settings page"
        static let logout_btn = "Settings Logout button"
    }
}
```

### UITest+EnvArgs.swift

```swift
extension UITest {
    enum Args {
        static let uiTestContext = "-UI_TEST_CONTEXT"
        static let shouldLogoutOnStart = "-SHOULD_LOGOUT_ON_START"
        static let shouldResetOnStart = "-SHOULD_RESET_ON_START"
        static let mockNetworkEnabled = "-MOCK_NETWORK"
    }
}
```

### UITest+Consts.swift

```swift
extension UITest {
    enum Consts {
        enum TestCredentials {
            static let login = "test@example.com"
            static let password = "TestPassword123"
            static let pin = "1234"
        }

        enum Timeouts {
            static let short: TimeInterval = 2
            static let medium: TimeInterval = 5
            static let long: TimeInterval = 10
        }
    }
}
```

## Xcode Setup

1. Create folder `TestEnvShared` at project root
2. Add folder to Xcode project (not to any target yet)
3. In Build Phases for **main app target**:
   - Add `TestEnvShared/UITest/*.swift` to Compile Sources
4. In Build Phases for **UI test target**:
   - Add `TestEnvShared/UITest/*.swift` to Compile Sources

Both targets now share the same source files.

## Usage

### In Main App (SwiftUI)

```swift
import SwiftUI

struct LoginView: View {
    var body: some View {
        Button("Login") { ... }
            .accessibilityIdentifier(UITest.Identifier.Auth.Initial.login_btn)
    }
}
```

### In Main App (Check for Test Context)

```swift
@main
struct MyApp: App {
    init() {
        if CommandLine.arguments.contains(UITest.Args.uiTestContext) {
            // Configure for UI testing (disable animations, etc.)
        }
        if CommandLine.arguments.contains(UITest.Args.shouldLogoutOnStart) {
            // Force logout
        }
    }
}
```

### In UI Tests

```swift
let app = XCUIApplication()
app.launchArguments = [
    UITest.Args.uiTestContext,
    UITest.Args.shouldLogoutOnStart
]
app.launch()

let loginButton = app.buttons[UITest.Identifier.Auth.Initial.login_btn]
XCTAssertTrue(loginButton.waitForExistence(timeout: UITest.Consts.Timeouts.medium))
```

## Benefits

1. **Single source of truth** - IDs defined once, used everywhere
2. **Compile-time safety** - typos caught by compiler
3. **Refactoring support** - rename in one place
4. **Discoverability** - autocomplete shows available IDs
5. **No string duplication** - reduces bugs from copy-paste errors
