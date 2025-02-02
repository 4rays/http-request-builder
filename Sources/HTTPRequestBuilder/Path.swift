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

  public init(_ fragments: String...) {
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

  public func appending(_ fragments: String...) -> Path {
    var new = self
    new.fragments.append(contentsOf: fragments)
    return new
  }

  public func appending(_ fragments: [String]) -> Path {
    var new = self
    new.fragments.append(contentsOf: fragments)
    return new
  }

  public func appending<T: RawRepresentable>(_ rawRepresentable: T...) -> Path
  where T.RawValue == String {
    var new = self
    new.fragments.append(contentsOf: rawRepresentable.map(\.rawValue))
    return new
  }

  public func appending(_ description: CustomStringConvertible...) -> Path {
    var new = self
    new.fragments.append(contentsOf: description.map(\.description))
    return new
  }
}
