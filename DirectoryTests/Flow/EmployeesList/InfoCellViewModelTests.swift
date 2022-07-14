import XCTest
@testable import Directory

class InfoCellViewModelTests: XCTestCase {

    let title = "1"
    let message = "2"
    let color = Color.regularCard
    let icon = Image.peopleIcon
    var vm: InfoCellViewModel!

    override func setUpWithError() throws {
        vm = InfoCellViewModel(title: title, message: message, color: color, icon: icon)
    }

    func testDataFiles() throws {
        XCTAssertEqual(vm.title, title)
        XCTAssertEqual(vm.message, message)
        XCTAssertEqual(vm.color, color)
        XCTAssertEqual(vm.icon, icon)
    }
}
