import Foundation
import Combine

final class APIService {
    static let shared = APIService()
    private init() {}

    func request<T: Decodable>(
        url: URL,
        responseType: T.Type,
        decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .mapError { NetworkError.requestFailed($0) }
            .map(\.data)
            .decode(type: T.self, decoder: decoder)
            .mapError { NetworkError.decodingFailed($0) }
            .eraseToAnyPublisher()
    }
}
