//
//  UnknownTableViewCell.swift
//  My Simple App
//
//  Created by Erick Sanchez on 7/20/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import UIKit

class UnknownTableViewCell: UITableViewCell {
  var titleLabel: UILabel = {
    let label = UILabel()
    // When you're writing programatic UI using anchors, this property has to
    //   be disabled on all views. At larger dev shops, there will likely be some sort
    //   of view framework and system views (eg UILabel, UIButton) will not be used
    //   directly. The wrapper views will disable this property for you in that case.
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 17)
    return label
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
    addSubview(titleLabel)
  }
  
  private func setupLayout() {
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
      titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
      titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
      titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12)
    ])
  }
}

extension UnknownTableViewCell: CellIdentifiable {
  static var identifier: String {
    return "unknown-cell"
  }
}
