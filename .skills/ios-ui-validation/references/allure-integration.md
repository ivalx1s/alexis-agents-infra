# Allure Integration

Integrate iOS UI tests with Allure TestOps for reporting.

## Components

1. **AllureTrackable protocol** - annotations for tests
2. **Base test class** - common setup with Allure support
3. **xcresults export** - convert xcresult to allure-results
4. **Allure cleanup** - remove duplicate suites
5. **allurectl upload** - upload to Allure TestOps

## AllureTrackable Protocol

### XCTest+Allure+Annotations.swift

```swift
import XCTest

@MainActor
protocol AllureTrackable {
    func epic(_ values: String...)
    func story(_ values: String...)
    func suite(_ values: String...)
    func owner(_ values: String...)
    func testCase(allureId: String, label: String)
    func step(_ name: String, action: () -> Void)
}

extension AllureTrackable {
    func epic(_ values: String...) {
        setLabels(name: "feature", values: values)
    }

    func story(_ values: String...) {
        setLabels(name: "story", values: values)
    }

    func suite(_ values: String...) {
        setLabels(name: "suite", values: values)
    }

    func owner(_ values: String...) {
        setLabels(name: "owner", values: values)
    }

    func testCase(allureId: String, label: String) {
        setNames(name: "name", values: [label])
        setAllureId(allureId)
    }

    func step(_ name: String, action: () -> Void) {
        XCTContext.runActivity(named: name) { _ in
            action()
        }
    }

    private func setAllureId(_ values: String...) {
        setLabels(name: "AS_ID", values: values)
    }

    private func setLabels(name: String, values: [String]) {
        for value in values {
            XCTContext.runActivity(named: "allure.label.\(name):\(value)") { _ in }
        }
    }

    private func setNames(name: String, values: [String]) {
        for value in values {
            XCTContext.runActivity(named: "allure.\(name):\(value)") { _ in }
        }
    }
}
```

## Base Test Class

### XCTest+AppTestSuite.swift

```swift
open class AppTestSuite: XCTestCase, AllureTrackable {
    typealias Creds = UITest.Consts.TestCredentials

    override public func setUp() {
        super.setUp()
        continueAfterFailure = false

        // Handle system alerts automatically
        addUIInterruptionMonitor(withDescription: "System Alerts") { alert in
            Task { @MainActor in
                if alert.buttons["Allow"].exists {
                    alert.buttons["Allow"].tap()
                }
                if alert.buttons["Don't Allow"].exists {
                    alert.buttons["Don't Allow"].tap()
                }
            }
            return true
        }
    }
}
```

## Test Example

```swift
final class LoginTests: AppTestSuite {
    func testSuccessfulLogin() throws {
        // Allure metadata
        owner("developer-name")
        epic("Authentication")
        story("User login")
        suite("Login")
        testCase(allureId: "TC-12345", label: "Successful login with valid credentials")

        let pm: UITest.PageManager = .init()

        step("Open login screen") {
            pm.authInitial.waitForAppear()
        }

        step("Enter credentials") {
            pm.authInitial.tapLogin()
            pm.authSSO.enterCredentials(login: Creds.login, password: Creds.password)
        }

        step("Verify main screen") {
            pm.mainInitial.waitForAppear()
        }
    }
}
```

## CI Pipeline

### 1. Run Tests

```bash
xcodebuild test \
  -workspace App.xcworkspace \
  -scheme App \
  -destination "platform=iOS Simulator,name=iPhone 16,OS=18.0" \
  -resultBundlePath TestResults
```

### 2. Export to Allure Format

Use `xcresults` tool (or xcresulttool) to export:

```bash
# Using xcresults binary
./scripts/xcresults export TestResults.xcresult allure-results

# Or using xcresulttool
xcrun xcresulttool export \
  --path TestResults.xcresult \
  --output-path allure-results \
  --type allure
```

### 3. Cleanup Allure Report

Remove duplicate suite labels:

```bash
swift run --package-path ./scripts/cleanup-allure-report cleanup-allure-report \
  source:./allure-results \
  suiteToRemove:app-ios-uitest
```

### 4. Upload to Allure TestOps

```bash
allurectl upload allure-results \
  --endpoint https://allure.example.com \
  --project-id 123 \
  --token $ALLURE_TOKEN \
  --launch-name "iOS Test Run - $(date +'%Y-%m-%d %H:%M')"
```

## Allure Report Cleanup Tool

Swift package to clean duplicate suite labels from allure-results.

### Package.swift

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "cleanup-allure-report",
    targets: [
        .executableTarget(name: "cleanup-allure-report")
    ]
)
```

### main.swift

```swift
import Foundation

enum Script {
    static func main(args: [String: String]) {
        guard let source = args["source"],
              let suiteToRemove = args["suiteToRemove"] else {
            print("Usage: source:/path/to/allure-results suiteToRemove:<suite>")
            exit(1)
        }

        let fm = FileManager.default
        guard let enumerator = fm.enumerator(atPath: source) else {
            print("Failed to enumerate: \(source)")
            exit(1)
        }

        var modified = 0
        for case let file as String in enumerator where file.hasSuffix(".json") {
            let path = "\(source)/\(file)"
            guard var json = readJSON(at: path),
                  var labels = json["labels"] as? [[String: Any]] else {
                continue
            }

            let before = labels.count
            labels.removeAll { item in
                (item["name"] as? String) == "suite" &&
                (item["value"] as? String) == suiteToRemove
            }

            if labels.count < before {
                json["labels"] = labels
                writeJSON(json, to: path)
                modified += 1
            }
        }

        print("Modified \(modified) files")
    }

    static func readJSON(at path: String) -> [String: Any]? {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return nil }
        return try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    }

    static func writeJSON(_ json: [String: Any], to path: String) {
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else { return }
        try? data.write(to: URL(fileURLWithPath: path))
    }
}

// Parse args and run
let args = CommandLine.arguments.reduce(into: [String: String]()) { result, arg in
    let parts = arg.split(separator: ":", maxSplits: 1)
    if parts.count == 2 {
        result[String(parts[0])] = String(parts[1])
    }
}
Script.main(args: args)
```

## Full CI Script

```bash
#!/bin/bash
set -euo pipefail

SIMULATOR_NAME="iPhone 16"
SIMULATOR_OS="18.0"

# Clean old results
rm -rf TestResults TestResults.xcresult allure-results

# Find and reset simulator
UDID=$(xcrun simctl list devices | grep "$SIMULATOR_NAME" | grep "$SIMULATOR_OS" | head -1 | awk -F '[()]' '{print $2}')
xcrun simctl shutdown "$UDID" || true
xcrun simctl erase "$UDID"

# Run tests
xcodebuild test \
  -workspace App.xcworkspace \
  -scheme App \
  -destination "platform=iOS Simulator,name=$SIMULATOR_NAME,OS=$SIMULATOR_OS" \
  -resultBundlePath TestResults || true

# Shutdown simulator
xcrun simctl shutdown "$UDID" || true

# Export to allure
./scripts/xcresults export TestResults.xcresult allure-results

# Cleanup
swift run --package-path ./scripts/cleanup-allure-report cleanup-allure-report \
  source:./allure-results suiteToRemove:app-uitest

# Upload
allurectl upload allure-results \
  --endpoint "$ALLURE_ENDPOINT" \
  --project-id "$ALLURE_PROJECT_ID" \
  --token "$ALLURE_TOKEN" \
  --launch-name "iOS $(date +'%Y-%m-%d %H:%M')"

# Cleanup
rm -rf allure-results
echo "Done!"
```
