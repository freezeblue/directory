import UIKit

final class EmployeesListViewController: UITableViewController {
    private var viewModel: EmployeesListViewModel!

    private var dataSource: UITableViewDataSource? {
        didSet {
            tableView.dataSource = dataSource
        }
    }

    private var delegate: UITableViewDelegate? {
        didSet {
            tableView.delegate = delegate
        }
    }

    class func instantiate(with viewModel: EmployeesListViewModel) -> EmployeesListViewController {
        let vc = EmployeesListViewController()
        vc.viewModel = viewModel
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupLoadingIndicator()
        updateView()
        refresh()
    }

    private func setupTableView() {
        tableView.register(EmployeeCell.self, forCellReuseIdentifier: EmployeeCell.id)
        tableView.register(InfoCell.self, forCellReuseIdentifier: InfoCell.id)

        tableView.separatorStyle = .none

        viewModel.viewStateSignal.connect() { [unowned self] in
            self.handleStateChange($0)
        }
    }

    private func setupLoadingIndicator() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl

        let indicator = UIActivityIndicatorView()
        indicator.style = .whiteLarge
        tableView.backgroundView = indicator
    }

    @objc private func refresh() {
        viewModel.fetch()
    }

    private func handleStateChange(_ newState: EmployeesListViewState) {
        switch newState {
        case .none:
            break;
        case .fetching(let initialFetch):
            if initialFetch {
                startInitialLoadingIndicator()
            }
        case .ready(let data):
            dataSource = data
            delegate = data
            stopAlllLoadingIndicator()
            updateView()
        case .empty(let data), .error(let data):
            dataSource = data
            delegate = data
            stopAlllLoadingIndicator()
            updateView()
        case .drained:
            handleDataDrained()
        }
    }

    private func handleDataDrained() {
        print("Please load more data...")
    }

    private func updateView() {
        tableView.backgroundColor = viewModel.backgroundColor
        navigationItem.title = viewModel.title
        tableView.reloadData()
    }

    private func startInitialLoadingIndicator() {
        (tableView.backgroundView as? UIActivityIndicatorView)?.startAnimating()
    }

    private func stopAlllLoadingIndicator() {
        (tableView.backgroundView as? UIActivityIndicatorView)?.stopAnimating()
        tableView.refreshControl?.endRefreshing()
    }
}
