import Foundation
import UIKit
@testable import Directory

class MockRouter: RouterProtocol {
    var initializeCalledTimes = 0
    func initialize(with window: UIWindow) {
        initializeCalledTimes += 1
    }
}
