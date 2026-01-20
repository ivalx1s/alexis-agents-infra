# Accessibility Identifiers

BEM-like naming convention for iOS accessibility identifiers.

## Naming Pattern

```
{Module} {Screen} {Element} {Action/State}
```

### Components

| Component | Description | Examples |
|-----------|-------------|----------|
| Module | Feature/domain area | `Auth`, `Onepager`, `Account`, `Settings` |
| Screen | Screen/page within module | `initial`, `pin wall`, `profile` |
| Element | UI element type | `button`, `field`, `label`, `page`, `cell` |
| Action/State | What it does or its state | `login`, `submit`, `create`, `disabled` |

## Examples

```swift
// Buttons
"Auth initial Login button"
"Auth initial Signup button"
"Onepager Account button"
"Onepager Recent calls button"
"Settings Logout button"

// Pages/Screens (for waitForExistence)
"Auth pin wall Create pin page"
"Auth pin wall Conform pin page"
"Profile management page"

// Input fields
"Auth login Email field"
"Auth login Password field"
"Search input field"

// Labels
"Profile username label"
"Account balance label"

// Lists/Cells
"Contacts list cell"
"Recent calls item cell"
```

## Implementation

### Define in TestEnvShared

```swift
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
        }
    }
}
```

### Apply in SwiftUI

```swift
Button("Login") { ... }
    .accessibilityIdentifier(UITest.Identifier.Auth.Initial.login_btn)
```

### Apply in UIKit

```swift
loginButton.accessibilityIdentifier = UITest.Identifier.Auth.Initial.login_btn
```

## Best Practices

1. **Use lowercase with spaces** - readable in Xcode accessibility inspector
2. **Be specific** - avoid generic names like "button1"
3. **Include context** - module and screen prevent collisions
4. **Keep it consistent** - same pattern across the app
5. **Document new IDs** - add to TestEnvShared immediately
6. **Test in inspector** - verify IDs appear in Accessibility Inspector
