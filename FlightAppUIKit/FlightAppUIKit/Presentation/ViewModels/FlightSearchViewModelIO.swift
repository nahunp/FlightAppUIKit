import Combine

// MARK: - ViewModel Input Protocol
protocol FlightSearchViewModelInput {
    func didSearch(query: String)
    func loadNextPageIfNeeded(currentIndex: Int)
    func didSelectFlight(at index: Int)
    func selectFlight(_ flight: Flight)
}

// MARK: - ViewModel Output Protocol
protocol FlightSearchViewModelOutput {
    var flightsPublisher: AnyPublisher<[Flight], Never> { get }
    var searchQuery: String { get set }
}
