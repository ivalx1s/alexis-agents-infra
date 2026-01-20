---
name: ios-ui-validation
description: |
  iOS UI testing toolkit with screenshot validation. Use when:
  (1) Setting up UI test infrastructure with Page Object pattern
  (2) Creating accessibility identifiers with structured naming
  (3) Writing UI tests with step-by-step screenshots
  (4) Validating UI via screenshot comparison
  (5) Integrating with Allure for test reporting
  (6) Organizing shared test identifiers between app and test targets
  File types: Swift UI tests, XCUITest, xcresult, Allure reports
---

# iOS UI Validation

Write UI, add UI tests with structured markup, validate via screenshots.

## Prerequisites

**Before starting, verify required tools are installed:**

```bash
./Scripts/check-tools.sh
```

Required:
- Xcode Command Line Tools (`xcodebuild`, `xcrun`, `xcresulttool`)
- Swift 5.9+
- iOS Simulator with available devices

## Main Workflow

1. **Write UI** with accessibility identifiers
2. **Write UI tests** using Page Object pattern
3. **Capture screenshots** at each step
4. **Extract and review** screenshots to verify UI looks as expected
5. **MANDATORY: Visually verify screenshots** - open and check that UI is rendered correctly

## CRITICAL: Screenshot Verification

After extracting screenshots, **ALWAYS open and visually inspect them** using the Read tool. Check for:

- **Orientation issues** - UI should not be rotated/sideways
- **Layout problems** - UI elements should be visible and properly positioned, not squished in corners
- **Content visibility** - all expected UI elements should be present and readable
- **Black screens** - indicates app didn't launch or UI didn't render

Common issues and fixes:
- **Rotated UI in landscape frame**: Force portrait in PageManager: `XCUIDevice.shared.orientation = .portrait`
- **Empty/black screenshots**: Check app launch, add delays if needed
- **Partial UI**: Scroll or adjust viewport before screenshot

## Core Components

### 1. UITestToolkit Package

SPM package providing:
- **ScreenshotKit** - capture screenshots with structured naming
- **UITestKit** - common UI test utilities:
  - `PageObject/` - PageElement, ComponentElement protocols, BaseUITestSuite
  - `Extensions/` - XCUIElement+WaitFor helper
  - `Allure/` - AllureTrackable protocol for Allure annotations
- **extract-screenshots** - macOS CLI to extract/organize screenshots from xcresult

Add as SPM dependency (local or remote).

**Important:** Only add `ScreenshotKit` and `UITestKit` to UI test target dependencies. Do NOT add `extract-screenshots` — it uses `Foundation.Process` (unavailable on iOS) and will fail to build for iOS Simulator. Run it from terminal only.

### 2. Accessibility ID System

BEM-like naming. See [references/accessibility-ids.md](references/accessibility-ids.md).

Pattern: `{Module} {Screen} {Element} {Action/State}`

```swift
"Auth initial Login button"
"Auth pin wall Create pin page"
```

### 3. Shared Identifiers (TestEnvShared)

Share IDs between app and test targets. See [references/shared-identifiers.md](references/shared-identifiers.md).

Template: `assets/TestEnvShared/`. Add to both main app and UI test targets.

### 4. Page Object Pattern

UI test structure. See [references/page-object-pattern.md](references/page-object-pattern.md).

Template: `assets/UIStruct/`. Copy to UI test target.

### 5. Allure Integration (Optional)

Only if project uses Allure TestOps. See [references/allure-integration.md](references/allure-integration.md).

Allure annotations are included in **UITestKit** (`Allure/AllureTrackable.swift`).

## Quick Start

### 1. Setup

```bash
# Copy TestEnvShared templates (shared between app and tests)
cp -r assets/TestEnvShared/ ./TestEnvShared/

# Copy UIStruct to UI test target (Page Objects)
cp -r assets/UIStruct/ ./AppUITests/UIStruct/
```

Add to Xcode:
- **UITestToolkit** as SPM dependency (local clone or git URL)
- **TestEnvShared** to both app and test target compile sources
- **ScreenshotKit + UITestKit** as dependencies to UI test target (NOT extract-screenshots!)

### 2. Mark UI Elements

```swift
// In SwiftUI
Button("Login") { ... }
    .accessibilityIdentifier(UITest.Identifier.Auth.Initial.login_btn)

// In UIKit
button.accessibilityIdentifier = UITest.Identifier.Auth.Initial.login_btn
```

### 3. Define Identifiers

```swift
// TestEnvShared/UITest/UITest+Identifiers.swift
extension UITest.Identifier {
    enum Auth {
        enum Initial {
            static let login_btn = "Auth initial Login button"
        }
    }
}
```

### 4. Create Page Object

```swift
// UIStruct/Pages/Auth/UITest+Page+Auth+Initial.swift
extension UITest.Page.Auth {
    struct Initial: UITest.PageElement {
        private let loginButton: XCUIElement

        init(app: XCUIApplication) {
            self.loginButton = app.buttons[UITest.Identifier.Auth.Initial.login_btn]
        }

        func waitForAppear() {
            XCTAssert(loginButton.waitForExistence(timeout: 5))
        }

        func tapLogin() {
            loginButton.tap()
        }
    }
}
```

### 5. Write Test with Screenshots

```swift
import XCTest
import ScreenshotKit
import UITestKit

final class AuthTests: BaseUITestSuite, AllureTrackable {
    override class func setUp() {
        super.setUp()
        ScreenshotManager.shared.startSession()
    }

    override func setUpWithError() throws {
        try super.setUpWithError()
        startTestScreenshots()
    }

    func testLoginFlow() throws {
        let pm: UITest.PageManager = .init()

        pm.authInitial.waitForAppear()
        screenshot(step: 1, "login_screen", app: pm.app)

        pm.authInitial.tapLogin()
        screenshot(step: 2, "after_login_tap", app: pm.app)

        pm.mainScreen.waitForAppear()
        screenshot(step: 3, "main_screen_visible", app: pm.app)
    }
}
```

### 6. Run and Extract Screenshots

**After EVERY test run, extract screenshots to `.temp/` (gitignored).**

**IMPORTANT: Run from your project directory** so screenshots land in your project's `.temp/`, not the toolkit's.

**Option A: One command (recommended)**

```bash
# Run from YOUR PROJECT directory (not toolkit directory!)
cd /path/to/your/project

# Path to toolkit (adjust as needed)
TOOLKIT=~/src/swift-ui-testing-tools

# Run tests and extract — output goes to .temp/ of current directory
$TOOLKIT/Scripts/run-tests-and-extract.sh \
  -workspace App.xcworkspace \
  -scheme App \
  -output .temp/screenshots

# With custom simulator:
$TOOLKIT/Scripts/run-tests-and-extract.sh \
  -workspace App.xcworkspace \
  -scheme App \
  -destination "platform=iOS Simulator,name=iPhone 15 Pro" \
  -output .temp/screenshots
```

Options:
- `-output dir` — where to put screenshots (default: `.temp/{timestamp}_screenshots`)
- `-destination "..."` — simulator to use (default: iPhone 16)

**Option B: Manual steps**

```bash
# Run from your project directory
cd /path/to/your/project

# Run tests (xcresult goes to .temp/)
xcodebuild test \
  -workspace App.xcworkspace \
  -scheme App \
  -destination "platform=iOS Simulator,name=iPhone 16" \
  -resultBundlePath .temp/latest.xcresult

# Extract screenshots to .temp/
swift run --package-path ~/src/swift-ui-testing-tools \
  extract-screenshots .temp/latest.xcresult .temp/screenshots
```

**MANDATORY: Always extract screenshots after test run.** Don't skip this step.

### 7. Review Screenshots (MANDATORY)

```
.temp/screenshots/                          # if -output .temp/screenshots
  Run_2026-01-16_12-38-13/
    Test_testLoginFlow/
      Step_01__18-12-25-546__login_screen.png
      Step_02__18-12-26-016__after_login_tap.png
      Step_03__18-12-26-591__main_screen_visible.png
```

**ALWAYS visually open and inspect screenshots** using the Read tool. Verify:
- UI is not rotated or sideways
- All elements are visible and properly laid out
- No black screens or rendering issues
- Content matches expected state for each step

If screenshots show orientation/layout issues, fix PageManager orientation setting and re-run tests.

## Screenshot Naming

Format: `Run_{session}__Test_{name}__Step_{NN}__{timestamp}__{description}`

| Part | Example | Description |
|------|---------|-------------|
| session | `2026-01-15_18-12-22` | Test run start |
| name | `testLoginFlow` | Test method |
| NN | `01` | Step number |
| timestamp | `18-12-25-546` | Capture time |
| description | `login_screen` | Your description |

## UI Element State Verification

**Use `waitFor` helper instead of sleep/delay.** Never use `Thread.sleep` for UI state changes.

The `waitFor` extension is included in **UITestKit** (`Extensions/XCUIElement+WaitFor.swift`).

### Usage

```swift
// Wait for label to change
XCTAssertTrue(element.waitFor(\.label, toBe: "Expected", timeout: 3))

// Wait for switch state
XCTAssertTrue(toggle.waitFor(\.stringValue, toBe: "1", timeout: 3)) // "1" = on, "0" = off
```

## SwiftUI Toggle Interaction

**SwiftUI Toggle in Form/List requires coordinate-based tap.** Standard `.tap()` hits the label, not the switch control.

```swift
func toggleDebugMode() {
    // Tap on the right side where the switch control is located
    let coordinate = debugToggle.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5))
    coordinate.tap()
}
```

This applies to any SwiftUI Toggle where the tap area includes the label.
