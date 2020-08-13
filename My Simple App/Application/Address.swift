//
//  Address.swift
//  My Simple App
//
//  Created by Erick Sanchez on 8/5/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import UIKit

// TODO: remove vars

struct Address {
  let identifier: UUID
  var rawValue: String?
  var longitude: Double?
  var latitude: Double?
  var weather: Weather?

  init() {
    self.identifier = UUID()
  }

  init(
    identifier: UUID,
    rawValue: String?,
    longitude: Double?,
    latitude: Double?,
    weather: Weather?
  ) {
    self.identifier = identifier
    self.rawValue = rawValue
    self.longitude = longitude
    self.latitude = latitude
    self.weather = weather
  }
}

struct Weather {
  let temperature: Double
  let iconName: String
}
