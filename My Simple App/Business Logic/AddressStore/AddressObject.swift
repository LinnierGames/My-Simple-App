//
//  AddressObject.swift
//  My Simple App
//
//  Created by Erick Sanchez on 8/12/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import Foundation

struct AddressObject: Codable {
  let identifier: UUID
  let name: String?
  let longitude: Double?
  let latitude: Double?
  let temperature: Double?
  let iconName: String?
}

extension AddressObject {
  init(_ address: Address) {
    self.init(
      identifier: address.identifier,
      name: address.rawValue,
      longitude: address.longitude,
      latitude: address.latitude,
      temperature: address.weather?.temperature,
      iconName: address.weather?.iconName
    )
  }
}

extension Address {
  init(_ addressObject: AddressObject) {
    let weather: Weather?
    if let temperature = addressObject.temperature, let icon = addressObject.iconName {
      weather = Weather(temperature: temperature, iconName: icon)
    } else {
      weather = nil
    }

    self.init(
      identifier: addressObject.identifier,
      rawValue: addressObject.name,
      longitude: addressObject.longitude,
      latitude: addressObject.latitude,
      weather: weather
    )
  }
}
