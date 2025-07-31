import Foundation

protocol FavoriteFlightRepository {
    func isFavorite(icao24: String) -> Bool
    func toggleFavorite(icao24: String)
    func getAllFavorites() -> [String]
}
