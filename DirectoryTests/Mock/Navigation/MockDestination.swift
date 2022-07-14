import Foundation
@testable import Directory
import UIKit

class MockDestination: NavDestination {
    let vcToReturn: UIViewController
    var payloadArrived: Any?

    static var id: String = "MOCK"

    init(_ vc: UIViewController) {
        vcToReturn = vc
    }

    func onArrive(with data: Any?) -> UIViewController {
        payloadArrived = data
        return vcToReturn
    }
}
