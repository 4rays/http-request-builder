/// A result builder for composing request middlewares.
///
/// This builder allows you to compose multiple request middlewares together. For example:
///
/// ```swift
/// let middleware = requestMiddleware {
///   requestMethod(.get)
///   requestHeader(key: "Content-Type", value: "application/json")
/// }
/// ```
@resultBuilder
public struct RequestBuilder {
  public static func buildBlock(_ components: RequestMiddleware...) -> RequestMiddleware {
    {
      try components.reduce($0) { transformed, component in
        return try component(transformed)
      }
    }
  }

  public static func buildArray(_ components: [RequestMiddleware]) -> RequestMiddleware {
    {
      try components.reduce($0) { transformed, component in
        return try component(transformed)
      }
    }
  }

  public static func buildExpression(_ middleware: @escaping RequestMiddleware) -> RequestMiddleware
  {
    middleware
  }

  public static func buildExpression(_ urlPath: Path) -> RequestMiddleware {
    path(urlPath)
  }

  public static func buildExpression(_ urlMethod: Method) -> RequestMiddleware {
    method(urlMethod)
  }

  public static func buildOptional(
    _ component: RequestMiddleware?
  ) -> RequestMiddleware {
    component ?? identity
  }

  public static func buildEither(
    first component: @escaping RequestMiddleware
  ) -> RequestMiddleware {
    component
  }

  public static func buildEither(
    second component: @escaping RequestMiddleware
  ) -> RequestMiddleware {
    component
  }
}
