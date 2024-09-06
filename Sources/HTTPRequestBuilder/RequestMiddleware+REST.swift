import Foundation

/// A GET request middleware.
public let getRequest = method(.get)

/// A request middleware for JSON content type.
public let jsonContentRequest = header(
  key: "Content-Type",
  value: "application/json; charset=utf-8"
)

/// A request middleware for JSON accept type.
public let acceptRequest = header(
  key: "Accept",
  value: "application/json; charset=utf-8"
)

/// A request middleware for JSON content and accept type.
@RequestBuilder
public var jsonRequest: RequestMiddleware {
  jsonContentRequest
  acceptRequest
}

/// A POST request middleware.
@RequestBuilder
public var postRequest: RequestMiddleware {
  method(.post)
  jsonRequest
}

/// A PUT request middleware.
@RequestBuilder
public var putRequest: RequestMiddleware {
  method(.put)
  jsonRequest
}

/// A PATCH request middleware.
@RequestBuilder
public var patchRequest: RequestMiddleware {
  method(.patch)
  jsonRequest
}

/// A DELETE request middleware.
@RequestBuilder
public var deleteRequest: RequestMiddleware {
  method(.delete)
  jsonRequest
}

/// A POST request middleware for an Encodable type as body.
/// - Parameters:
///  - body: The body to encode.
///  - encoder: The JSON encoder to use.
/// - Returns: A request middleware.
@RequestBuilder
public func post<T>(
  _ payload: T,
  encoder: JSONEncoder = .init()
) -> RequestMiddleware where T: Encodable {
  postRequest
  body(payload, encoder: encoder)
}

/// A POST request middleware for a data body.
/// - Parameter data: The data to use as the body.
/// - Returns: A request middleware.
@RequestBuilder
public func post(
  data: Data
) -> RequestMiddleware {
  postRequest
  body(data)
}

/// A PUT request middleware for an Encodable type as body.
/// - Parameters:
///  - body: The body to encode.
///  - encoder: The JSON encoder to use.
/// - Returns: A request middleware.
@RequestBuilder
public func put<T>(
  _ payload: T,
  encoder: JSONEncoder = .init()
) -> RequestMiddleware where T: Encodable {
  putRequest
  body(payload, encoder: encoder)
}

/// A PUT request middleware using a data body.
/// - Parameter data: The data to use as the body.
/// - Returns: A request middleware.
@RequestBuilder
public func put(
  data: Data
) -> RequestMiddleware {
  putRequest
  body(data)
}

/// A PATCH request middleware for an Encodable type as body.
/// - Parameters:
///  - body: The body to encode.
///  - encoder: The JSON encoder to use.
/// - Returns: A request middleware.
@RequestBuilder
public func patch<T>(
  _ payload: T,
  encoder: JSONEncoder = .init()
) -> RequestMiddleware where T: Encodable {
  patchRequest
  body(payload, encoder: encoder)
}

/// A PATCH request middleware using a data body.
/// - Parameter data: The data to use as the body.
/// - Returns: A request middleware.
@RequestBuilder
public func patch(
  data: Data
) -> RequestMiddleware {
  patchRequest
  body(data)
}

/// A DELETE request middleware for an Encodable type as body.
/// - Parameters:
///   - body: The body to encode.
///   - encoder: The JSON encoder to use.
/// - Returns: A request middleware.
@RequestBuilder
public func delete<T>(
  _ payload: T,
  encoder: JSONEncoder = .init()
) -> RequestMiddleware where T: Encodable {
  deleteRequest
  body(payload, encoder: encoder)
}

/// A DELETE request middleware using a data body.
/// - Parameter data: The data to use as the body.
/// - Returns: A request middleware.
@RequestBuilder
public func delete(
  data: Data
) -> RequestMiddleware {
  deleteRequest
  body(data)
}
