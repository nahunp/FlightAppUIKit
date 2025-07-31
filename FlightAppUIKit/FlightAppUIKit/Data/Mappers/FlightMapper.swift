import Foundation

struct FlightMapper {
    static func map(dto: FlightStateDTO) -> Flight {
        Flight(
            icao24: dto.icao24,
            callsign: dto.callsign,
            originCountry: dto.originCountry,
            timePosition: nil,
            lastContact: nil,
            longitude: dto.longitude,
            latitude: dto.latitude,
            barometricAltitude: nil,
            onGround: false,
            velocity: dto.velocity,
            trueTrack: nil,
            verticalRate: nil,
            sensors: nil,
            geoAltitude: dto.geoAltitude
        )
    }

    private static func toDate(_ value: Any?) -> Date? {
        guard let timeInterval = value as? TimeInterval else { return nil }
        return Date(timeIntervalSince1970: timeInterval)
    }
}
