import Foundation

typealias EmployeeCallback = ([Employee]?) -> Void

protocol EmployeeListRepositoryProtocol {
    func getEmployees(callback: @escaping EmployeeCallback)
}

final class EmployeeListRepository: EmployeeListRepositoryProtocol {
    private let http: HttpProtocol
    private lazy var employeeCallbacks = [EmployeeCallback]()
    private var getEmployeesWorking = false

    init(http: HttpProtocol) {
        self.http = http
    }

    func getEmployees(callback: @escaping EmployeeCallback) {
        employeeCallbacks.append(callback)

        guard !getEmployeesWorking else {
            return
        }

        getEmployeesWorking = true

        http.request(GetEmployeeApi()) { [weak self] (employees: Employees?, error: HttpError?) -> Void in
            guard error == nil, employees != nil else {
                self?.sendEmployees(nil)
                return
            }

            self?.sendEmployees(employees!.employees)
        }
    }

    private func sendEmployees(_ employees: [Employee]?) {
        DispatchQueue.main.async {
            self.employeeCallbacks.forEach { $0(employees) }
            self.employeeCallbacks.removeAll()
            self.getEmployeesWorking = false
        }
    }
}
