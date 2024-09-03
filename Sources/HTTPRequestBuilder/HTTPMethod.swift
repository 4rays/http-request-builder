public enum HTTPMethod: String, Sendable, Hashable {
  case get = "GET"
  case put = "PUT"
  case patch = "PATCH"
  case post = "POST"
  case delete = "DELETE"
  case head = "HEAD"
  case options = "OPTIONS"
  case trace = "TRACE"
  case connect = "CONNECT"
}
