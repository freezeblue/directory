import Foundation
import UIKit

protocol RouterProtocol {
    func initialize(with window: UIWindow)
}

final class Router: RouterProtocol {
    private lazy var navController = UINavigationController()
    private let navSignal: Signal<NavCommand>

    init(navSignal: Signal<NavCommand>) {
        self.navSignal = navSignal
    }

    func initialize(with window: UIWindow) {
        window.rootViewController = navController
        navSignal.connect() { [weak self] in
            self?.handleNavCommand($0)
        }
    }

    private func handleNavCommand(_ command: NavCommand) {
        switch command {
        case .none:
            break// Nothing to do
        case .back:
            navController.popViewController(animated: true)
        case .push(let navData):
            if let vc = getViewController(from: navData) {
                navController.pushViewController(vc, animated: true)
            }
        case .popup(let navData):
            if let vc = getViewController(from: navData) {
                navController.topViewController?.present(vc, animated: true)
            }
        case .home:
            if let root = navController.viewControllers.first {
                navController.popToViewController(root, animated: true)
            }
        case .newHome(let navData):
            if let vc = getViewController(from: navData) {
                navController.setViewControllers([vc], animated: true)
            }
        }
    }

    private func getViewController(from data: NavData) -> UIViewController? {
        return DIProvider.shared.container.resolve(NavDestination.self, name: data.destination)?.onArrive(with: data.payload)
    }
}
