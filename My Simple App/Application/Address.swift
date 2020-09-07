//
//  Address.swift
//  My Simple App
//
//  Created by Erick Sanchez on 8/5/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import UIKit

struct Address {
  let identifier: UUID
  let rawValue: String?
  let longitude: Double?
  let latitude: Double?
  let weather: Weather?
}

struct Weather {
  let temperature: Double
  let iconName: String
}
