import Foundation

enum NetworkMethod {
  case get
  case post
  case put
  case patch
  case delete
}

struct EncodableType: Encodable {
  private let encodable: Encodable

  init(_ encodable: Encodable) {
    self.encodable = encodable
  }

  func encode(to encoder: Encoder) throws {
    try self.encodable.encode(to: encoder)
  }
}

enum RequestTask {
  case empty
  case bodyData(Data)
  case bodyEncodable(encodable: EncodableType, encoder: JSONEncoder)
  case params(dictionary: [String: String])
}

struct NetworkResponse {
  let data: Data
  let statusCode: Int
}

/// Metadata for a request and handler when the request succeeds.
protocol NetworkRequest {
  associatedtype ResponseType

  /// Base url of request (e.g. "https://www.google.com/").
  var baseURL: URL { get }

  /// Concatenated url path (e.g. "todos/2/sub-tasks").
  ///
  /// Path can be an empty string.
  var path: String { get }

  /// Request method.
  var method: NetworkMethod { get }

  /// Request headers.
  var headers: [String: String] { get }

  /// Request body.
  ///
  /// Add encoded types to the request body using `RequestTask.bodyEncodable(:encoder:)`.
  var payload: RequestTask { get }

  /// Process the fetched response data.
  ///
  /// This method is invoked by the `NetworkingService` when the dataTask of `URLSession` responds
  /// back with no error.
  ///
  /// - Parameter response: contains the body and status code of the request.
  func proccess(
    response: NetworkResponse,
    completion: @escaping (Result<ResponseType, Error>) -> Void
  )
}

/// Fetch `Codable` types or perform a RESTful request.
protocol NetworkingService {
  /// Construct the given request into a `URLRequest`.
  ///
  /// Uses `URLSession:dataTask(urlRequest:completion:)` to perform the request.
  ///
  /// Additional request headers are set if the given `request`'s `payload` contains an `Encodable`
  /// type such as Content-Type and Accept if the `request`'s `ResponseType` is `Decodable`.
  ///
  /// - Parameter request: metadata for constructing the `URLRequest`.
  func process<T: NetworkRequest>(
    request: T,
    completion: @escaping (Result<T.ResponseType, Error>) -> Void
  )
}
