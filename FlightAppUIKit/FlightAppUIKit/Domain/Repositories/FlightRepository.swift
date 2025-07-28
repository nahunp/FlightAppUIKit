import Combine

public protocol FlightRepository {
    func fetchFlights() -> AnyPublisher<[Flight], Error>
}
