import UIKit

protocol FlightCellDelegate: AnyObject {
    func didTapFavorite(for flight: Flight)
}

final class FlightCell: UITableViewCell {
    
    static let reuseIdentifier = "FlightCell"

    private let callsignLabel = UILabel()
    private let countryLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)
    
    private var currentFlight: Flight?
    weak var delegate: FlightCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with flight: Flight) {
        currentFlight = flight
        callsignLabel.text = flight.callsign ?? "No Callsign"
        countryLabel.text = flight.originCountry

        let imageName = flight.isFavorite ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @objc private func favoriteTapped() {
        guard let flight = currentFlight else { return }
        delegate?.didTapFavorite(for: flight)
    }

    private func setupUI() {
        callsignLabel.translatesAutoresizingMaskIntoConstraints = false
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(callsignLabel)
        contentView.addSubview(countryLabel)
        contentView.addSubview(favoriteButton)

        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            callsignLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            callsignLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            countryLabel.topAnchor.constraint(equalTo: callsignLabel.bottomAnchor, constant: 4),
            countryLabel.leadingAnchor.constraint(equalTo: callsignLabel.leadingAnchor),
            countryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
