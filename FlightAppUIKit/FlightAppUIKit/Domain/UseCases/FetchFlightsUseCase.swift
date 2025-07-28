import Combine

public protocol FetchFlightsUseCase {
    func execute() -> AnyPublisher<[Flight], Error>
}
