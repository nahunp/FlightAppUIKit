import Combine
import Foundation

final class FlightSearchViewModel {
    weak var coordinator: FlightSearchCoordinator?

    // Inputs
    @Published var searchQuery: String = ""
    @Published private(set) var flights: [Flight] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        bindSearch()
    }

    private func bindSearch() {
        $searchQuery
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.fetchFlights(query: query)
            }
            .store(in: &cancellables)
    }

    private func fetchFlights(query: String) {
        // Placeholder: In next PR, call repository with pagination
    }

    func selectFlight(_ flight: Flight) {
        coordinator?.showFlightDetail(flight: flight)
    }
}
