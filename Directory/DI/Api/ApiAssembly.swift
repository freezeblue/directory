import Foundation
import Swinject

struct ApiAssembly: Assembly {
    func assemble(container: Container) {
        let assemblies: [Assembly] = [
            EmployeeApiAssembly()
        ]
        assemblies.forEach { $0.assemble(container: container) }
    }
}
