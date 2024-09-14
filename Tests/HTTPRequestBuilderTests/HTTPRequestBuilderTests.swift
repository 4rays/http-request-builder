import Testing
import Foundation

@testable import HTTPRequestBuilder

extension Tag {
  @Tag static var builder: Self
  @Tag static var path: Self
  @Tag static var request: Self
}

@Test(.tags(.request)) func fullURL() throws {
  let request = Request(
    method: .get,
    path: "/users/12",
    queryItems: [.init(name: "page", value: "1")]
  )

  let fullURL = try request.fullURL(with: "https://api.example.com")
  #expect(fullURL == URL(string: "https://api.example.com/users/12?page=1"))
}

@Test(.tags(.request)) func path() throws {
  let path: Path = "/users/12"
  #expect(path.fragments == ["users", "12"])
}

@Test(.tags(.path, .request)) func pathCustomOperators() {
  let path1: Path = "users" / "12"
  #expect(path1.fragments == ["users", "12"])

  let users = "users"

  let path2: Path = users / "12"
  #expect(path2.fragments == ["users", "12"])

  let path3: Path = users / 3
  #expect(path3.fragments == ["users", "3"])

  enum Action: String {
    case edit
    case view
  }

  let path4: Path = users / Action.edit
  #expect(path4.fragments == ["users", "edit"])

  let path5 = Path("users") / "12"
  #expect(path5.fragments == ["users", "12"])

  func apiVersion(_ version: Int) -> Path {
    .init("v\(version)") / path5.fragments
  }

  let path6 = apiVersion(1)
  #expect(path6.fragments == ["v1", "users", "12"])
}

@Test(.tags(.builder)) func resultBuilder() throws {
  let request = Request()

  @RequestBuilder
  var example1: RequestMiddleware {
    path("/users/12")
    postRequest
    header(key: "Content-Type", value: "application/json")
  }

  let newRequest1 = try example1(request)

  #expect(newRequest1.method == .post)
  #expect(newRequest1.headers["Content-Type"] == "application/json")
  #expect(newRequest1.path.fragments == ["users", "12"])

  @RequestBuilder
  var example2: RequestMiddleware {
    "/users/12"
    Method.post
    header(key: "Content-Type", value: "application/json")
  }

  let newRequest2 = try example2(request)

  #expect(newRequest2.method == .post)
  #expect(newRequest2.headers["Content-Type"] == "application/json")
  #expect(newRequest2.path.fragments == ["users", "12"])
}

@Test(.tags(.request, .path)) func urlRequestConversion() throws {
  @RequestBuilder
  var example: RequestMiddleware {
    path("/users/12")
    postRequest
    header(key: "Content-Type", value: "application/json")
  }

  let request = try example(
    Request()
  )

  let urlRequest = try request.urlRequest(baseURL: "https://api.example.com")

  #expect(urlRequest.httpMethod == "POST")
  #expect(urlRequest.allHTTPHeaderFields?["Content-Type"] == "application/json")
  #expect(urlRequest.url == URL(string: "https://api.example.com/users/12"))
}

@Test(.tags(.path)) func pathAppending() throws {
  enum Action: String {
    case edit
    case view
  }

  @RequestBuilder
  var example: RequestMiddleware {
    path("/users")
    pathAppending("12")
    pathAppending(Action.edit)
    pathAppending(3)
  }

  let request = try example(
    Request()
  )

  #expect(request.path.fragments == ["users", "12", "edit", "3"])
}
