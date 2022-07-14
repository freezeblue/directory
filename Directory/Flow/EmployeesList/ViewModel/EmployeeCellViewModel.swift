import Foundation
import UIKit

final class EmployeeCellViewModel: BaseTableViewCellViewModel {
    let color: UIColor

    init(employee: Employee, color: UIColor) {
        self.color = color
        super.init(data: employee)
    }

    var name: String {
        return employee.name
    }

    var photoUrl: String {
        return employee.photoUrlSmall
    }

    var team: String {
        return employee.team
    }

    var email: String {
        return employee.email
    }

    var phone: String {
        return employee.phone
    }

    private var employee: Employee {
        return getData(type: Employee.self)!
    }
}
