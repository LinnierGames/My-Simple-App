//
//  WeatherModels.swift
//  My Simple App
//
//  Created by Erick Sanchez on 7/23/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import UIKit
import CoreLocation

class Address {
  var rawValue: String?
  var coordinates: CLLocationCoordinate2D?
  var weather: Weather?
}

struct WeatherIcon {
  let name: String
  let image: UIImage
}

struct Weather {
  let temperature: CGFloat
  let icon: WeatherIcon
}

struct WeatherData: Decodable {
  let temperature: Float
  let rawIcon: String

  enum CodingKeys: String, CodingKey {
    case temperature
    case rawIcon = "raw-icon"
  }
}
