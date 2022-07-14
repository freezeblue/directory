import XCTest
@testable import Directory

class EmployeeApiTests: XCTestCase {
    private static let expectedApis = Set([
        "sq-mobile-interview/employees.json",
        "sq-mobile-interview/employees_malformed.json",
        "sq-mobile-interview/employees_empty.json"
    ])

    func testGetEmployeeApi() {
        let api = GetEmployeeApi()
        XCTAssertTrue(EmployeeApiTests.expectedApis.contains(api.path))
        XCTAssertEqual(api.server, "https://s3.amazonaws.com/")
        XCTAssertEqual(api.method, "GET")
        XCTAssertEqual(api.headers, nil)
        XCTAssertEqual(api.body, nil)
    }
}
