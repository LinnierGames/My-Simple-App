//
//  DataStore.swiUserWeathert
//  My Simple App
//
//  Created by Erick Sanchez on 7/23/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import UIKit
import CoreLocation // TODO: Remove this dependency.

struct WeatherData: Decodable {
  let temperature: Float
  let rawIcon: String

  enum CodingKeys: String, CodingKey {
    case temperature
    case rawIcon = "raw-icon"
  }
}

struct UserWeather {
  let validAddresses: [Address]
  let invalidAddresses: [Address]
}

class DataStore {
  // TODO: Convert into a service.

  static func load() -> UserWeather {
    let userDefaults = UserDefaults.standard

    var validAddresses = [Address]()
    if let validAddressObjects = userDefaults.array(
      forKey: "user-addresses"
    ) as? [[String: Any]] {
      validAddresses = validAddressObjects.compactMap { object in
        guard
          let value = object["address"] as? String,
          let latitude = object["latitude"] as? Double,
          let longitude = object["longitude"] as? Double,
          let temerature = object["temperature"] as? Double,
          let rawIcon = object["raw-icon"] as? String
        else {
          return nil
        }

        let address = Address()
        address.rawValue = value
        address.coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        address.weather = Weather(
          temperature: CGFloat(temerature),
          icon: WeatherIcon(name: rawIcon, image: UIImage(named: rawIcon)!)
        )

        return address
      }
    }

    var invalidAddresses = [Address]()
    if let invalidAddressObjects = userDefaults.array(
      forKey: "invalid-addresses"
    ) as? [[String: Any]] {
      invalidAddresses = invalidAddressObjects.compactMap { object in
        guard let value = object["address"] as? String else {
          return nil
        }

        let address = Address()
        address.rawValue = value

        return address
      }
    }

    return UserWeather(validAddresses: validAddresses, invalidAddresses: invalidAddresses)
  }

  static func save(validAddresses: [Address], invalidAddresses: [Address]) {
    let userDefaults = UserDefaults.standard
    let addressObjects = validAddresses.map { address in
      return [
        "address": address.rawValue!,
        "latitude": address.coordinates!.latitude,
        "longitude": address.coordinates!.longitude,
        "temperature": Double(address.weather!.temperature),
        "raw-icon": address.weather!.icon.name
      ]
    }
    userDefaults.setValue(addressObjects, forKeyPath: "user-addresses")
    let invalidAddressObjects = invalidAddresses.map { address in
      return [
        "address": address.rawValue!
      ]
    }
    userDefaults.setValue(invalidAddressObjects, forKeyPath: "invalid-addresses")
    userDefaults.synchronize()
  }
}
