//
//  WeatherTableViewCell.swift
//  My Simple App
//
//  Created by Erick Sanchez on 7/20/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
  var titleLabel: UILabel = {
    let label = UILabel()
    // When you're writing programatic UI using anchors, this property has to
    //   be disabled on all views. At larger dev shops, there will likely be some sort
    //   of view framework and system views (eg UILabel, UIButton) will not be used
    //   directly. The wrapper views will disable this property for you in that case.
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .preferredFont(forTextStyle: .body)
    return label
  }()
  var weatherLabel: UILabel = {
    let label = UILabel()
    // When you're writing programatic UI using anchors, this property has to
    //   be disabled on all views. At larger dev shops, there will likely be some sort
    //   of view framework and system views (eg UILabel, UIButton) will not be used
    //   directly. The wrapper views will disable this property for you in that case.
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .preferredFont(forTextStyle: .caption1)
    return label
  }()
  var iconImageView: UIImageView = {
    let image = UIImageView()
    // When you're writing programatic UI using anchors, this property has to
    //   be disabled on all views. At larger dev shops, there will likely be some sort
    //   of view framework and system views (eg UILabel, UIButton) will not be used
    //   directly. The wrapper views will disable this property for you in that case.
    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()
  
  var verticalStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    // When you're writing programatic UI using anchors, this property has to
    //   be disabled on all views. At larger dev shops, there will likely be some sort
    //   of view framework and system views (eg UILabel, UIButton) will not be used
    //   directly. The wrapper views will disable this property for you in that case.
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.distribution = .fill
    stack.spacing = 10
    return stack
  }()
  var horizontalStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .horizontal
    // When you're writing programatic UI using anchors, this property has to
    //   be disabled on all views. At larger dev shops, there will likely be some sort
    //   of view framework and system views (eg UILabel, UIButton) will not be used
    //   directly. The wrapper views will disable this property for you in that case.
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.distribution = .fill
    stack.spacing = 10
    return stack
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  private func setupViews() {
    addSubview(horizontalStack)
    horizontalStack.addArrangedSubview(verticalStack)
    horizontalStack.addArrangedSubview(iconImageView)
    
    verticalStack.addArrangedSubview(titleLabel)
    verticalStack.addArrangedSubview(weatherLabel)
  }
  
  private func setupLayout() {
    // Horizontal stack constraints
    NSLayoutConstraint.activate([
      horizontalStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
      horizontalStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
      horizontalStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
      horizontalStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12)
    ])
    
    // Icon constraints
    NSLayoutConstraint.activate([
      iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor, multiplier: 1)
    ])
  }
}

extension WeatherTableViewCell: CellIdentifiable {
  static var identifier: String {
    return "weather-cell"
  }
}
