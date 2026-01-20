extension UITest {
    enum Identifier {}
}

// MARK: - Example Module

extension UITest.Identifier {
    enum Example {
        enum Initial {
            static let page = "Example initial page"
            static let action_btn = "Example initial Action button"
        }
    }
}

// MARK: - Add your modules below
// Pattern: {Module} {Screen} {Element} {Action/State}
//
// extension UITest.Identifier {
//     enum Auth {
//         enum Initial {
//             static let login_btn = "Auth initial Login button"
//         }
//         enum PinWall {
//             enum Create {
//                 static let page = "Auth pin wall Create pin page"
//             }
//         }
//     }
// }
