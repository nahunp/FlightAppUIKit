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
        // Temporary blank view controller to start
        let initialVC = UIViewController()
        initialVC.view.backgroundColor = .systemBackground
        initialVC.title = "Flight Tracker"
        navigationController.pushViewController(initialVC, animated: false)
    }
}
