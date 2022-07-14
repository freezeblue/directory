import Foundation
import Swinject

struct FlowAssembly: Assembly {
    func assemble(container: Container) {
        let assemblies: [Assembly] = [
            EmployeesListAssembly()
        ]
        assemblies.forEach { $0.assemble(container: container) }
    }
}
