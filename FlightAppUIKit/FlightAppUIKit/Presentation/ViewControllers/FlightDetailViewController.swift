import UIKit

final class FlightDetailViewController: UIViewController {

    private let viewModel: FlightDetailViewModel

    private let stackView = UIStackView()

    init(viewModel: FlightDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = viewModel.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let labels: [UILabel] = [
            labelRow("Country:", viewModel.country),
            labelRow("Altitude:", viewModel.altitude),
            labelRow("Velocity:", viewModel.velocity),
            labelRow("Coordinates:", viewModel.coordinates)
        ]

        labels.forEach { stackView.addArrangedSubview($0) }

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func labelRow(_ title: String, _ value: String) -> UILabel {
        let label = UILabel()
        label.text = "\(title) \(value)"
        label.numberOfLines = 0
        return label
    }
}
