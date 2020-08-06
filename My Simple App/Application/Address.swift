//
//  Address.swift
//  My Simple App
//
//  Created by Erick Sanchez on 8/5/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import UIKit
import CoreLocation

class Address {
  var rawValue: String?
  var coordinates: CLLocationCoordinate2D?
  var weather: Weather?
}

struct Weather {
  let temperature: CGFloat
  let icon: WeatherIcon
}

struct WeatherIcon {
  let name: String
  let image: UIImage
}
