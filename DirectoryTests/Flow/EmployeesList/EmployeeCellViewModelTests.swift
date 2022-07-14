import XCTest
@testable import Directory

class EmployeeCellViewModelTests: XCTestCase {
    let employee = Employee(id: "1", name: "2", phone: "3", email: "4", biography: "5", photoUrlSmall: "6", photoUrlLarge: "7", team: "8", type: "9")
    let color = Color.regularCard
    var vm: EmployeeCellViewModel!

    override func setUpWithError() throws {
        vm = EmployeeCellViewModel(employee: employee, color: color)
    }

    func testDataFiles() throws {
        XCTAssertEqual(vm.name, employee.name)
        XCTAssertEqual(vm.team, employee.team)
        XCTAssertEqual(vm.phone, employee.phone)
        XCTAssertEqual(vm.email, employee.email)
        XCTAssertEqual(vm.photoUrl, employee.photoUrlSmall)
    }
}
