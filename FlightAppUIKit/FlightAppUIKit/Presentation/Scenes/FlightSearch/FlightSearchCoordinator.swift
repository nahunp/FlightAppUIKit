import UIKit

final class FlightSearchCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let repository: FlightRepository

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.repository = OpenSkyFlightRepository()
    }

    func start() {
        let viewModel = FlightSearchViewModel(repository: repository, coordinator: self)
        let viewController = FlightSearchViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showFlightDetail(for flight: Flight) {
        let viewModel = FlightDetailViewModel(flight: flight)
        let detailVC = FlightDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(detailVC, animated: true)
    }
}
