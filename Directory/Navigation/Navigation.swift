import Foundation
import UIKit

enum NavCommand {
    case none
    case back
    case push(NavData)
    case popup(NavData)
    case home
    case newHome(NavData)
}

struct NavData {
    let destination: String
    let payload: Any?
}

protocol NavDestination {
    static var id: String { get }
    func onArrive(with data: Any?) -> UIViewController
}

protocol NavSource {
    func sendNavCommand(_ command: NavCommand)
}

extension NavSource {
    private var navSignal: Signal<NavCommand> {
        return DIProvider.shared.container.resolve(Signal<NavCommand>.self)!
    }

    func sendNavCommand(_ command: NavCommand) {
        navSignal.emit(command)
    }
}
