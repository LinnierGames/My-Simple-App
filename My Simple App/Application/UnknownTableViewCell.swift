//
//  UnknownTableViewCell.swift
//  My Simple App
//
//  Created by Erick Sanchez on 7/20/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import UIKit

class UnknownTableViewCell: UITableViewCell {

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.textLabel?.font = .preferredFont(forTextStyle: .body)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
