import Combine

public protocol FetchFlightsUseCase {
    func execute(query: String, page: Int) -> AnyPublisher<[Flight], Error>
}
