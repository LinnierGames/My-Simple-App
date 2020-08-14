import Foundation

func injectNetworkingService() -> NetworkingService {
  return NetworkingServiceImpl(urlSession: injectURLSession())
}

class NetworkingServiceImpl: NetworkingService {
  private let session: URLSession

  init(urlSession: URLSession) {
    self.session = urlSession
  }

  func process<T: NetworkRequest>(
    request: T,
    completion: @escaping (Result<T.ResponseType, Error>) -> Void
  ) {
    let fullURL: URL
    if request.path.isEmpty {
      fullURL = request.baseURL
    } else {
      fullURL = request.baseURL.appendingPathComponent(request.path)
    }

    var urlRequest = URLRequest(url: fullURL)
    urlRequest.httpMethod = request.method.stringValue
    urlRequest.allHTTPHeaderFields = request.headers

    setPayload: do {
      switch request.payload {
      case .empty: break setPayload
      case .bodyData(let data):
        urlRequest.httpBody = data
      case .bodyEncodable(let encodable, encoder: let encoder):
        urlRequest.httpBody = try? encoder.encode(encodable)
        urlRequest.addValueIfEmpty(
          "application/json; charset=utf-8",
          forHTTPHeaderField: "Content-Type")
      case .params(let dictionary):
        guard var urlComponents = URLComponents(url: fullURL, resolvingAgainstBaseURL: true) else {
          break setPayload
        }

        // Map array values into multiple query items with the same key.
        //
        // Example:
        // dictionary = ["foo": "value1,value2"]
        // items = [
        //   URLQueryItem(name: "foo", value: "value1"),
        //   URLQueryItem(name: "foo", value: "value2"),
        // ]
        var items: [URLQueryItem] = []
        for pair in dictionary {
          let values = pair.value.split(separator: ",")
          items.append(contentsOf: values.map { URLQueryItem(name: pair.key, value: String($0)) })
        }

        urlComponents.queryItems = items
        urlRequest.url = urlComponents.url
      }
    }

    if T.ResponseType.self is Decodable {
      urlRequest.addValueIfEmpty("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
    }

    self.session.dataTask(with: urlRequest) { data, response, error in
      if let error = error {
        return completion(.failure(error))
      }

      let data = data ?? {
        assertionFailure("NETWORKING: response contained no data and no error")
        return Data()
      }()
      let statusCode = (response as? HTTPURLResponse)?.statusCode ?? {
        assertionFailure("NETWORKING: failed to get status code from response")
        return 200
      }()

      request.proccess(
        response: NetworkResponse(data: data, statusCode: statusCode),
        completion: completion
      )
    }.resume()
  }
}

extension URLRequest {
  /// Add the given value and header field only if the header field doesn't already exist.
  fileprivate mutating func addValueIfEmpty(
    _ value: String,
    forHTTPHeaderField headerField: String
  ) {
    guard self.allHTTPHeaderFields?[value] == nil else { return }
    self.addValue(value, forHTTPHeaderField: headerField)
  }
}

extension NetworkMethod {
  var stringValue: String {
    switch self {
    case .get: return "GET"
    case .post: return "POST"
    case .put: return "PUT"
    case .patch: return "PATCH"
    case .delete: return "DELETE"
    }
  }
}
