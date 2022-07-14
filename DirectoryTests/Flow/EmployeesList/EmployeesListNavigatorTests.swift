import XCTest
import Swinject
@testable import Directory

class EmployeesListNavigatorTests: XCTestCase {
    var navigator: EmployeesListNavigator!
    let signal = Signal<NavCommand>(.none)

    override func setUpWithError() throws {
        setUpContainer()
        navigator = EmployeesListNavigator()
    }

    private func setUpContainer() {
        let container = Container()

        container.register(Signal<NavCommand>.self) { _ in self.signal }.inObjectScope(.container)
        container.register(EmployeeListRepositoryProtocol.self) { _ in MockEmployeeListRepository() }.inObjectScope(.container)
        container.register(EmployeesListViewModel.self) { EmployeesListViewModel(employeeRepository: $0.resolve(EmployeeListRepositoryProtocol.self)!) }.inObjectScope(.container)

        DIProvider.shared.container = container
    }

    func testOnArrive() throws {
        let vc = navigator.onArrive(with: nil)
        XCTAssertTrue(vc is EmployeesListViewController)
    }

    func testgoToEmplyeeDetailScreen() {
        _ = navigator.onArrive(with: nil)

        let waitForSignal = expectation(description: "waitForSignal")
        let employee = Employee(id: "1", name: "1", phone: "1", email: "1", biography: "1", photoUrlSmall: "1", photoUrlLarge: "1", team: "1", type: "1")


        signal.connect() {
            if case .push(let navData) = $0 {
                XCTAssertEqual(navData.destination, Screen.employeesDetail)
                XCTAssertEqual(navData.payload as! Employee, employee)
            } else {
                XCTFail("wrong NavCommand")
            }

            waitForSignal.fulfill()
        }

        let vm = DIProvider.shared.container.resolve(EmployeesListViewModel.self)
        vm!.employeeSelectedSignal.emit(employee)

        wait(for: [waitForSignal], timeout: 0.1)
    }
}
