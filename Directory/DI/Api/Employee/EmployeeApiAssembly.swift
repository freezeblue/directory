import Foundation
import Swinject

struct EmployeeApiAssembly: Assembly {
    func assemble(container: Container) {
        container.register(GetEmployeeApi.self) { _ in GetEmployeeApi() }.inObjectScope(.transient)
    }
}
