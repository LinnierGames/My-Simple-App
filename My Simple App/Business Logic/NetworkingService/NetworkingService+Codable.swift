import Foundation

extension NetworkRequest where ResponseType: Decodable {
  /// Uses the default `JSONDecoder` and decodes the given response data into the `Decodable` type.
  func proccess(
    response: NetworkResponse,
    completion: @escaping (Result<ResponseType, Error>) -> Void
  ) {
    do {
      let response = try JSONDecoder().decode(ResponseType.self, from: response.data)
      completion(.success(response))
    } catch {
      completion(.failure(error))
    }
  }
}

extension NetworkRequest where ResponseType == Void {
  /// Returns a completed promise.
  func proccess(
    response: NetworkResponse,
    completion: @escaping (Result<ResponseType, Error>) -> Void
  ) {
    completion(.success(()))
  }
}

// TODO: try to create a default mapper from Decodable to custom type.
//struct DecoderMaper<T: Decodable, G> {
//  init(mapper: (T) -> G) {
//
//  }
//}
//
//struct DecodableType: Decodable {
//  private let encodable: Decodable
//
//  init(_ encodable: Decodable) {
//    self.encodable = encodable
//  }
//
//  init(from decoder: Decoder) throws {
//    fatalError()
//  }
//}
//
//extension NetworkRequest where ResponseType == DecoderMaper<DecodableType, Any> {
//  /// Uses the default `JSONDecoder` and decodes the given response data into the `Decodable` type
//  func proccess(
//    response: NetworkResponse,
//    completion: @escaping (Result<ResponseType, Error>) -> Void
//  ) {
//    do {
//      let response = try JSONDecoder().decode(ResponseType., from: response.data)
//      completion(.success(response))
//    } catch {
//      completion(.failure(error))
//    }
//  }
//}
