import Foundation

/// A type representing a query item.
public struct QueryItem: Sendable, Hashable {
  public var name: String
  public var value: String?

  public init(
    name: String,
    value: String? = nil
  ) {
    self.name = name
    self.value = value
  }
}

extension QueryItem {
  public var urlQueryItem: URLQueryItem {
    .init(name: name, value: value)
  }
}
