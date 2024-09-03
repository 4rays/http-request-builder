import Foundation
import HTTPTypes

public struct Request: Sendable, Hashable {
  public var method: HTTPMethod
  public var path: URLPath
  public var queryItems: [URLQueryItem]
  public var headers: [String: String]
  public var cachePolicy: URLRequest.CachePolicy
  public var timeoutInterval: TimeInterval
  public var body: Data?

  public init(
    method: HTTPMethod = .get,
    path: URLPath = .init(),
    headers: [String: String] = [:],
    queryItems: [URLQueryItem] = [],
    cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
    timeoutInterval: TimeInterval = 60.0
  ) {
    self.method = method
    self.path = path
    self.headers = headers
    self.queryItems = queryItems
    self.cachePolicy = cachePolicy
    self.timeoutInterval = timeoutInterval
  }

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

    components.queryItems = queryItems

    guard let urlWithQueries = components.url else {
      throw RequestError.malformedRequestURL
    }

    return urlWithQueries
  }
}
