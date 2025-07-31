import Combine

public protocol FlightRepository {
    func fetchFlights(query: String, page: Int) -> AnyPublisher<[Flight], Error>
}
