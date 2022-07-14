import XCTest
import Swinject
@testable import Directory

class RouterTests: XCTestCase {
    var container: Container!
    let vcA = UIViewController()
    let vcB = UIViewController()
    let window = UIWindow(frame: UIScreen.main.bounds)
    let signal = Signal<NavCommand>(.none)
    let payload = "dummy payload"

    var router: Router!

    override func setUpWithError() throws {
        setUpContainer()
        window.makeKeyAndVisible()
        router = Router(navSignal: signal)
        router.initialize(with: window)
    }

    private func setUpContainer() {
        container = Container()

        container.register(NavDestination.self, name: "A") { _ in MockDestination(self.vcA) }.inObjectScope(.container)
        container.register(NavDestination.self, name: "B") { _ in MockDestination(self.vcB) }.inObjectScope(.container)

        DIProvider.shared.container = container
    }

    private func getNavController() -> UINavigationController {
        return window.rootViewController as! UINavigationController
    }

    func testNothing() throws {
        XCTAssertEqual(getNavController().viewControllers.count, 0)
    }

    func testNewHomeFromNothing() throws {
        signal.emit(.newHome(NavData(destination: "A", payload: payload)))
        XCTAssertEqual(getNavController().viewControllers.count, 1)
        XCTAssertEqual(getNavController().viewControllers.first!, vcA)

        let receivedPayload = (container.resolve(NavDestination.self, name: "A") as! MockDestination).payloadArrived
        XCTAssertEqual(receivedPayload as! String, payload)
    }

    func testNone() throws {
        signal.emit(.newHome(NavData(destination: "A", payload: payload)))
        signal.emit(.none)
        XCTAssertEqual(getNavController().viewControllers.count, 1)
        XCTAssertEqual(getNavController().viewControllers.first!, vcA)

        let receivedPayload = (container.resolve(NavDestination.self, name: "A") as! MockDestination).payloadArrived
        XCTAssertEqual(receivedPayload as! String, payload)
    }

    func testNewHome() throws {
        let waitForUItransition = expectation(description: "waitForUItransition")
        waitForUItransition.isInverted = true

        signal.emit(.newHome(NavData(destination: "A", payload: nil)))
        signal.emit(.newHome(NavData(destination: "B", payload: payload)))

        wait(for: [waitForUItransition], timeout: 0.1)

        XCTAssertEqual(getNavController().viewControllers.count, 1)
        XCTAssertTrue(getNavController().viewControllers.first! === vcB)

        let receivedPayload = (container.resolve(NavDestination.self, name: "B") as! MockDestination).payloadArrived
        XCTAssertEqual(receivedPayload as! String, payload)
    }

    func testPush() throws {
        let waitForUItransition = expectation(description: "waitForUItransition")
        waitForUItransition.isInverted = true

        signal.emit(.newHome(NavData(destination: "A", payload: nil)))
        signal.emit(.push(NavData(destination: "B", payload: payload)))

        wait(for: [waitForUItransition], timeout: 0.1)

        XCTAssertEqual(getNavController().viewControllers.count, 2)
        XCTAssertTrue(getNavController().viewControllers[0] === vcA)
        XCTAssertTrue(getNavController().viewControllers[1] === vcB)

        let receivedPayload = (container.resolve(NavDestination.self, name: "B") as! MockDestination).payloadArrived
        XCTAssertEqual(receivedPayload as! String, payload)
    }

    func testHome() throws {
        let waitForUItransition = expectation(description: "waitForUItransition")
        waitForUItransition.isInverted = true

        signal.emit(.newHome(NavData(destination: "A", payload: nil)))
        signal.emit(.push(NavData(destination: "B", payload: payload)))
        signal.emit(.home)

        wait(for: [waitForUItransition], timeout: 0.1)

        XCTAssertEqual(getNavController().viewControllers.count, 1)
        XCTAssertTrue(getNavController().viewControllers[0] === vcA)
    }

    func testBack() throws {
        let waitForUItransition = expectation(description: "waitForUItransition")
        waitForUItransition.isInverted = true

        signal.emit(.newHome(NavData(destination: "A", payload: nil)))
        signal.emit(.push(NavData(destination: "B", payload: payload)))
        signal.emit(.back)

        wait(for: [waitForUItransition], timeout: 0.1)

        XCTAssertEqual(getNavController().viewControllers.count, 1)
        XCTAssertTrue(getNavController().viewControllers[0] === vcA)
    }

    func testPopup() throws {
        let waitForUItransition = expectation(description: "waitForUItransition")
        waitForUItransition.isInverted = true

        signal.emit(.newHome(NavData(destination: "A", payload: nil)))
        signal.emit(.popup(NavData(destination: "B", payload: payload)))

        wait(for: [waitForUItransition], timeout: 0.1)

        XCTAssertEqual(getNavController().viewControllers.count, 1)
        XCTAssertTrue(getNavController().viewControllers[0] === vcA)
        XCTAssertTrue(vcA.presentedViewController === vcB)
    }
}
