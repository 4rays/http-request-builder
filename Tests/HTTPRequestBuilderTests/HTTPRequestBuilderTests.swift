import XCTest

@testable import HTTPRequestBuilder

final class HTTPRequestBuilderTests: XCTestCase {
  func testFullURL() throws {
    let request = Request(
      method: .get,
      path: "/users/12",
      queryItems: [.init(name: "page", value: "1")]
    )
    let fullURL = try request.fullURL(with: "https://api.example.com")

    // Then
    XCTAssertEqual(fullURL, URL(string: "https://api.example.com/users/12?page=1"))
  }

  func testPath() throws {
    let path: Path = "/users/12"
    XCTAssertEqual(path.fragments, ["users", "12"])
  }

  func testPathCustomOperators() {
    let path1: Path = "users" / "12"
    XCTAssertEqual(path1.fragments, ["users", "12"])

    let users = "users"

    let path2: Path = users / "12"
    XCTAssertEqual(path2.fragments, ["users", "12"])

    let path3: Path = users / 3
    XCTAssertEqual(path3.fragments, ["users", "3"])

    enum Action: String {
      case edit
      case view
    }

    let path4: Path = users / Action.edit
    XCTAssertEqual(path4.fragments, ["users", "edit"])

    let path5 = Path("users") / "12"
    XCTAssertEqual(path5.fragments, ["users", "12"])

    func apiVersion(_ version: Int) -> Path {
      .init("v\(version)") / path5.fragments
    }

    let path6 = apiVersion(1)
    XCTAssertEqual(path6.fragments, ["v1", "users", "12"])
  }

  func testResultBuilder() throws {
    @RequestBuilder
    var example: RequestMiddleware {
      path("/users/12")
      postRequest
      header(key: "Content-Type", value: "application/json")
    }

    let request = Request()
    let newRequest = try example(request)

    XCTAssertEqual(newRequest.method, .post)
    XCTAssertEqual(newRequest.headers["Content-Type"], "application/json")
    XCTAssertEqual(newRequest.path.fragments, ["users", "12"])
  }

  func testResultBuilder_alternateSyntax() throws {
    @RequestBuilder
    var example: RequestMiddleware {
      "/users/12"
      Method.post
      header(key: "Content-Type", value: "application/json")
    }

    let request = Request()
    let newRequest = try example(request)

    XCTAssertEqual(newRequest.method, .post)
    XCTAssertEqual(newRequest.headers["Content-Type"], "application/json")
    XCTAssertEqual(newRequest.path.fragments, ["users", "12"])
  }

  func testURLRequestConversion() throws {
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

    XCTAssertEqual(urlRequest.httpMethod, "POST")
    XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Content-Type"], "application/json")
    XCTAssertEqual(urlRequest.url, URL(string: "https://api.example.com/users/12"))
  }

  func testPathAppending() throws {
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

    XCTAssertEqual(request.path.fragments, ["users", "12", "edit", "3"])
  }
}
