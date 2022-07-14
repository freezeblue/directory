import Foundation
import Swinject
import UIKit

struct AppAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AppLauncher.self) { AppLauncher(window: $0.resolve(UIWindow.self)!, router: $0.resolve(RouterProtocol.self)!) }.inObjectScope(.transient)
    }
}
