import Foundation
import UIKit

class BaseTableViewData<VIEWMODEL: BaseTableViewCellViewModel, CELL: BaseTableViewCell>: NSObject, UITableViewDataSource, UITableViewDelegate {
    private let sections: [String]
    private let cells: [String: [VIEWMODEL]]
    let dataDrainedSignal = Signal<Void>(())

    init(sections: [String], cells: [String: [VIEWMODEL]]) {
        self.sections = sections
        self.cells = cells
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells[sections[section]]!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = cells[sections[indexPath.section]]![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL.id, for: indexPath) as! CELL
        return cell.configureWith(viewModel: viewModel)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section]
    }

    // Delegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == sections.count - 1 && indexPath.row == cells[sections[indexPath.section]]!.count - 1{
            dataDrainedSignal.emit()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = cells[sections[indexPath.section]]![indexPath.row]
        viewModel.select()
    }
}
