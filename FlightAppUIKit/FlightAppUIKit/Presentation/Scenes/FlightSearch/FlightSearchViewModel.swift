import Foundation
import Combine

final class FlightSearchViewModel: FlightSearchViewModelInput, FlightSearchViewModelOutput {

    @Published var searchQuery: String = ""
    @Published private(set) var flights: [Flight] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        bindSearch()
        var flightsValue: [Flight]
        return flights.value
    }
    // MARK: - Inputs
    func didSearch(query: String) {
        currentQuery = query
        currentPage = 0
        flights.send([])
        fetchFlights(reset: true)
    }

    func loadNextPageIfNeeded(currentIndex: Int) {
        let threshold = flights.value.count - 5
        print("Checking if need to load next page: currentIndex=\(currentIndex), threshold=\(threshold)")
        
        guard currentIndex >= threshold, !isLoading, hasMorePages else {
            print("Not loading: isLoading=\(isLoading), hasMorePages=\(hasMorePages)")
            return
        }

        print("Loading next page: \(currentPage + 1)")
        currentPage += 1
        fetchFlights(reset: false)
    }

    func didSelectFlight(at index: Int) {
        guard index < flights.value.count else { return }
        let flight = flights.value[index]
        coordinator?.showFlightDetail(for: flight)
    }

    // MARK: - Outputs
    var flightsPublisher: AnyPublisher<[Flight], Never> {
        flights.eraseToAnyPublisher()
    }

    // MARK: - Private
    private let repository: FlightRepository
    private let flights = CurrentValueSubject<[Flight], Never>([])
    private var cancellables = Set<AnyCancellable>()

    private var currentQuery: String = ""
    private var currentPage: Int = 0
    private var isLoading = false
    private var hasMorePages = true

    weak var coordinator: FlightSearchCoordinator?
    
    init(repository: FlightRepository, coordinator: FlightSearchCoordinator?) {
        self.repository = repository
        self.coordinator = coordinator
    }

    private func fetchFlights(reset: Bool) {
        isLoading = true

        repository.fetchFlights(query: currentQuery, page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure = completion { self?.hasMorePages = false }
            }, receiveValue: { [weak self] newFlights in
                self?.isLoading = false
                self?.hasMorePages = !newFlights.isEmpty
                if reset {
                    self?.flights.send(newFlights)
                } else {
                    self?.flights.send((self?.flights.value ?? []) + newFlights)
                }
            })
            .store(in: &cancellables)
    }

    private func fetchFlights(query: String) {
    }

    func selectFlight(_ flight: Flight) {
        coordinator?.showFlightDetail(flight: flight)
    }
}
