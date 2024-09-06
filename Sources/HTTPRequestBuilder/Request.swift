import Foundation

/// An honest-to-goodness HTTP request.
public struct Request: Sendable, Hashable {
  public var method: Method
  public var path: Path
  public var queryItems: [QueryItem]
  public var headers: [String: String]
  public var body: Data?

  public init(
    method: Method = .get,
    path: Path = .init(),
    headers: [String: String] = [:],
    queryItems: [QueryItem] = [],
    body: Data? = nil
  ) {
    self.method = method
    self.path = path
    self.headers = headers
    self.queryItems = queryItems
    self.body = body
  }

  /// The full URL of the request.
  /// - Parameter baseURL: The base URL to use.
  /// - Throws: `RequestError` if the base URL is missing or invalid.
  /// - Returns: A URL.
  public func fullURL(with baseURL: String) throws -> URL {
    guard
      var baseURL = URL(string: baseURL)
    else {
      throw RequestError.missingBaseURL
    }

    path.fragments.forEach {
      baseURL.appendPathComponent($0)
    }

    if queryItems.isEmpty {
      return baseURL
    }

    // Query Items
    guard
      var components = URLComponents(
        url: baseURL,
        resolvingAgainstBaseURL: true
      )
    else {
      throw RequestError.malformedRequestURL
    }

    components.queryItems = queryItems.map(\.urlQueryItem)

    guard let urlWithQueries = components.url else {
      throw RequestError.malformedRequestURL
    }

    return urlWithQueries
  }
}
