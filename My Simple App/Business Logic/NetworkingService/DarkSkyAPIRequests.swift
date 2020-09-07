//
//  DarkSkyAPIRequests.swift
//  My Simple App
//
//  Created by Erick Sanchez on 8/13/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
  let temperature: Float
  let rawIcon: String

  enum CodingKeys: String, CodingKey {
    case temperature
    case rawIcon = "raw-icon"
  }
}

struct WeatherRequestByCooridnates: NetworkRequest {
  typealias ResponseType = Weather

  let baseURL = URL(string: "https://www.weather.com/")!
  let path = "weather"
  let method = NetworkMethod.get
  let headers = [String: String]()
  var payload: RequestTask {
    RequestTask.params(dictionary: [
      "long": String(self.longitude),
      "lat": String(self.latitude)
    ])
  }

  private let longitude: Double
  private let latitude: Double

  // TODO: Pass timestamp to weather request.
  init(longitude: Double, latitude: Double) {
    self.longitude = longitude
    self.latitude = latitude
  }

  func proccess(response: NetworkResponse, completion: @escaping (Result<Weather, Error>) -> Void) {
    do {
      let weatherData = try JSONDecoder().decode(WeatherData.self, from: response.data)
      let weather = Weather(
        temperature: Double(weatherData.temperature),
        iconName: weatherData.rawIcon
      )
      completion(.success(weather))
    } catch {
      completion(.failure(error))
    }
  }
}
