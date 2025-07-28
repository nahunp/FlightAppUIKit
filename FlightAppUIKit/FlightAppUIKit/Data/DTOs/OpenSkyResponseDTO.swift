import Foundation

struct OpenSkyResponseDTO: Decodable {
    let time: Int
    let states: [FlightStateDTO]

    enum CodingKeys: String, CodingKey {
        case time
        case states
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        time = try container.decode(Int.self, forKey: .time)

        let rawStates = try container.decode([[AnyDecodable]].self, forKey: .states)

        states = rawStates.compactMap { stateArray in
            guard
                stateArray.count >= 10,
                let icao24 = stateArray[0].value as? String,
                let originCountry = stateArray[2].value as? String
            else { return nil }

            let callsign = stateArray[1].value as? String
            let longitude = stateArray[5].value as? Double
            let latitude = stateArray[6].value as? Double
            let geoAltitude = stateArray[7].value as? Double
            let velocity = stateArray[9].value as? Double

            return FlightStateDTO(
                icao24: icao24,
                callsign: callsign,
                originCountry: originCountry,
                geoAltitude: geoAltitude,
                velocity: velocity,
                latitude: latitude,
                longitude: longitude
            )
        }
    }
}
