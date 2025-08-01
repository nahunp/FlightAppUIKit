import Foundation
import Combine

final class FlightSearchViewModel: FlightSearchViewModelInput, FlightSearchViewModelOutput {

    // MARK: - Inputs
    @Published var searchQuery: String = ""

    // MARK: - Outputs
    var flightsPublisher: AnyPublisher<[Flight], Never> {
        flights.eraseToAnyPublisher()
    }

    // MARK: - Dependencies
    private let repository: FlightRepository
    weak var coordinator: FlightSearchCoordinator?

    // MARK: - State
    private var flights = CurrentValueSubject<[Flight], Never>([])
    private var cancellables = Set<AnyCancellable>()

    private var currentQuery: String = ""
    private var currentPage: Int = 0
    private var isLoading: Bool = false
    private var hasMorePages: Bool = true

    // MARK: - Init
    init(repository: FlightRepository, coordinator: FlightSearchCoordinator?) {
        self.repository = repository
        self.coordinator = coordinator
        bindSearch()
    }

    // MARK: - Private: Search Binding
    private func bindSearch() {
        $searchQuery
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] query in
                self?.didSearch(query: query)
            }
            .store(in: &cancellables)
    }

    // MARK: - Input Handling

    func didSearch(query: String) {
        currentQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        currentPage = 0
        hasMorePages = true
        flights.send([])
        fetchFlights(reset: true)
    }

    func loadNextPageIfNeeded(currentIndex: Int) {
        let threshold = flights.value.count - 5

        guard currentIndex >= threshold,
              !isLoading,
              hasMorePages else { return }

        currentPage += 1
        fetchFlights(reset: false)
    }

    func didSelectFlight(at index: Int) {
        guard index < flights.value.count else { return }
        let flight = flights.value[index]
        coordinator?.showFlightDetail(for: flight)
    }

    func selectFlight(_ flight: Flight) {
        coordinator?.showFlightDetail(for: flight)
    }

    // MARK: - Fetch Logic
    private func fetchFlights(reset: Bool) {
        isLoading = true

        repository.fetchFlights(query: currentQuery, page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure = completion {
                    self?.hasMorePages = false
                }
            }, receiveValue: { [weak self] newFlights in
                guard let self = self else { return }
                self.isLoading = false
                self.hasMorePages = !newFlights.isEmpty

                if reset {
                    self.flights.send(newFlights)
                } else {
                    self.flights.send(self.flights.value + newFlights)
                }
            })
            .store(in: &cancellables)
    }
}
