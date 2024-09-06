import Foundation

/// A type representing a URL path.
public struct Path: Hashable, Sendable {
  /// The fragments of the path.
  public var fragments: [String]
}

extension Path: ExpressibleByStringLiteral {
  public init(_ fragments: [String] = []) {
    self.fragments = fragments
  }

  public init(_ string: String) {
    guard !string.isEmpty
    else {
      self.fragments = []
      return
    }

    if string.first == "/" {
      self.fragments = string.dropFirst().components(separatedBy: "/")
    } else {
      self.fragments = string.components(separatedBy: "/")
    }
  }

  public init(stringLiteral value: String) {
    self.init(value)
  }

  public var fullPath: String {
    fragments.joined(separator: "/")
  }
}

// MARK: - Custom Operators
public func / (
  lhs: String,
  rhs: String
) -> Path {
  .init([lhs, rhs])
}

public func / (
  lhs: Path,
  rhs: String
) -> Path {
  var new = lhs
  new.fragments.append(rhs)
  return new
}

public func / (
  lhs: Path,
  rhs: [String]
) -> Path {
  var new = lhs
  new.fragments.append(contentsOf: rhs)
  return new
}

public func / (
  lhs: Path,
  rhs: CustomStringConvertible
) -> Path {
  var new = lhs
  new.fragments.append(rhs.description)
  return new
}
