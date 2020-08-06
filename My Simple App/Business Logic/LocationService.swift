//
//  Location.swift
//  My Simple App
//
//  Created by Erick Sanchez on 7/23/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationInfo {
  let longitude: Double
  let latitude: Double
  let displayName: String?
}

enum LocationServiceErrors: Error {
  case noInfoFound
}

protocol LocationService {
  func info(from address: String, completion: @escaping (Result<LocationInfo, Error>) -> Void)
}
