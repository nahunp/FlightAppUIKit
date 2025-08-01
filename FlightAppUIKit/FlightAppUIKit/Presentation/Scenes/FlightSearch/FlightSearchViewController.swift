import UIKit
import Combine

final class FlightSearchViewController: UIViewController, UITableViewDelegate {

    // MARK: - Properties
    private let viewModel: FlightSearchViewModel
    private var cancellables = Set<AnyCancellable>()
    private let searchTextSubject = PassthroughSubject<String, Never>()

    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private var flights: [Flight] = []

    // MARK: - Init
    init(viewModel: FlightSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.didSearch(query: "")
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground

        searchBar.delegate = self
        searchBar.placeholder = "Enter airport code"
        navigationItem.titleView = searchBar

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FlightCell")
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    // MARK: - Bindings
    private func bindViewModel() {
        viewModel.flightsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] flights in
                self?.flights = flights
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        searchTextSubject
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.viewModel.didSearch(query: text)
            }
            .store(in: &cancellables)
    }
}

// MARK: - UIScrollViewDelegate
extension FlightSearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height * 2 {
            viewModel.loadNextPageIfNeeded(currentIndex: flights.count - 1)
        }
    }
}

// MARK: - UITableViewDataSource
extension FlightSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flights.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let flight = flights[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlightCell", for: indexPath)
        cell.textLabel?.text = flight.callsign ?? "Unknown Flight"
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension FlightSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextSubject.send(searchText)
    }
}
