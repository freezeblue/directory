import XCTest
@testable import Directory

class EmployeeDataTests: XCTestCase {
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

    let goodData = """
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

    func testWrongData() throws {
        do {
            _ = try JSONDecoder().decode(Employees.self, from: wrongData.data(using: .utf8)!)
            XCTFail("Should throw")
        } catch {
            // Success
        }
    }

    func testEmptyData() throws {
        let employees = try JSONDecoder().decode(Employees.self, from: emptyData.data(using: .utf8)!)
        XCTAssertTrue(employees.employees.isEmpty)
    }

    func testGoodData() throws {
        let employees = try JSONDecoder().decode(Employees.self, from: goodData.data(using: .utf8)!)
        XCTAssertEqual(employees.employees.count, 2)
        XCTAssertEqual(employees.employees[0].id, "0d8fcc12-4d0c-425c-8355-390b312b909c")
        XCTAssertEqual(employees.employees[1].id, "a98f8a2e-c975-4ba3-8b35-01f719e7de2d")
    }
}
