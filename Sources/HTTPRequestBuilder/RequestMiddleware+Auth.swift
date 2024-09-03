import Foundation

/// Add a bearer auth header to the request
/// - Parameter token: The Bearer token to use.
/// - Returns: A request middleware.
public func bearerAuth(_ token: String) -> RequestMiddleware {
  requestHeader(key: "Authorization", value: "Bearer \(token)")
}

/// Add a basic auth header to the request.
/// - Parameters:
/// - username: The username to use.
/// - password: The password to use.
/// - Returns: A request middleware.
public func basicAuth(
  username: String,
  password: String
) -> RequestMiddleware {
  let credentials = Data("\(username):\(password)".utf8).base64EncodedString()
  return requestHeader(key: "Authorization", value: "Basic \(credentials)")
}
