import Foundation
import Combine

final class OpenSkyFlightRepository: FlightRepository {
    private let url = URL(string: "https://opensky-network.org/api/states/all")!
    private let apiService: APIService

    init(apiService: APIService = .shared) {
        self.apiService = apiService
    }

    func fetchFlights(query: String, page: Int) -> AnyPublisher<[Flight], Error> {
        apiService.request(url: url, responseType: OpenSkyResponseDTO.self)
            .map { response in
                let allFlights = response.states.compactMap { FlightMapper.map(dto: $0) }

                let filtered: [Flight]
                if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    filtered = allFlights
                } else {
                    filtered = allFlights.filter {
                        ($0.callsign?.localizedCaseInsensitiveContains(query) ?? false)
                        || $0.originCountry.localizedCaseInsensitiveContains(query)
                    }
                }

                let pageSize = 20
                let start = page * pageSize
                let end = min(start + pageSize, filtered.count)
                guard start < filtered.count else {
                    return []
                }
                return Array(filtered[start..<end])
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
