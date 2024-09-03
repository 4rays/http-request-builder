import Foundation

public enum RequestError: Error, Equatable {
  case missingBaseURL
  case malformedRequestURL
}
