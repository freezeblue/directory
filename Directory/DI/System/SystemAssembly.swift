import Foundation
import Swinject
import UIKit

struct SystemAssembly: Assembly {
    func assemble(container: Container) {
        container.register(URLSessionProtocol.self) { _ in URLSession.shared }.inObjectScope(.container)
        container.register(UIWindow.self) { _ in
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.makeKeyAndVisible()
            return window
        }.inObjectScope(.container)
    }
}
