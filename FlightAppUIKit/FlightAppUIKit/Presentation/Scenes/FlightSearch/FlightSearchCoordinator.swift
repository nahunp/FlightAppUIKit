import UIKit
final class FlightSearchCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = FlightSearchViewModel()
        let viewController = FlightSearchViewController(viewModel: viewModel)
        viewModel.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }

    func showFlightDetail(flight: Flight) {
        let viewModel = FlightDetailViewModel(flight: flight)
        let detailVC = FlightDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(detailVC, animated: true)
    }
}
