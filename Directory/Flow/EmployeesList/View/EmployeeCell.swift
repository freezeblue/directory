import Foundation
import UIKit
import Kingfisher

final class EmployeeCell: EmployeesListBaseCell, BaseTableViewCell {
    func configureWith<VIEWMODEL>(viewModel: VIEWMODEL) -> UITableViewCell {
        let vm = viewModel as! EmployeeCellViewModel
        name.text = vm.name
        team.text = vm.team
        email.text = vm.email
        phone.text = vm.phone
        setIcon(URL(string: vm.photoUrl), defaultIcon: Image.peopleIcon)
        setColor(vm.color)
        return self
    }

    static let id = "EmployeeCel"

    private lazy var name = UILabel()
    private lazy var team = UILabel()
    private lazy var email = UILabel()
    private lazy var phone = UILabel()

    override func commonInit() {
        super.commonInit()

        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = .preferredFont(forTextStyle: .headline)
        name.numberOfLines = 1
        name.lineBreakMode = .byTruncatingTail

        team.translatesAutoresizingMaskIntoConstraints = false
        team.font = .preferredFont(forTextStyle: .subheadline)
        team.numberOfLines = 1
        team.lineBreakMode = .byTruncatingTail

        email.translatesAutoresizingMaskIntoConstraints = false
        email.font = .preferredFont(forTextStyle: .subheadline)
        email.numberOfLines = 1
        email.lineBreakMode = .byTruncatingTail

        phone.translatesAutoresizingMaskIntoConstraints = false
        phone.font = .preferredFont(forTextStyle: .subheadline)
        phone.numberOfLines = 1
        phone.lineBreakMode = .byTruncatingTail

        addToLeftView(name)
        addToLeftView(team)
        addToLeftView(email)
        addToLeftView(phone)
    }
}
