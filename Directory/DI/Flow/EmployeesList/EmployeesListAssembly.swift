import Foundation
import Swinject
import UIKit

struct EmployeesListAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NavDestination.self, name: Screen.employeesList) { _ in EmployeesListNavigator() }.inObjectScope(.transient)

        container.register(EmployeeListRepositoryProtocol.self) { EmployeeListRepository(http: $0.resolve(HttpProtocol.self)!) }.inObjectScope(.transient)

        container.register(EmployeesListViewModel.self) { EmployeesListViewModel(employeeRepository: $0.resolve(EmployeeListRepositoryProtocol.self)!) }.inObjectScope(.transient)
    }
}
