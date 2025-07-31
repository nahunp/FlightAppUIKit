final class DefaultToggleFavoriteFlightUseCase: ToggleFavoriteFlightUseCase {
    private let repository: FavoriteFlightRepository

    init(repository: FavoriteFlightRepository) {
        self.repository = repository
    }

    func execute(icao24: String) {
        repository.toggleFavorite(icao24: icao24)
    }
}
