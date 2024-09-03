import Foundation

public struct URLPath: Hashable, Sendable {
  public var fragments: [String]
}

extension URLPath: ExpressibleByStringLiteral {
  public init(_ fragments: [String] = []) {
    self.fragments = fragments
  }

  public init(_ string: String) {
    self.fragments = string.components(separatedBy: "/")
  }

  public init(stringLiteral value: String) {
    self.fragments = value.components(separatedBy: "/")
  }

  public var fullPath: String {
    fragments.joined(separator: "/")
  }
}

// MARK: - Custom Operators
public func / (
  lhs: String,
  rhs: String
) -> URLPath {
  .init([lhs, rhs])
}

public func / (
  lhs: URLPath,
  rhs: String
) -> URLPath {
  var new = lhs
  new.fragments.append(rhs)
  return new
}

public func / (
  lhs: URLPath,
  rhs: [String]
) -> URLPath {
  var new = lhs
  new.fragments.append(contentsOf: rhs)
  return new
}

public func / (
  lhs: URLPath,
  rhs: CustomStringConvertible
) -> URLPath {
  var new = lhs
  new.fragments.append(rhs.description)
  return new
}
