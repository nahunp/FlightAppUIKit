import Foundation
import Combine

final class FlightListViewModel: ObservableObject {
    // MARK: - Published Outputs
    @Published private(set) var flights: [Flight] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?

    // MARK: - Dependencies
    private let fetchFlightsUseCase: FetchFlightsUseCase
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init(fetchFlightsUseCase: FetchFlightsUseCase) {
        self.fetchFlightsUseCase = fetchFlightsUseCase
    }

    // MARK: - Public API
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
                self?.flights = flights
            }
            .store(in: &cancellables)
    }
}
