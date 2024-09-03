import Foundation

extension Request {
  /// Creates a Foundation `URLRequest`` from the request.
  /// - Parameter baseURL: The base URL to use.
  /// - Throws: `RequestError` if the base URL is missing or invalid.
  /// - Returns: A URL request.
  public func urlRequest(baseURL: String) throws -> URLRequest {
    var urlRequest = URLRequest(
      url: try fullURL(with: baseURL),
      cachePolicy: cachePolicy,
      timeoutInterval: timeoutInterval
    )

    urlRequest.httpMethod = method.rawValue
    urlRequest.httpBody = body

    headers.forEach {
      urlRequest.addValue(
        $0.value,
        forHTTPHeaderField: $0.key
      )
    }

    return urlRequest
  }
}
