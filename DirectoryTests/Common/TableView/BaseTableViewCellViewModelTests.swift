import XCTest
@testable import Directory

class BaseTableViewCellViewModelTests: XCTestCase {

    func testSelect() throws {
        let waitForSignal = expectation(description: "waitForSignal")
        let vm = BaseTableViewCellViewModel(data: "test")

        vm.selectedSignal.connect() { data in
            XCTAssertEqual(data as! String, "test")
            waitForSignal.fulfill()
        }

        vm.select()

        wait(for: [waitForSignal], timeout: 0.1)
    }

    func testGetData() throws {

        let vm = BaseTableViewCellViewModel(data: "test")
        XCTAssertEqual(vm.getData(type: String.self), "test")
    }
}
