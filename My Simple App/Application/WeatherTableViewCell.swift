//
//  WeatherTableViewCell.swift
//  My Simple App
//
//  Created by Erick Sanchez on 7/20/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

  private static let cellHeight: CGFloat = 48

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .body)
    return label
  }()

  private let weatherLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .caption1)
    return label
  }()

  private let iconImageView = UIImageView()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.layoutUI()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(_ address: Address) {
    self.titleLabel.text = address.rawValue
    self.weatherLabel.text = "Temperature: \(address.weather?.temperature ?? 0)"
    self.iconImageView.image = (address.weather?.iconName).flatMap { UIImage(named: $0) }
  }

  // MARK: - Private

  private func layoutUI() {
    let stackViewLabels = UIStackView(arrangedSubviews: [self.titleLabel, self.weatherLabel])
    stackViewLabels.axis = .vertical
    let stackViewContent = UIStackView(arrangedSubviews: [stackViewLabels, self.iconImageView])
    stackViewContent.translatesAutoresizingMaskIntoConstraints = false

    self.contentView.addSubview(stackViewContent)
    NSLayoutConstraint.activate([
      // Image view.
      self.iconImageView.widthAnchor.constraint(equalTo: self.iconImageView.heightAnchor),
      self.iconImageView.heightAnchor.constraint(equalToConstant: Self.cellHeight),

      // Content view.
      stackViewContent.topAnchor.constraint(
        equalTo: self.contentView.layoutMarginsGuide.topAnchor
      ),
      stackViewContent.leadingAnchor.constraint(
        equalTo: self.contentView.layoutMarginsGuide.leadingAnchor
      ),
      stackViewContent.trailingAnchor.constraint(
        equalTo: self.contentView.layoutMarginsGuide.trailingAnchor
      ),
      stackViewContent.bottomAnchor.constraint(
        equalTo: self.contentView.layoutMarginsGuide.bottomAnchor
      )
    ])
  }
}
