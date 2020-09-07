//
//  InternalGeolocationImpl.swift
//  My Simple App
//
//  Created by Erick Sanchez on 8/5/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import CoreLocation

func injectInternalGeocoder() -> InternalGeocoder {
  return InternalGeocoderImpl(geocoder: CLGeocoder())
}

class InternalGeocoderImpl: InternalGeocoder {
  private let geocoder: CLGeocoder
  init(geocoder: CLGeocoder) {
    self.geocoder = geocoder
  }

  func geocodeAddressString(
    _ address: String,
    completion: @escaping ([CLPlacemark]?, Error?) -> Void
  ) {
    self.geocoder.geocodeAddressString(address, completionHandler: completion)
  }
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
