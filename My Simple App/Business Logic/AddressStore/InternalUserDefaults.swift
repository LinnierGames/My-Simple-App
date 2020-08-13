//
//  InternalUserDefaults.swift
//  My Simple App
//
//  Created by Erick Sanchez on 8/12/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

// Wrapper protocol of UserDefaults.
protocol InternalUserDefaults {
  func set(_ value: Any?, forKeyPath keyPath: String)
  func object(forKey key: String) -> Any?
  func synchronize()
}
