import Foundation

extension Request {
  /// Creates a Foundation `URLRequest`` from the request.
  /// - Parameters:
  ///  - baseURL: The base URL to use.
  ///  - cachePolicy: The cache policy to use.
  ///  - timeoutInterval: The timeout interval to use.
  /// - Throws: `RequestError` if the base URL is missing or invalid.
  /// - Returns: A URL request.
  public func urlRequest(
    baseURL: String,
    cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
    timeoutInterval: TimeInterval = 60
  ) throws -> URLRequest {
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

extension URLRequest {
  public init(
    _ middleware: RequestMiddleware,
    baseURL: String,
    cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
    timeoutInterval: TimeInterval = 60
  ) throws {
    let request = try middleware(Request())

    self = try request.urlRequest(
      baseURL: baseURL,
      cachePolicy: cachePolicy,
      timeoutInterval: timeoutInterval
    )
  }
}
