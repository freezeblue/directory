import Foundation
import UIKit

final class AppLauncher: NavSource {
    init(window: UIWindow, router: RouterProtocol) {
        router.initialize(with: window)
    }

    func launch() {
       sendNavCommand(.newHome(NavData(destination: Screen.employeesList, payload: nil)))
    }
}
