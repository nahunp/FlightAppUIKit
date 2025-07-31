import Foundation

final class FavoriteFlightRepositoryImpl: FavoriteFlightRepository {
    static let shared = FavoriteFlightRepositoryImpl()
    
    private let key = "favorite_flight_ids"
    private var favoriteSet: Set<String> = []

    private init() {
        load()
    }

    func isFavorite(icao24: String) -> Bool {
        return favoriteSet.contains(icao24)
    }

    func toggleFavorite(icao24: String) {
        if favoriteSet.contains(icao24) {
            favoriteSet.remove(icao24)
        } else {
            favoriteSet.insert(icao24)
        }
        save()
    }

    func getAllFavorites() -> [String] {
        return Array(favoriteSet)
    }

    private func save() {
        UserDefaults.standard.set(Array(favoriteSet), forKey: key)
    }

    private func load() {
        if let saved = UserDefaults.standard.array(forKey: key) as? [String] {
            favoriteSet = Set(saved)
        }
    }
}
