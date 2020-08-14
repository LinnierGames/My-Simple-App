//
//  LocationServiceImpl.swift
//  My Simple App
//
//  Created by Erick Sanchez on 8/5/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import Foundation

func injectLocationService() -> LocationService {
  return LocationServiceImpl()
}

class InternalGeocoderFactory {
  private let factory: () -> InternalGeocoder
  init(factory: @escaping () -> InternalGeocoder) {
    self.factory = factory
  }

  func make() -> InternalGeocoder {
    return self.factory()
  }
}

class LocationServiceImpl: LocationService {
  private let geocoderFactory: InternalGeocoderFactory

  init(
    geocoderFactory: InternalGeocoderFactory = InternalGeocoderFactory { injectInternalGeocoder() }
  ) {
    self.geocoderFactory = geocoderFactory
  }

  func info(from address: String, completion: @escaping (Result<LocationInfo, Error>) -> Void) {
    let geoCoder = self.geocoderFactory.make()
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
