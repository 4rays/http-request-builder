@resultBuilder
struct RequestBuilder {
  static func buildBlock(_ components: RequestMiddleware...) -> RequestMiddleware {
    {
      try components.reduce($0) { transformed, component in
        return try component(transformed)
      }
    }
  }

  static func buildOptional(
    _ component: RequestMiddleware?
  ) -> RequestMiddleware {
    component ?? identity
  }

  static func buildEither(
    first component: @escaping RequestMiddleware
  ) -> RequestMiddleware {
    component
  }

  static func buildEither(
    second component: @escaping RequestMiddleware
  ) -> RequestMiddleware {
    component
  }
}
