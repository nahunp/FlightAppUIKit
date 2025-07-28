import Foundation
import Combine

final class OpenSkyFlightRepository: FlightRepository {
    private let url = URL(string: "https://opensky-network.org/api/states/all")!

    func fetchFlights() -> AnyPublisher<[Flight], Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: OpenSkyResponseDTO.self, decoder: JSONDecoder())
            .map { response in
                response.states.compactMap { FlightMapper.map(dto: $0) }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
