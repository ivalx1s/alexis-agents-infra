import XCTest

extension UITest {
    @MainActor
    struct PageManager {
        let app: XCUIApplication

        // Add pages here
        let exampleInitial: UITest.Page.Example.Initial

        init(args: [String] = [], env: [String: String] = [:], orientation: UIDeviceOrientation = .portrait) {
            // Force orientation before launch to ensure correct screenshot capture
            XCUIDevice.shared.orientation = orientation

            let app = XCUIApplication()
            app.launchArguments = [UITest.Args.uiTestContext] + args
            app.launchEnvironment = env
            app.launch()

            self.app = app
            self.exampleInitial = .init(app: app)
        }

        func terminateApp() {
            app.terminate()
        }

        func relaunchApp(args: [String] = [], env: [String: String] = [:], orientation: UIDeviceOrientation = .portrait) {
            XCUIDevice.shared.orientation = orientation
            app.launchArguments = [UITest.Args.uiTestContext] + args
            app.launchEnvironment = env
            app.launch()
        }
    }
}
