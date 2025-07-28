import Foundation

struct FlightMapper {
    static func map(dto: [Any?]) -> Flight? {
        guard dto.count >= 15 else { return nil }

        return Flight(
            icao24: dto[0] as? String ?? "",
            callsign: dto[1] as? String,
            originCountry: dto[2] as? String ?? "Unknown",
            timePosition: dto[3].flatMap { toDate($0) },
            lastContact: dto[4].flatMap { toDate($0) },
            longitude: dto[5] as? Double,
            latitude: dto[6] as? Double,
            barometricAltitude: dto[7] as? Double,
            onGround: dto[8] as? Bool ?? false,
            velocity: dto[9] as? Double,
            trueTrack: dto[10] as? Double,
            verticalRate: dto[11] as? Double,
            sensors: dto[12] as? [Int],
            geoAltitude: dto[13] as? Double
        )
    }

    private static func toDate(_ value: Any?) -> Date? {
        guard let timeInterval = value as? TimeInterval else { return nil }
        return Date(timeIntervalSince1970: timeInterval)
    }
}
