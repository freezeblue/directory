import Foundation
import Swinject

class DIProvider {
    static let shared = DIProvider()

    var container = Container()
    let assember: Assembler

    private init() {
        assember = Assembler(
            [
                SystemAssembly(),
                ServiceAssembly(),
                ApiAssembly(),
                FlowAssembly(),
                NavigationAssembly(),
                AppAssembly()
            ],
            container: container
        )
    }
}
