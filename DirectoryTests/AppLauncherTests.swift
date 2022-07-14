import XCTest
import Swinject
@testable import Directory

class AppLauncherTests: XCTestCase {
    var window = UIWindow()
    var router: MockRouter!
    var navSignal: Signal<NavCommand>!

    var launcher: AppLauncher!

    override func setUpWithError() throws {
        router = MockRouter()
        navSignal = Signal<NavCommand>(.none)
        launcher = AppLauncher(window: window, router: router)

        setUpContainer()
    }

    private func setUpContainer() {
        let container = Container()

        container.register(Signal<NavCommand>.self) { _ in self.navSignal }.inObjectScope(.container)

        DIProvider.shared.container = container
    }

    func testLaunch() throws {
        let waitForSignal = expectation(description: "waitForSignal")

        navSignal.connect() { command in
            if case .newHome(let data) = command {
                XCTAssertEqual(data.destination, Screen.employeesList)
                XCTAssertNil(data.payload)
            } else {
                XCTFail("wrong NavCommand")
            }

            waitForSignal.fulfill()
        }

        launcher.launch()

        XCTAssertEqual(router.initializeCalledTimes, 1)

        wait(for: [waitForSignal], timeout: 0.1)
    }
}
