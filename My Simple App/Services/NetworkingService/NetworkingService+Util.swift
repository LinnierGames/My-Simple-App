import Foundation

extension RequestTask {
  /// Wraps the given `Encodable` in a concrete type to be encoded as the request's body data.
  static func bodyEncodable(
    _ encodable: Encodable,
    encoder: JSONEncoder = JSONEncoder()
  ) -> RequestTask {
    return .bodyEncodable(encodable: EncodableType(encodable), encoder: encoder)
  }

  /// Creates a params task for the given dictionary.
  ///
  /// - Parameter dictionary: values can only be `String` or `[String]`. Otherwise, the param item
  /// will be omitted.
  static func params(dictionary: [String: Any]) -> RequestTask {
    let mappedDictionary = dictionary.compactMapValues { value -> String? in
      if let string = value as? String {
        return string
      }
      if let strings = value as? [String] {

        /// Compress the array of strings from ["foo", "", "bar"] to "foo,bar"
        return strings.filter({ !$0.isEmpty }).joined(separator: ",")
      }

      return nil
    }

    return .params(dictionary: mappedDictionary)
  }
}
