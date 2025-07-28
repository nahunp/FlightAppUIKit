import Foundation

public struct Flight: Equatable {
    public let icao24: String
    public let callsign: String?
    public let originCountry: String
    public let timePosition: Date?
    public let lastContact: Date?
    public let longitude: Double?
    public let latitude: Double?
    public let barometricAltitude: Double?
    public let onGround: Bool
    public let velocity: Double?
    public let trueTrack: Double?
    public let verticalRate: Double?
    public let sensors: [Int]?
    public let geoAltitude: Double?

    public init(
        icao24: String,
        callsign: String?,
        originCountry: String,
        timePosition: Date?,
        lastContact: Date?,
        longitude: Double?,
        latitude: Double?,
        barometricAltitude: Double?,
        onGround: Bool,
        velocity: Double?,
        trueTrack: Double?,
        verticalRate: Double?,
        sensors: [Int]?,
        geoAltitude: Double?
    ) {
        self.icao24 = icao24
        self.callsign = callsign
        self.originCountry = originCountry
        self.timePosition = timePosition
        self.lastContact = lastContact
        self.longitude = longitude
        self.latitude = latitude
        self.barometricAltitude = barometricAltitude
        self.onGround = onGround
        self.velocity = velocity
        self.trueTrack = trueTrack
        self.verticalRate = verticalRate
        self.sensors = sensors
        self.geoAltitude = geoAltitude
    }
}
