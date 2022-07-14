import Foundation
import UIKit

final class EmployeesListNavigator: NavSource, NavDestination {
    static var id: String = Screen.employeesList

    func onArrive(with data: Any?) -> UIViewController {
        let viewModel = DIProvider.shared.container.resolve(EmployeesListViewModel.self)!
        viewModel.employeeSelectedSignal.connect(goToEmplyeeDetailScreen)
        return EmployeesListViewController.instantiate(with: viewModel)
    }

    func goToEmplyeeDetailScreen(_ employee: Any?) {
        print("\((employee as! Employee).name) selected.")
        sendNavCommand(.push(NavData(destination: Screen.employeesDetail, payload: employee)))
    }
}
