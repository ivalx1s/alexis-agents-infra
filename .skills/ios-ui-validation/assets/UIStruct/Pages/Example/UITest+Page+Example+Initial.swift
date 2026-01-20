import XCTest

extension UITest.Page.Example {
    struct Initial: UITest.PageElement {
        private let page: XCUIElement
        private let actionButton: XCUIElement

        init(app: XCUIApplication) {
            self.page = app.otherElements[UITest.Identifier.Example.Initial.page]
            self.actionButton = app.buttons[UITest.Identifier.Example.Initial.action_btn]
        }

        func waitForAppear() {
            XCTAssert(page.waitForExistence(timeout: UITest.Consts.Timeouts.medium),
                      "Example initial page didn't appear")
        }

        func tapActionButton() {
            actionButton.tap()
        }
    }
}
