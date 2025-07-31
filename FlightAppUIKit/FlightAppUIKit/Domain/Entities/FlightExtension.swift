import Foundation

extension Flight {
    public static func == (lhs: Flight, rhs: Flight) -> Bool {
        return lhs.icao24 == rhs.icao24
            && lhs.callsign == rhs.callsign
            && lhs.originCountry == rhs.originCountry
            && lhs.timePosition == rhs.timePosition
            && lhs.lastContact == rhs.lastContact
            && lhs.longitude == rhs.longitude
            && lhs.latitude == rhs.latitude
            && lhs.barometricAltitude == rhs.barometricAltitude
            && lhs.onGround == rhs.onGround
            && lhs.velocity == rhs.velocity
            && lhs.trueTrack == rhs.trueTrack
            && lhs.verticalRate == rhs.verticalRate
            && lhs.sensors == rhs.sensors
            && lhs.geoAltitude == rhs.geoAltitude
    }
}
