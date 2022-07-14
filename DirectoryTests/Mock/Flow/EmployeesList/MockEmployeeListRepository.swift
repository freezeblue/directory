import Foundation
@testable import Directory

class MockEmployeeListRepository: EmployeeListRepositoryProtocol {
    var getEmployeesCalledTimes = 0
    var employeesToReturn: [Employee]?
    func getEmployees(callback: @escaping EmployeeCallback) {
        getEmployeesCalledTimes += 1
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                callback(self.employeesToReturn)
            }
        }
    }
}
