import Combine

protocol FlightSearchViewModelInput {
    func didSearch(query: String)
    func loadNextPageIfNeeded(currentIndex: Int)
    func didSelectFlight(at index: Int)
}

protocol FlightSearchViewModelOutput {
    var flightsPublisher: AnyPublisher<[Flight], Never> { get }
}
