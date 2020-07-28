//
//  Location.swift
//  My Simple App
//
//  Created by Erick Sanchez on 7/23/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import Foundation
import CoreLocation

class Location {
  static func coordinates(from address: String, completion: @escaping (CLLocation?) -> Void) {
    let geoCoder = CLGeocoder()
    geoCoder.geocodeAddressString(address) { (placemarkers, error) in
      if error != nil {
        completion(nil)
      } else {
        guard let location = placemarkers?.first?.location else { return completion(nil) }
        completion(location)
      }
    }
  }
}
