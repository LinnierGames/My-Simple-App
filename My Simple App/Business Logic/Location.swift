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
  static func placemarker(from address: String, completion: @escaping (CLPlacemark?) -> Void) {
    let geoCoder = CLGeocoder()
    geoCoder.geocodeAddressString(address) { (placemarkers, error) in
      if let error = error {
        completion(nil)
      } else {
        guard let placemarker = placemarkers?.first else { return completion(nil) }
        completion(placemarker)
      }
    }
  }
}
