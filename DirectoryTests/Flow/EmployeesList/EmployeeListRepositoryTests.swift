import XCTest
@testable import Directory

class EmployeeListRepositoryTests: XCTestCase {
    let emptyData = """
        {
            "employees" : []
        }
    """

    let wrongData = """
        {
            "abcd" : []
        }
    """

    let rightData = """
    {
        "employees" : [
            {
          "uuid" : "0d8fcc12-4d0c-425c-8355-390b312b909c",

          "full_name" : "Justine Mason",
          "phone_number" : "5553280123",
          "email_address" : "jmason.demo@squareup.com",
          "biography" : "Engineer on the Point of Sale team.",

          "photo_url_small" : "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/small.jpg",
          "photo_url_large" : "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/large.jpg",

          "team" : "Point of Sale",
          "employee_type" : "FULL_TIME"
        },

        {
          "uuid" : "a98f8a2e-c975-4ba3-8b35-01f719e7de2d",

          "full_name" : "Camille Rogers",
          "phone_number" : "5558531970",
          "email_address" : "crogers.demo@squareup.com",
          "biography" : "Designer on the web marketing team.",

          "photo_url_small" : "https://s3.amazonaws.com/sq-mobile-interview/photos/5095a907-abc9-4734-8d1e-0eeb2506bfa8/small.jpg",
          "photo_url_large" : "https://s3.amazonaws.com/sq-mobile-interview/photos/5095a907-abc9-4734-8d1e-0eeb2506bfa8/large.jpg",

          "team" : "Public Web & Marketing",
          "employee_type" : "PART_TIME"
        }
      ]
    }
    """

    let mockHttp = MockHttp()
    var repo: EmployeeListRepositoryProtocol!

    override func setUpWithError() throws {
        repo = EmployeeListRepository(http: mockHttp)
    }

    func testEmptyData() throws {
        let waitForSignal = expectation(description: "waitForSignal")
        mockHttp.responseToReturn = try JSONDecoder().decode(Employees.self, from: emptyData.data(using: .utf8)!)

        repo.getEmployees() {
            XCTAssertTrue($0!.isEmpty)
            waitForSignal.fulfill()
        }

        wait(for: [waitForSignal], timeout: 1.1)
    }

    func testRightData() throws {
        let waitForSignal = expectation(description: "waitForSignal")
        mockHttp.responseToReturn = try JSONDecoder().decode(Employees.self, from: rightData.data(using: .utf8)!)

        repo.getEmployees() {
            XCTAssertEqual($0!.count, 2)
            waitForSignal.fulfill()
        }

        wait(for: [waitForSignal], timeout: 1.1)
    }

    func testRightDataWithError() throws {
        let waitForSignal = expectation(description: "waitForSignal")
        mockHttp.responseToReturn = try JSONDecoder().decode(Employees.self, from: rightData.data(using: .utf8)!)
        mockHttp.errorToReturn = .clientError(reason: "unknown")

        repo.getEmployees() {
            XCTAssertNil($0)
            waitForSignal.fulfill()
        }

        wait(for: [waitForSignal], timeout: 1.1)
    }

    func testWrongData() throws {
        let waitForSignal = expectation(description: "waitForSignal")
        mockHttp.responseToReturn = try? JSONDecoder().decode(Employees.self, from: wrongData.data(using: .utf8)!)

        repo.getEmployees() {
            XCTAssertNil($0)
            waitForSignal.fulfill()
        }

        wait(for: [waitForSignal], timeout: 1.1)
    }

    func testHttpError() throws {
        let waitForSignal = expectation(description: "waitForSignal")
        mockHttp.errorToReturn = .networkError(code: 404)

        repo.getEmployees() {
            XCTAssertNil($0)
            waitForSignal.fulfill()
        }

        wait(for: [waitForSignal], timeout: 1.1)
    }

    func testClientError() throws {
        let waitForSignal = expectation(description: "waitForSignal")
        mockHttp.errorToReturn = .clientError(reason: "unknown")

        repo.getEmployees() {
            XCTAssertNil($0)
            waitForSignal.fulfill()
        }

        wait(for: [waitForSignal], timeout: 1.1)
    }

    func testMultipleCall() throws {
        let waitForSignal = expectation(description: "waitForSignal")
        waitForSignal.isInverted = true
        mockHttp.errorToReturn = .clientError(reason: "unknown")

        repo.getEmployees() {_ in }
        repo.getEmployees() {_ in }
        repo.getEmployees() {_ in }
        repo.getEmployees() {_ in }
        repo.getEmployees() {_ in }

        wait(for: [waitForSignal], timeout: 1.1)

        XCTAssertEqual(mockHttp.getCalledTimes, 1)
    }

}
