//
//  UITableView+MySimpleApp.swift
//  My Simple App
//
//  Created by Erick Sanchez on 8/4/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import UIKit

extension UITableView {
  func register<T: UITableViewCell>(_ cell: T.Type) {
    self.register(cell, forCellReuseIdentifier: String(describing: cell))
  }

  func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
    let identifier = String(describing: T.self)
    guard
      let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T
    else {
      fatalError("cell was not registered, \(identifier)")
    }

    return cell
  }
}
