import Foundation

struct FlightMapper {
    static func map(dto: FlightStateDTO) -> Flight {
        Flight(
            icao24: dto.icao24,
            callsign: dto.callsign,
            originCountry: dto.originCountry,
            timePosition: nil,      // add if FlightStateDTO has it
            lastContact: nil,        // add if FlightStateDTO has it
            longitude: dto.longitude,
            latitude: dto.latitude,
            barometricAltitude: nil, // add if FlightStateDTO has it
            onGround: false,           // add if FlightStateDTO has it
            velocity: dto.velocity,
            trueTrack: nil,          // add if FlightStateDTO has it
            verticalRate: nil,       // add if FlightStateDTO has it
            sensors: nil,            // add if FlightStateDTO has it
            geoAltitude: dto.geoAltitude
        )
    }

    private static func toDate(_ value: Any?) -> Date? {
        guard let timeInterval = value as? TimeInterval else { return nil }
        return Date(timeIntervalSince1970: timeInterval)
    }
}
