import XCTest
@testable import Directory

class BaseTableViewDataTests: XCTestCase {
    var data: BaseTableViewData<StubViewModel, StubCell>!
    let sections = ["1", "2"]
    static let vm1 = StubViewModel()
    static let vm2 = StubViewModel()
    static let vm3 = StubViewModel()
    let cells = ["1": [vm1, vm2], "2": [vm3]]
    let tableView = UITableView()

    override func setUpWithError() throws {
        data = BaseTableViewData(sections: sections, cells: cells)
        tableView.register(StubCell.self, forCellReuseIdentifier: StubCell.id)
    }

    func testSectionNumber() throws {
        XCTAssertEqual(data.numberOfSections(in: tableView), 2)
    }

    func testSectionTitle() throws {
        XCTAssertEqual(data.tableView(tableView, titleForHeaderInSection: 0), "1")
        XCTAssertEqual(data.tableView(tableView, titleForHeaderInSection: 1), "2")
    }

    func testNumbersInSection() throws {
        XCTAssertEqual(data.tableView(tableView, numberOfRowsInSection: 0), 2)
        XCTAssertEqual(data.tableView(tableView, numberOfRowsInSection: 1), 1)
    }

    func testCell() throws {
        let cell1 = data.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! StubCell
        let cell2 = data.tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 0)) as! StubCell
        let cell3 = data.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 1)) as! StubCell

        XCTAssertTrue(cell1.vm as? StubViewModel === BaseTableViewDataTests.vm1)
        XCTAssertTrue(cell2.vm as? StubViewModel === BaseTableViewDataTests.vm2)
        XCTAssertTrue(cell3.vm as? StubViewModel === BaseTableViewDataTests.vm3)
    }

    func testDataDrained() throws {
        let waitForSignal = expectation(description: "waitForSignal")

        data.dataDrainedSignal.connect() {
            waitForSignal.fulfill()
        }

        let cell3 = data.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 1)) as! StubCell
        data.tableView(tableView, willDisplay: cell3, forRowAt: IndexPath(row: 0, section: 1))

        wait(for: [waitForSignal], timeout: 0.1)
    }

    func testCellSelection() throws {
        let waitForSignal = expectation(description: "waitForSignal")

        BaseTableViewDataTests.vm3.selectedSignal.connect() { _ in
            waitForSignal.fulfill()
        }

        data.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 1))

        wait(for: [waitForSignal], timeout: 0.1)
    }
}

class StubViewModel: BaseTableViewCellViewModel {

}

class StubCell: UITableViewCell, BaseTableViewCell {
    var vm: Any?
    static var id: String = "Stub"

    func configureWith<VIEWMODEL>(viewModel: VIEWMODEL) -> UITableViewCell where VIEWMODEL : BaseTableViewCellViewModel {
        vm = viewModel
        return self
    }
}
