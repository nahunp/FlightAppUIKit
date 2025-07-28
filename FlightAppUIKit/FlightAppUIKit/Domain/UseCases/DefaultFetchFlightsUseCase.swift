import Foundation
import Combine

public final class DefaultFetchFlightsUseCase: FetchFlightsUseCase {
    private let repository: FlightRepository

    public init(repository: FlightRepository) {
        self.repository = repository
    }

    public func execute() -> AnyPublisher<[Flight], Error> {
        return repository.fetchFlights()
    }
}
