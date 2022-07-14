import Foundation
import UIKit
import Kingfisher

final class InfoCell: EmployeesListBaseCell, BaseTableViewCell {
    func configureWith<VIEWMODEL>(viewModel: VIEWMODEL) -> UITableViewCell {
        let vm = viewModel as! InfoCellViewModel
        title.text = vm.title
        message.text = vm.message
        setColor(vm.color)
        setIcon(defaultIcon: vm.icon)
        return self
    }

    static let id = "InfoCell"

    private lazy var title = UILabel()
    private lazy var message = UILabel()

    override func commonInit() {
        super.commonInit()

        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .preferredFont(forTextStyle: .headline)
        title.numberOfLines = 1
        title.lineBreakMode = .byTruncatingTail

        message.translatesAutoresizingMaskIntoConstraints = false
        message.font = .preferredFont(forTextStyle: .subheadline)
        message.numberOfLines = 0
        message.lineBreakMode = .byTruncatingTail

        addToLeftView(title)
        addToLeftView(message)
        addToLeftView(UIStackView())
    }
}
