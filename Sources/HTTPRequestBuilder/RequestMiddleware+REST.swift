import Foundation

/// A GET request middleware.
public let getRequest = requestMethod(.get)

/// A request middleware for JSON content type.
public let jsonContentRequest = requestHeader(
  key: "Content-Type",
  value: "application/json; charset=utf-8"
)

/// A request middleware for JSON accept type.
public let acceptRequest = requestHeader(
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
  requestMethod(.post)
  jsonRequest
}

/// A PUT request middleware.
@RequestBuilder
public var putRequest: RequestMiddleware {
  requestMethod(.put)
  jsonRequest
}

/// A PATCH request middleware.
@RequestBuilder
public var patchRequest: RequestMiddleware {
  requestMethod(.patch)
  jsonRequest
}

/// A DELETE request middleware.
@RequestBuilder
public var deleteRequest: RequestMiddleware {
  requestMethod(.delete)
  jsonRequest
}

/// A POST request middleware for an Encodable type as body.
/// - Parameters:
///  - body: The body to encode.
///  - encoder: The JSON encoder to use.
/// - Returns: A request middleware.
@RequestBuilder
public func post<T>(
  body: T,
  encoder: JSONEncoder = .init()
) -> RequestMiddleware where T: Encodable {
  postRequest
  requestBody(body, encoder: encoder)
}

/// A POST request middleware for a data body.
/// - Parameter data: The data to use as the body.
/// - Returns: A request middleware.
@RequestBuilder
public func post(
  data: Data
) -> RequestMiddleware {
  postRequest
  requestBody(data)
}

/// A PUT request middleware for an Encodable type as body.
/// - Parameters:
///  - body: The body to encode.
///  - encoder: The JSON encoder to use.
/// - Returns: A request middleware.
@RequestBuilder
public func put<T>(
  body: T,
  encoder: JSONEncoder = .init()
) -> RequestMiddleware where T: Encodable {
  putRequest
  requestBody(body, encoder: encoder)
}

/// A PUT request middleware using a data body.
/// - Parameter data: The data to use as the body.
/// - Returns: A request middleware.
@RequestBuilder
public func put(
  data: Data
) -> RequestMiddleware {
  putRequest
  requestBody(data)
}

/// A PATCH request middleware for an Encodable type as body.
/// - Parameters:
///  - body: The body to encode.
///  - encoder: The JSON encoder to use.
/// - Returns: A request middleware.
@RequestBuilder
public func patch<T>(
  body: T,
  encoder: JSONEncoder = .init()
) -> RequestMiddleware where T: Encodable {
  patchRequest
  requestBody(body, encoder: encoder)
}

/// A PATCH request middleware using a data body.
/// - Parameter data: The data to use as the body.
/// - Returns: A request middleware.
@RequestBuilder
public func patch(
  data: Data
) -> RequestMiddleware {
  patchRequest
  requestBody(data)
}

/// A DELETE request middleware for an Encodable type as body.
/// - Parameters:
///   - body: The body to encode.
///   - encoder: The JSON encoder to use.
/// - Returns: A request middleware.
@RequestBuilder
public func delete<T>(
  body: T,
  encoder: JSONEncoder = .init()
) -> RequestMiddleware where T: Encodable {
  deleteRequest
  requestBody(body, encoder: encoder)
}

/// A DELETE request middleware using a data body.
/// - Parameter data: The data to use as the body.
/// - Returns: A request middleware.
@RequestBuilder
public func delete(
  data: Data
) -> RequestMiddleware {
  deleteRequest
  requestBody(data)
}
