import Foundation
import Combine

final class FlightListViewModel: ObservableObject {
    
    @Published private(set) var flights: [Flight] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    
    private let fetchUseCase: DefaultFetchFlightsUseCase
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 0
    private var hasMorePages = true
    private var currentQuery = ""
    
    init(fetchUseCase: DefaultFetchFlightsUseCase) {
        self.fetchUseCase = fetchUseCase
    }
    
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
    }
}
