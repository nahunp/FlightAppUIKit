import UIKit
import Combine

final class FlightSearchViewController: UIViewController, UITableViewDelegate {
    
    private let viewModel: FlightSearchViewModel
    private var cancellables = Set<AnyCancellable>()
    private let searchTextSubject = PassthroughSubject<String, Never>()

    private let searchBar = UISearchBar()
    private let tableView = UITableView()

    init(viewModel: FlightSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.didSearch(query: "")
    }

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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height * 2 {
            let currentCount = viewModel.flightsValue.count
            viewModel.loadNextPageIfNeeded(currentIndex: currentCount - 1)
        }
    }

    private func bindViewModel() {
        viewModel.flightsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
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

extension FlightSearchViewController: UITableViewDataSource,UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.flightsValue.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let flight = viewModel.flightsValue[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlightCell", for: indexPath)
        cell.textLabel?.text = flight.callsign ?? "Unknown Flight"
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextSubject.send(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.didSearch(query: searchBar.text ?? "")
    }
}
