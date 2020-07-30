//
//  Networking.swift
//  My Simple App
//
//  Created by Erick Sanchez on 7/23/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import UIKit
import CoreLocation

class Networking {
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
          temperature: CGFloat(weatherData.temperature),
          icon: WeatherIcon(name: weatherData.rawIcon, image: UIImage(named: weatherData.rawIcon)!)
        )
      )
    }.resume()
  }
}
