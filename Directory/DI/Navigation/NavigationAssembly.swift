import Foundation
import Swinject
import UIKit

struct NavigationAssembly: Assembly {
    func assemble(container: Container) {
        container.register(Signal<NavCommand>.self) { _ in Signal<NavCommand>(.none) }.inObjectScope(.container)

        container.register(RouterProtocol.self) { Router(navSignal: $0.resolve(Signal<NavCommand>.self)!) }.inObjectScope(.container)
    }
}
