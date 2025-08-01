import Combine
import Foundation

final class FlightListViewModel: ObservableObject {

    // MARK: - Published Outputs
    @Published private(set) var flights: [Flight] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    // MARK: - Private State
    private var allFlights: [Flight] = []
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 0
    private var hasMorePages = true
    private var currentQuery = ""

    // MARK: - Dependencies
    private let fetchUseCase: FetchFlightsUseCase
    private let toggleFavoriteUseCase: ToggleFavoriteFlightUseCase

    // MARK: - Init
    init(fetchUseCase: FetchFlightsUseCase,
         toggleFavoriteUseCase: ToggleFavoriteFlightUseCase) {
        self.fetchUseCase = fetchUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
    }

    // MARK: - Fetch Flights
    func fetchFlights() {
        
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        fetchUseCase.execute(query: currentQuery, page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] fetchedFlights in
                guard let self = self else { return }

                let updatedFlights = fetchedFlights.map { flight -> Flight in
                    var mutableFlight = flight
                    mutableFlight.isFavorite = FavoriteFlightRepositoryImpl.shared.isFavorite(icao24: flight.icao24)
                    return mutableFlight
                }

                if self.currentPage == 0 {
                    self.flights = updatedFlights
                } else {
                    self.flights.append(contentsOf: updatedFlights)
                }

                self.hasMorePages = !updatedFlights.isEmpty
                
            }
            .store(in: &cancellables)
    }

    // MARK: - Toggle Favorite
    func toggleFavorite(flight: Flight) {
        toggleFavoriteUseCase.execute(icao24: flight.icao24)

        // Update current flight list with new favorite status
        flights = flights.map {
            var mutable = $0
            if mutable.icao24 == flight.icao24 {
                mutable.isFavorite = FavoriteFlightRepositoryImpl.shared.isFavorite(icao24: flight.icao24)
            }
            return mutable
        }
    }

    // MARK: - Search
    func searchFlights(query: String) {
        currentQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        currentPage = 0
        hasMorePages = true
        flights = []
        fetchFlights()
    }

    // MARK: - Pagination
    func loadNextPageIfNeeded(currentIndex: Int) {
        let threshold = flights.count - 5
        guard currentIndex >= threshold, !isLoading, hasMorePages else { return }

        currentPage += 1
        fetchFlights()
    }
}
