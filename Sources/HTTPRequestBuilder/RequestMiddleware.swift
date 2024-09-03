import Foundation

/// A function that transforms a request.
public typealias RequestMiddleware = @Sendable (Request) throws -> (Request)

/// A result builder for request middleware.
public func requestMiddleware(
  @RequestBuilder build: () -> RequestMiddleware
) -> RequestMiddleware {
  build()
}

/// The identity middleware that does nothing.
public let identity: RequestMiddleware = { $0 }

/// Add headers to the request.
/// - Parameters:
///  - key: The header key.
///  - value: The header value.
/// - Returns: A request middleware.
public func requestHeader(
  key: String,
  value: String
) -> RequestMiddleware {
  { request in
    var newRequest = request
    newRequest.headers[key] = value
    return newRequest
  }
}

/// Add a method to the request.
/// - Parameter method: The HTTP method to use.
/// - Returns: A request middleware.
public func requestMethod(
  _ method: HTTPMethod
) -> RequestMiddleware {
  { request in
    var newRequest = request
    newRequest.method = method
    return newRequest
  }
}

/// Add a body to the request.
/// - Parameters:
///  - content: The content to encode.
///  - encoder: The JSON encoder to use.
/// - Returns: A request middleware.
public func requestBody<T>(
  _ content: T,
  encoder: JSONEncoder = .init()
) -> RequestMiddleware where T: Encodable {
  { request in
    guard request.method != .get else { return request }
    var newRequest = request
    newRequest.body = try encoder.encode(content)
    return newRequest
  }
}

/// Add queries to the request.
/// - Parameter content: The queries to add.
/// - Returns: A request middleware.
public func requestQueries(
  _ content: [String: String]
) -> RequestMiddleware {
  { request in
    var newRequest = request
    newRequest.queryItems = content.reduce(
      [],
      { items, keyValue in
        let item = URLQueryItem(name: keyValue.0, value: keyValue.1)
        var newItems = items
        newItems.append(item)
        return newItems
      })
    return newRequest
  }
}

/// Add a cache policy to the request.
/// - Parameter cachePolicy: The cache policy to use.
/// - Returns: A request middleware.
public func requestCachePolicy(
  _ cachePolicy: URLRequest.CachePolicy
) -> RequestMiddleware {
  { request in
    var newRequest = request
    newRequest.cachePolicy = cachePolicy
    return newRequest
  }
}

/// Add a timeout interval to the request.
/// - Parameter interval: The timeout interval to use.
/// - Returns: A request middleware.
public func requestTimeoutInterval(
  _ interval: TimeInterval
) -> RequestMiddleware {
  { request in
    var newRequest = request
    newRequest.timeoutInterval = interval
    return newRequest
  }
}
