import Foundation
import UIKit

enum EmployeesListViewState: Equatable {
    case none
    case fetching(initialFetch: Bool)
    case ready(data: BaseTableViewData<EmployeeCellViewModel, EmployeeCell>)
    case empty(data: BaseTableViewData<InfoCellViewModel, InfoCell>)
    case error(data: BaseTableViewData<InfoCellViewModel, InfoCell>)
    case drained
}

final class EmployeesListViewModel: NSObject, UITableViewDelegate {
    private(set) var title = Constants.screenTitle
    private(set) var backgroundColor = Color.regularBackground

    private let employeeRepository: EmployeeListRepositoryProtocol

    let viewStateSignal = Signal<EmployeesListViewState>(.none)
    let employeeSelectedSignal = Signal<Any?>(())

    private struct Constants {
        static let screenTitle = "Block's Employees"
        static let screenErrorTitle = "Oops..."
        static let screenEmptyTitle = "Empty Office"
        static let errorTitle = "There is a Glitch"
        static let errorMessage = "We are having trouble retrieving the directory. Please try again later."
        static let emptyTitle = "So Empty Here"
        static let emptyMessage = "Hurry up! Don't slow down. Hire Tim Guo to fill the office :)"
    }

    init(employeeRepository: EmployeeListRepositoryProtocol) {
        self.employeeRepository = employeeRepository
    }

    func fetch() {
        if case EmployeesListViewState.fetching = viewStateSignal.value {
            return
        }

        viewStateSignal.emit(.fetching(initialFetch: viewStateSignal.value == .none))
        employeeRepository.getEmployees() { [weak self] in
            self?.handleFetchResult($0)
        }
    }

    private func handleFetchResult(_ result: [Employee]?) {
        if let result = result, !result.isEmpty {
            viewStateSignal.emit(.ready(data: prepareReadyState(result)))
        } else if let result = result, result.isEmpty {
            viewStateSignal.emit(.empty(data: prepareEmptyState()))
        } else {
            viewStateSignal.emit(.error(data: prepareErrorState()))
        }
    }

    private func handleDataDrained() {
        viewStateSignal.emit(.drained)
    }

    private func prepareReadyState(_ employees: [Employee]) -> BaseTableViewData<EmployeeCellViewModel, EmployeeCell> {
        backgroundColor = Color.regularBackground
        title = Constants.screenTitle

        var teams = [String]()
        var employeesByTeam = [String: [EmployeeCellViewModel]]()

        employees.forEach { employee in
            if nil == employeesByTeam[employee.team] {
                employeesByTeam[employee.team] = []
            }
            let vm = EmployeeCellViewModel(employee: employee, color: Color.regularCard)
            employeeSelectedSignal.bind(to: vm.selectedSignal)
            employeesByTeam[employee.team]!.append(vm)
        }

        teams.append(contentsOf: employeesByTeam.keys)
        teams.sort()
        teams.forEach { employeesByTeam[$0]!.sort { $0.name < $1.name } }

        let readyStateData = BaseTableViewData<EmployeeCellViewModel, EmployeeCell>(sections: teams, cells: employeesByTeam)
        readyStateData.dataDrainedSignal.connect() { [unowned self] in
            self.handleDataDrained()
        }

        return readyStateData
    }

    private func prepareEmptyState() -> BaseTableViewData<InfoCellViewModel, InfoCell> {
        title = Constants.screenEmptyTitle
        backgroundColor = Color.infoBackground

        let viewModel = InfoCellViewModel(title: Constants.emptyTitle, message: Constants.emptyMessage, color: Color.infoCard, icon: Image.infoIcon)
        let emptyStateData = BaseTableViewData<InfoCellViewModel, InfoCell>(sections: [""], cells: ["": [viewModel]])

        return emptyStateData
    }

    private func prepareErrorState() -> BaseTableViewData<InfoCellViewModel, InfoCell> {
        title = Constants.screenErrorTitle
        backgroundColor = Color.infoBackground

        let viewModel = InfoCellViewModel(title: Constants.errorTitle, message: Constants.errorMessage, color: Color.errorCard, icon: Image.warningIcon)
        let errorStateData = BaseTableViewData<InfoCellViewModel, InfoCell>(sections: [""], cells: ["": [viewModel]])

        return errorStateData
    }
}
