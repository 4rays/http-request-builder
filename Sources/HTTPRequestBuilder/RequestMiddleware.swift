import Foundation

/// A function that transforms a request.
public typealias RequestMiddleware = @Sendable (Request) throws -> (Request)

/// The identity middleware that does nothing.
public let identity: RequestMiddleware = { $0 }

/// Add path components to the request.
/// - Parameter components: The path components to add.
/// - Returns: A request middleware.
public func path(
  _ path: Path
) -> RequestMiddleware {
  { request in
    var newRequest = request
    newRequest.path = path
    return newRequest
  }
}

/// Add headers to the request.
/// - Parameters:
///  - key: The header key.
///  - value: The header value.
/// - Returns: A request middleware.
public func header(
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
public func method(
  _ method: Method
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
public func body<T>(
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
public func queries(
  _ content: [String: String]
) -> RequestMiddleware {
  { request in
    var newRequest = request
    newRequest.queryItems = content.reduce(
      [],
      { items, keyValue in
        let item = QueryItem(name: keyValue.0, value: keyValue.1)
        var newItems = items
        newItems.append(item)
        return newItems
      })
    return newRequest
  }
}
