import XCTest
import Swinject
@testable import Directory

class EmployeesListViewModelTests: XCTestCase {
    var mockRepo: MockEmployeeListRepository!
    var vm: EmployeesListViewModel!
    let tableView = UITableView()
    let employee = Employee(id: "1", name: "2", phone: "3", email: "4", biography: "5", photoUrlSmall: "6", photoUrlLarge: "7", team: "8", type: "9")
    let employee2 = Employee(id: "1", name: "3", phone: "3", email: "4", biography: "5", photoUrlSmall: "6", photoUrlLarge: "7", team: "8", type: "9")

    override func setUpWithError() throws {
        mockRepo = MockEmployeeListRepository()
        tableView.register(EmployeeCell.self, forCellReuseIdentifier: EmployeeCell.id)
        tableView.register(InfoCell.self, forCellReuseIdentifier: InfoCell.id)
        vm = EmployeesListViewModel(employeeRepository: mockRepo)
    }

    func testMultipleFetch() throws {
        let waitForSignal = expectation(description: "waitForSignal")
        mockRepo.employeesToReturn = nil

        vm.viewStateSignal.connect { state in
            if case EmployeesListViewState.error = state {
                waitForSignal.fulfill()
            }
        }

        vm.fetch()
        vm.fetch()
        vm.fetch()
        vm.fetch()

        wait(for: [waitForSignal], timeout: 1.1)

        XCTAssertEqual(mockRepo.getEmployeesCalledTimes, 1)
    }

    func testNilEmployee() throws {
        let waitForSignal = expectation(description: "waitForSignal")
        mockRepo.employeesToReturn = nil

        vm.viewStateSignal.connect { state in
            if case EmployeesListViewState.error(let ds) = state {
                XCTAssertEqual(ds.numberOfSections(in: self.tableView), 1)
                XCTAssertEqual(ds.tableView(self.tableView, numberOfRowsInSection: 0), 1)
                XCTAssertEqual(ds.tableView(self.tableView, titleForHeaderInSection: 0), "")
                XCTAssertTrue(ds.tableView(self.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) is InfoCell)

                let infoCell = ds.tableView(self.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! InfoCell
                let titleLable: UILabel = infoCell.contentView.subviews.first!.subviews.first!.subviews.first!.subviews.first! as! UILabel
                let messageLable: UILabel = infoCell.contentView.subviews.first!.subviews.first!.subviews.first!.subviews[1] as! UILabel
                XCTAssertEqual(titleLable.text, "There is a Glitch")
                XCTAssertEqual(messageLable.text, "We are having trouble retrieving the directory. Please try again later.")

                XCTAssertEqual(self.vm.title, "Oops...")
                XCTAssertEqual(self.vm.backgroundColor, UIColor(hex: 0xFDAAAA))

                waitForSignal.fulfill()
            }
        }

        vm.fetch()

        wait(for: [waitForSignal], timeout: 1.1)
    }

    func testEmptyEmployee() throws {
        let waitForSignal = expectation(description: "waitForSignal")
        mockRepo.employeesToReturn = []

        vm.viewStateSignal.connect { state in
            if case EmployeesListViewState.empty(let ds) = state {
                XCTAssertEqual(ds.numberOfSections(in: self.tableView), 1)
                XCTAssertEqual(ds.tableView(self.tableView, numberOfRowsInSection: 0), 1)
                XCTAssertEqual(ds.tableView(self.tableView, titleForHeaderInSection: 0), "")
                XCTAssertTrue(ds.tableView(self.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) is InfoCell)

                let infoCell = ds.tableView(self.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! InfoCell
                let titleLable: UILabel = infoCell.contentView.subviews.first!.subviews.first!.subviews.first!.subviews.first! as! UILabel
                let messageLable: UILabel = infoCell.contentView.subviews.first!.subviews.first!.subviews.first!.subviews[1] as! UILabel
                XCTAssertEqual(titleLable.text, "So Empty Here")
                XCTAssertEqual(messageLable.text, "Hurry up! Don't slow down. Hire Tim Guo to fill the office :)")

                XCTAssertEqual(self.vm.title, "Empty Office")
                XCTAssertEqual(self.vm.backgroundColor, UIColor(hex: 0xFDAAAA))
                
                waitForSignal.fulfill()
            }
        }

        vm.fetch()

        wait(for: [waitForSignal], timeout: 1.1)
    }

    func testHasEmployee() throws {
        let waitForSignal = expectation(description: "waitForSignal")
        mockRepo.employeesToReturn = [employee, employee2]

        vm.viewStateSignal.connect { state in
            if case EmployeesListViewState.ready(let ds) = state {
                XCTAssertEqual(ds.numberOfSections(in: self.tableView), 1)
                XCTAssertEqual(ds.tableView(self.tableView, numberOfRowsInSection: 0), 2)
                XCTAssertEqual(ds.tableView(self.tableView, titleForHeaderInSection: 0), self.employee.team)
                XCTAssertTrue(ds.tableView(self.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) is EmployeeCell)
                XCTAssertTrue(ds.tableView(self.tableView, cellForRowAt: IndexPath(row: 1, section: 0)) is EmployeeCell)

                let employeeCell = ds.tableView(self.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! EmployeeCell
                let nameLable: UILabel = employeeCell.contentView.subviews.first!.subviews.first!.subviews.first!.subviews.first! as! UILabel
                let teamLable: UILabel = employeeCell.contentView.subviews.first!.subviews.first!.subviews.first!.subviews[1] as! UILabel
                let emailLable: UILabel = employeeCell.contentView.subviews.first!.subviews.first!.subviews.first!.subviews[2] as! UILabel
                let phoneLable: UILabel = employeeCell.contentView.subviews.first!.subviews.first!.subviews.first!.subviews[3] as! UILabel
                let icon: UIImageView = employeeCell.contentView.subviews.first!.subviews.first!.subviews[1] as! UIImageView

                XCTAssertEqual(nameLable.text, self.employee.name)
                XCTAssertEqual(teamLable.text, self.employee.team)
                XCTAssertEqual(emailLable.text, self.employee.email)
                XCTAssertEqual(phoneLable.text, self.employee.phone)
                XCTAssertEqual(icon.image, Image.peopleIcon)

                XCTAssertEqual(self.vm.title, "Block's Employees")
                XCTAssertEqual(self.vm.backgroundColor, UIColor(hex: 0xADD4DE))
                
                waitForSignal.fulfill()
            }
        }

        vm.fetch()

        wait(for: [waitForSignal], timeout: 1.1)
    }

    func testDataDrained() throws {
        let waitForSignal = expectation(description: "waitForSignal")
        mockRepo.employeesToReturn = [employee, employee2]

        vm.viewStateSignal.connect { state in
            if case EmployeesListViewState.ready(let ds) = state {
                // Access the last item
                ds.tableView(self.tableView, willDisplay: UITableViewCell(), forRowAt: IndexPath(row: 1, section: 0))
            }

            if case EmployeesListViewState.drained = state {
                waitForSignal.fulfill()
            }
        }

        vm.fetch()

        wait(for: [waitForSignal], timeout: 1.1)
    }
}
