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
public func / <T: RawRepresentable>(
  lhs: Path,
  rhs: T
) -> Path where T.RawValue == String {
  lhs / rhs.rawValue
}

public func / <T: RawRepresentable>(
  lhs: T,
  rhs: T
) -> Path where T.RawValue == String {
  var new = Path(lhs.rawValue)
  new.fragments.append(rhs.rawValue)
  return new
}

public func / <T: RawRepresentable>(
  lhs: CustomStringConvertible,
  rhs: T
) -> Path where T.RawValue == String {
  var new = Path(lhs.description)
  new.fragments.append(rhs.rawValue)
  return new
}

public func / <T: RawRepresentable>(
  lhs: T,
  rhs: CustomStringConvertible
) -> Path where T.RawValue == String {
  var new = Path(lhs.rawValue)
  new.fragments.append(rhs.description)
  return new
}

public func / (
  lhs: Path,
  rhs: [CustomStringConvertible]
) -> Path {
  var new = lhs
  new.fragments.append(contentsOf: rhs.map(\.description))
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

public func / (
  lhs: CustomStringConvertible,
  rhs: CustomStringConvertible
) -> Path {
  var new = Path(lhs.description)
  new.fragments.append(rhs.description)
  return new
}
