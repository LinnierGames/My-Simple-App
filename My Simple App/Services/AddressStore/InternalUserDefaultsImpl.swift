//
//  InternalUserDefaults.swift
//  My Simple App
//
//  Created by Erick Sanchez on 8/12/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import Foundation

class InternalUserDefaultsImpl: InternalUserDefaults {
  private let userDefaults: UserDefaults

  init(userDefaults: UserDefaults) {
    self.userDefaults = userDefaults
  }

  func set(_ value: Any?, forKeyPath keyPath: String) {
    self.userDefaults.set(value, forKey: keyPath)
  }

  func object(forKey key: String) -> Any? {
    self.userDefaults.object(forKey: key)
  }

  func synchronize() {
    self.userDefaults.synchronize()
  }
}
