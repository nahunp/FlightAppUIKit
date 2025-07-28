import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        // Step 1: Create Repository
        let repository = OpenSkyFlightRepository(apiService: APIService.shared)

        // Step 2: Create Use Case
        let useCase = DefaultFetchFlightsUseCase(repository: repository)

        // Step 3: Create ViewModel
        let viewModel = FlightListViewModel(fetchFlightsUseCase: useCase)

        // Step 4: Create ViewController
        let viewController = FlightListViewController(viewModel: viewModel, coordinator: self)

        // Step 5: Push to navigation stack
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showFlightDetail(for flight: Flight) {
        let viewModel = FlightDetailViewModel(flight: flight)
        let detailVC = FlightDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(detailVC, animated: true)
    }
}
