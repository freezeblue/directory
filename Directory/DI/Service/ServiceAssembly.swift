import Foundation
import Swinject

struct ServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HttpProtocol.self) { HttpClient(session: $0.resolve(URLSessionProtocol.self)!) }.inObjectScope(.container)
    }
}
