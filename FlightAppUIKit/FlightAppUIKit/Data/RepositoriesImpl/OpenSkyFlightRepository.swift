import Foundation
import Combine

final class OpenSkyFlightRepository: FlightRepository {
    private let url = URL(string: "https://opensky-network.org/api/states/all")!
    private let apiService: APIService

    init(apiService: APIService = .shared) {
        self.apiService = apiService
    }

    func fetchFlights() -> AnyPublisher<[Flight], Error> {
        apiService.request(url: url, responseType: OpenSkyResponseDTO.self)
            .map { response in
                response.states.compactMap { FlightMapper.map(dto: $0) }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
