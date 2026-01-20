# Page Object Pattern

Organize UI tests with Page Object pattern for maintainability and reusability.

## Folder Structure

```
AppUITests/
  UIStruct/
    UITest+PageManager.swift            // Orchestrates all pages
    UITest+UIElement.swift              // Protocols
    Pages/
      UITest+Pages.swift                // enum UITest.Page {}
      Auth/
        UITest+Page+Auth.swift          // enum UITest.Page.Auth {}
        UITest+Page+Auth+Initial.swift  // Initial screen
        UITest+Page+Auth+SSO.swift      // SSO WebView
        PinWall/
          UITest+Page+Auth+PinWall.swift
          UITest+Page+Auth+PinWall+CreatePin.swift
          UITest+Page+Auth+PinWall+ConfirmPin.swift
          Components/
            UITest+Page+Auth+PinWall+Component+Numpad.swift
      Main/
        UITest+Page+Main.swift
        UITest+Page+Main+Initial.swift
  TestCases/
    Auth/
      UITests+AuthFlow.swift
    Main/
      UITests+MainScreen.swift
  Utils/
    XCTest+AppTestSuite.swift           // Base test class
    XCUIApplication+Launch.swift        // Launch helpers
    Allure/
      XCTest+Allure+Annotations.swift   // Allure integration
```

## Core Files

### UITest+UIElement.swift

```swift
extension UITest {
    @MainActor
    protocol PageElement {
        func waitForAppear()
    }
}

extension UITest {
    @MainActor
    protocol ComponentElement {
        func waitForAppear()
    }
}
```

### UITest+Pages.swift

```swift
extension UITest {
    enum Page {}
}
```

### UITest+Page+Auth.swift

```swift
extension UITest.Page {
    enum Auth {}
}
```

### UITest+Page+Auth+Initial.swift

```swift
extension UITest.Page.Auth {
    struct Initial: UITest.PageElement {
        private let loginButton: XCUIElement

        init(app: XCUIApplication) {
            self.loginButton = app.buttons[UITest.Identifier.Auth.Initial.login_btn]
        }

        func waitForAppear() {
            XCTAssert(loginButton.waitForExistence(timeout: 10),
                      "Login button didn't appear")
        }

        func tapLogin() {
            loginButton.tap()
        }
    }
}
```

### UITest+Page+Auth+PinWall.swift (Container)

```swift
extension UITest.Page.Auth {
    @MainActor
    struct PinWall {
        let createPin: CreatePin
        let confirmPin: ConfirmPin
        let enterPin: EnterPin

        init(app: XCUIApplication) {
            self.createPin = .init(app: app)
            self.confirmPin = .init(app: app)
            self.enterPin = .init(app: app)
        }

        func createPinSuccessfully(pin: String) {
            createPin.waitForAppear()
            createPin.enterPin(pin)
            confirmPin.waitForAppear()
            confirmPin.enterPin(pin)
        }
    }
}
```

### UITest+Page+Auth+PinWall+Component+Numpad.swift

```swift
extension UITest.Page.Auth.PinWall {
    enum Component {
        struct Numpad: UITest.ComponentElement {
            private let app: XCUIApplication

            init(app: XCUIApplication) {
                self.app = app
            }

            func enterPin(_ pin: String) {
                for digit in pin {
                    tap(digit)
                }
            }

            func waitForAppear() {
                // Numpad is always visible on pin screens
            }

            private func tap(_ digit: Character) {
                let button = app.buttons[String(digit)]
                XCTAssertTrue(button.waitForExistence(timeout: 0.5),
                              "Button \(digit) not found")
                button.tap()
            }
        }
    }
}
```

### UITest+PageManager.swift

```swift
extension UITest {
    @MainActor
    struct PageManager {
        let app: XCUIApplication

        // Pages
        let authInitial: UITest.Page.Auth.Initial
        let authSSO: UITest.Page.Auth.SSO
        let pinWall: UITest.Page.Auth.PinWall
        let mainInitial: UITest.Page.Main.Initial

        init(args: [String] = [], env: [String: String] = [:]) {
            let app = XCUIApplication()
            app.launchArguments = [UITest.Args.uiTestContext] + args
            app.launchEnvironment = env
            app.launch()

            self.app = app
            self.authInitial = .init(app: app)
            self.authSSO = .init(app: app)
            self.pinWall = .init(app: app)
            self.mainInitial = .init(app: app)
        }

        func terminateApp() {
            app.terminate()
        }

        func relaunchApp(args: [String] = [], env: [String: String] = [:]) {
            app.launchArguments = [UITest.Args.uiTestContext] + args
            app.launchEnvironment = env
            app.launch()
        }
    }
}
```

## Test Cases

### UITests+AuthFlow.swift

```swift
final class AuthFlowTests: AppTestSuite {
    func testLoginFlow() throws {
        epic("Authentication")
        story("User login")
        suite("Auth")
        testCase(allureId: "12345", label: "Login with credentials")

        let pm: UITest.PageManager = .init(args: [
            UITest.Args.shouldLogoutOnStart
        ])

        step("Verify login screen appears") {
            pm.authInitial.waitForAppear()
        }

        step("Tap login button") {
            pm.authInitial.tapLogin()
        }

        step("Enter credentials in SSO") {
            pm.authSSO.waitForAppear()
            pm.authSSO.enterCredentials(
                login: Creds.login,
                password: Creds.password
            )
        }

        step("Create PIN code") {
            pm.pinWall.createPinSuccessfully(pin: Creds.pin)
        }

        step("Verify main screen appears") {
            pm.mainInitial.waitForAppear()
        }
    }
}
```

## Best Practices

1. **One page = one screen** - map Pages to actual app screens
2. **Components for reusable UI** - keyboards, alerts, pickers
3. **PageManager as entry point** - single place to initialize all pages
4. **Descriptive method names** - `tapLogin()` not `tap()`
5. **Wait before interact** - always call `waitForAppear()` first
6. **Keep tests readable** - use `step()` for documentation
