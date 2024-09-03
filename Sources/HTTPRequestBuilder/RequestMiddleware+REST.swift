import Foundation

/// A GET request middleware.
public let getRequest: RequestMiddleware = requestMethod(.get)

/// A request middleware for JSON content type.
public let jsonContentRequest: RequestMiddleware = requestHeader(
  key: "Content-Type",
  value: "application/json; charset=utf-8"
)

/// A request middleware for JSON accept type.
public let acceptRequest: RequestMiddleware = requestHeader(
  key: "Accept",
  value: "application/json; charset=utf-8"
)

/// A request middleware for JSON content and accept type.
public let jsonRequest = requestMiddleware {
  jsonContentRequest
  acceptRequest
}

/// A POST request middleware.
public let postRequest = requestMiddleware {
  requestMethod(.post)
  jsonRequest
}

/// A PUT request middleware.
public let putRequest = requestMiddleware {
  requestMethod(.put)
  jsonRequest
}

/// A PATCH request middleware.
public let patchRequest = requestMiddleware {
  requestMethod(.patch)
  jsonRequest
}

/// A DELETE request middleware.
public let deleteRequest = requestMiddleware {
  requestMethod(.delete)
  jsonRequest
}

/// A POST request middleware for an Encodable type as body.
/// - Parameters:
///  - body: The body to encode.
///  - encoder: The JSON encoder to use.
/// - Returns: A request middleware.
public func post<T>(
  body: T,
  encoder: JSONEncoder = .init()
) -> RequestMiddleware where T: Encodable {
  requestMiddleware {
    postRequest
    requestBody(body, encoder: encoder)
  }
}

/// A POST request middleware for a data body.
/// - Parameter data: The data to use as the body.
/// - Returns: A request middleware.
public func post(
  data: Data
) -> RequestMiddleware {
  requestMiddleware {
    postRequest
    requestBody(data)
  }
}

/// A PUT request middleware for an Encodable type as body.
/// - Parameters:
///  - body: The body to encode.
///  - encoder: The JSON encoder to use.
/// - Returns: A request middleware.
public func put<T>(
  body: T,
  encoder: JSONEncoder = .init()
) -> RequestMiddleware where T: Encodable {
  requestMiddleware {
    putRequest
    requestBody(body, encoder: encoder)
  }
}

/// A PUT request middleware using a data body.
/// - Parameter data: The data to use as the body.
/// - Returns: A request middleware.
public func put(
  data: Data
) -> RequestMiddleware {
  requestMiddleware {
    putRequest
    requestBody(data)
  }
}

/// A PATCH request middleware for an Encodable type as body.
/// - Parameters:
///  - body: The body to encode.
///  - encoder: The JSON encoder to use.
/// - Returns: A request middleware.
public func patch<T>(
  body: T,
  encoder: JSONEncoder = .init()
) -> RequestMiddleware where T: Encodable {
  requestMiddleware {
    patchRequest
    requestBody(body, encoder: encoder)
  }
}

/// A PATCH request middleware using a data body.
/// - Parameter data: The data to use as the body.
/// - Returns: A request middleware.
public func patch(
  data: Data
) -> RequestMiddleware {
  requestMiddleware {
    patchRequest
    requestBody(data)
  }
}

/// A DELETE request middleware for an Encodable type as body.
/// - Parameters:
///   - body: The body to encode.
///   - encoder: The JSON encoder to use.
/// - Returns: A request middleware.
public func delete<T>(
  body: T,
  encoder: JSONEncoder = .init()
) -> RequestMiddleware where T: Encodable {
  requestMiddleware {
    deleteRequest
    requestBody(body, encoder: encoder)
  }
}

/// A DELETE request middleware using a data body.
/// - Parameter data: The data to use as the body.
/// - Returns: A request middleware.
public func delete(
  data: Data
) -> RequestMiddleware {
  requestMiddleware {
    deleteRequest
    requestBody(data)
  }
}
