//
//  Networking.swift
//  My Simple App
//
//  Created by Erick Sanchez on 7/23/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import UIKit
import CoreLocation // TODO: Remove this dependency after refactoring Networking.

struct WeatherData: Decodable {
  let temperature: Float
  let rawIcon: String

  enum CodingKeys: String, CodingKey {
    case temperature
    case rawIcon = "raw-icon"
  }
}

class Networking {
  // TODO: Convert into a service.

  static func fetchWeather(
    location: CLLocationCoordinate2D,
    completion: @escaping (Weather) -> Void
  ) {
    var queryItems = URLComponents(
      url: URL(string: "https://www.weather.com/weather")!,
      resolvingAgainstBaseURL: false
    )!
    queryItems.queryItems = [
      URLQueryItem(name: "long", value: String(location.longitude)),
      URLQueryItem(name: "lat", value: String(location.latitude))
    ]
    let url = queryItems.url!
    let urlSession = injectURLSession()
    urlSession.dataTask(with: URLRequest(url: url)) { (data, _, error) in
      if let error = error {
        print("something went wrong", error)
        return
      }

      guard
        let data = data,
        let weatherData = try? JSONDecoder().decode(WeatherData.self, from: data)
      else {
        return
      }

      completion(
        Weather(
          temperature: Double(weatherData.temperature),
          iconName: weatherData.rawIcon
        )
      )
    }.resume()
  }
}
