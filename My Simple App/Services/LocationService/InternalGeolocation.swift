//
//  InternalGeolocation.swift
//  My Simple App
//
//  Created by Erick Sanchez on 8/5/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import CoreLocation

// Wrapper protocol of CLGeocoder.
protocol InternalGeocoder {
  func geocodeAddressString(
    _ address: String,
    completion: @escaping ([CLPlacemark]?, Error?) -> Void
  )
}
