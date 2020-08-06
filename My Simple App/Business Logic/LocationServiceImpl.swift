//
//  LocationServiceImpl.swift
//  My Simple App
//
//  Created by Erick Sanchez on 8/5/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import Foundation
import CoreLocation

func injectLocationService() -> LocationService {
  return LocationServiceImpl()
}

typealias InternalGeocoderFactory = () -> InternalGeocoder

class LocationServiceImpl: LocationService {
  private let geocoderFactory: InternalGeocoderFactory
  init(geocoderFactory: @escaping InternalGeocoderFactory = { injectInternalGeocoder() }) {
    self.geocoderFactory = geocoderFactory
  }

  func info(from address: String, completion: @escaping (Result<LocationInfo, Error>) -> Void) {
    let geoCoder = geocoderFactory()
    geoCoder.geocodeAddressString(address) { (placemarkers, error) in
      if let error = error {
        return completion(.failure(error))
      }

      guard let placemarker = placemarkers?.first, let location = placemarker.location else {
        return completion(.failure(LocationServiceErrors.noInfoFound))
      }

      let info = LocationInfo(
        longitude: location.coordinate.longitude,
        latitude: location.coordinate.latitude,
        displayName: placemarker.name
      )

      completion(.success(info))
    }
  }
}
