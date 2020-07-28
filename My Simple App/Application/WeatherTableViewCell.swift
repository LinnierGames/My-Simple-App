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
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  var weatherLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  var iconImageView: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()
  
  var verticalStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  var horizontalStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .horizontal
    stack.translatesAutoresizingMaskIntoConstraints = false
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
    NSLayoutConstraint.activate([
      horizontalStack.topAnchor.constraint(equalTo: self.topAnchor),
      horizontalStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      horizontalStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      horizontalStack.trailingAnchor.constraint(equalTo: self.trailingAnchor)
    ])
  }
}
