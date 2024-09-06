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
    let path: Path = "users" / "12"
    XCTAssertEqual(path.fragments, ["users", "12"])
  }

  func testResultBuilder() throws {
    @RequestBuilder
    var postRequest: RequestMiddleware {
      requestMethod(.post)
      requestHeader(key: "Content-Type", value: "application/json")
    }

    let request = Request()
    let newRequest = try postRequest(request)

    XCTAssertEqual(newRequest.method, .post)
    XCTAssertEqual(newRequest.headers["Content-Type"], "application/json")
  }
}
