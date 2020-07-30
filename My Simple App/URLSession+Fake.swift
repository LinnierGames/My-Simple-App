//
//  URLSession+Fake.swift
//  My Simple App
//
//  Created by Erick Sanchez on 7/20/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import Foundation

func injectURLSession() -> URLSession {
  return SeededURLSession()
}

/// Fake networking class that will return random weather data.
///
/// ```
/// let url = URL(string: "https://www.weather.com/weather?long=45&lat=45")!
/// let urlSession = injectURLSession()
/// urlSession.dataTask(with: URLRequest(url: url)) {
///   ...
/// }
/// ```
class SeededURLSession: URLSession {
  override func dataTask(
    with url: URL,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
  ) -> URLSessionDataTask {
    return SeededDataTask(request: URLRequest(url: url), completion: completionHandler)
  }

  override func dataTask(
    with request: URLRequest,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
  ) -> URLSessionDataTask {
    return SeededDataTask(request: request, completion: completionHandler)
  }
}

class SeededDataTask: URLSessionDataTask {
  private let request: URLRequest
  private let completion: (Data?, URLResponse?, Error?) -> Void
  private let realSession = URLSession.shared

  private let fakeResponses = [
    """
    {
      "temperature": 58,
      "raw-icon": "partly-cloudy-day"
    }
    """,
    """
    {
      "temperature": 58,
      "raw-icon": "clear-day"
    }
    """,
    """
    {
      "temperature": 32,
      "raw-icon": "clear-night"
    }
    """,
    """
    {
      "temperature": 54,
      "raw-icon": "cloudy"
    }
    """,
    """
    {
      "temperature": 56,
      "raw-icon": "fog"
    }
    """,
    """
    {
      "temperature": 24,
      "raw-icon": "partly-cloudy-day"
    }
    """,
    """
    {
      "temperature": 64,
      "raw-icon": "rain"
    }
    """,
    """
    {
      "temperature": 23,
      "raw-icon": "sleet"
    }
    """,
    """
    {
      "temperature": 21,
      "raw-icon": "snow"
    }
    """,
    """
    {
      "temperature": 86,
      "raw-icon": "thunder"
    }
    """,
    """
    {
      "temperature": 42,
      "raw-icon": "unbrella"
    }
    """,
    """
    {
      "temperature": 46,
      "raw-icon": "windy"
    }
    """
  ]

  init(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    guard
      let url = request.url,
      let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
    else {
      fatalError("failed to create components from url")
    }

    assert(components.scheme == "https")
    assert(components.host == "www.weather.com")
    assert(components.path == "/weather")

    guard let items = components.queryItems, items.count == 2 else {
      fatalError("missing query items")
    }

    assert(items.contains(where: { $0.name == "long" }))
    assert(items.contains(where: { $0.name == "lat" }))

    self.request = request
    self.completion = completion
  }

  override func resume() {
    let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
    let data = fakeResponses.randomElement()!.data(using: .utf8)
    completion(data, response, nil)
  }
}
