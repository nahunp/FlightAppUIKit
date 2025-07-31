import Foundation
import Combine

final class FlightListViewModel: ObservableObject {
<<<<<<< HEAD
=======
    
>>>>>>> 31612d81b074d9d4aba9abda8c61bd2b0755b3d7
    @Published private(set) var flights: [Flight] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    
<<<<<<< HEAD
    private var allFlights: [Flight] = []
    private var currentQuery = ""
    
    private let fetchFlightsUseCase: FetchFlightsUseCase
    private let toggleFavoriteUseCase: ToggleFavoriteFlightUseCase
    private var cancellables = Set<AnyCancellable>()

    init(fetchFlightsUseCase: FetchFlightsUseCase, toggleFavoriteUseCase: ToggleFavoriteFlightUseCase) {
        self.fetchFlightsUseCase = fetchFlightsUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
    }

=======
    private let fetchUseCase: DefaultFetchFlightsUseCase
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 0
    private var hasMorePages = true
    private var currentQuery = ""
    
    init(fetchUseCase: DefaultFetchFlightsUseCase) {
        self.fetchUseCase = fetchUseCase
    }
    
>>>>>>> 31612d81b074d9d4aba9abda8c61bd2b0755b3d7
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
            } receiveValue: { [weak self] flights in
<<<<<<< HEAD
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
=======
                self?.flights = flights
                self?.hasMorePages = !flights.isEmpty
            }
            .store(in: &cancellables)
    }
    
    func loadNextPageIfNeeded(currentIndex: Int) {
        let threshold = flights.count - 5
        guard currentIndex >= threshold, !isLoading, hasMorePages else { return }
        
        currentPage += 1
        isLoading = true
        
        fetchUseCase.execute(query: currentQuery, page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                    self?.hasMorePages = false
                }
            } receiveValue: { [weak self] newFlights in
                guard let self = self else { return }
                self.flights.append(contentsOf: newFlights)
                self.hasMorePages = !newFlights.isEmpty
            }
            .store(in: &cancellables)
    }
    
    func searchFlights(query: String) {
        currentQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        currentPage = 0
        hasMorePages = true
        flights = []
        fetchFlights()
>>>>>>> 31612d81b074d9d4aba9abda8c61bd2b0755b3d7
    }
}
