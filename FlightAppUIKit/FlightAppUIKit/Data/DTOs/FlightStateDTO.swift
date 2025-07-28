import Foundation

struct FlightStateDTO: Decodable {
    let icao24: String
    let callsign: String?
    let originCountry: String
    let geoAltitude: Double?
    let velocity: Double?
    let latitude: Double?
    let longitude: Double?
}
