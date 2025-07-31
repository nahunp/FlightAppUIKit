import Foundation
import Combine

final class FlightListViewModel: ObservableObject {
    @Published private(set) var flights: [Flight] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    
    private var allFlights: [Flight] = []
    private var currentQuery = ""
    
    private let fetchFlightsUseCase: FetchFlightsUseCase
    private let toggleFavoriteUseCase: ToggleFavoriteFlightUseCase
    private var cancellables = Set<AnyCancellable>()

    init(fetchFlightsUseCase: FetchFlightsUseCase, toggleFavoriteUseCase: ToggleFavoriteFlightUseCase) {
        self.fetchFlightsUseCase = fetchFlightsUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
    }

    func fetchFlights() {
        isLoading = true
        errorMessage = nil

        fetchFlightsUseCase.execute()
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] flights in
                guard let self = self else { return }
                self.allFlights = flights.map { flight in
                    var mutableFlight = flight
                    mutableFlight.isFavorite = FavoriteFlightRepositoryImpl.shared.isFavorite(icao24: flight.icao24)
                    return mutableFlight
                }
                self.flights = self.allFlights
            }
            .store(in: &cancellables)
    }

    func toggleFavorite(flight: Flight) {
        toggleFavoriteUseCase.execute(icao24: flight.icao24)
        allFlights = allFlights.map { flight in
            var mutableFlight = flight
            mutableFlight.isFavorite = FavoriteFlightRepositoryImpl.shared.isFavorite(icao24: flight.icao24)
            return mutableFlight
        }
        searchFlights(query: currentQuery)
    }

    func searchFlights(query: String) {
        currentQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if currentQuery.isEmpty {
            flights = allFlights
        } else {
            flights = allFlights.filter {
                ($0.callsign?.localizedCaseInsensitiveContains(currentQuery) ?? false) ||
                $0.originCountry.localizedCaseInsensitiveContains(currentQuery)
            }
        }
    }
}
