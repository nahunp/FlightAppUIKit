import Foundation

final class FlightDetailViewModel {
    let flight: Flight

    init(flight: Flight) {
        self.flight = flight
    }

    var title: String {
        flight.callsign ?? "Flight Details"
    }

    var country: String {
        flight.originCountry
    }

    var altitude: String {
        guard let altitude = flight.geoAltitude else { return "N/A" }
        return String(format: "%.0f m", altitude)
    }

    var velocity: String {
        guard let velocity = flight.velocity else { return "N/A" }
        return String(format: "%.1f m/s", velocity)
    }

    var coordinates: String {
        guard let lat = flight.latitude, let lon = flight.longitude else { return "N/A" }
        return String(format: "%.4f, %.4f", lat, lon)
    }
}
