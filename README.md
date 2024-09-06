# HTTPRequestBuilder

A Swift package to help build HTTP requests in a composable and type-safe way.

## Installation

Add the following to your `Package.swift` file:

```swift
dependencies: [
  .package(url: "", from: "0.9.0")
]
```

## Overview

This library provides a result builder and supporting types
to define HTTP requests in Swift. It relies on function composition (`pipe`)
to create reusable request middleware that can be used in turn to create
platform specific requests, such as `URLRequest` in Foundation.

Function composition shines in this task as REST APIs are often built
using the same middleware approach, resulting in most requests sharing
a lot of the same logic such as paths, authentication, headers, etc.

Author note: I gave a talk about this topic here.

## Usage

Define one request middleware per endpoint.
The library comes with a few commonly used middleware functions that can
be further composed to build your own middleware, such as `header(key:value:)` used below.

```swift
import HTTPRequestBuilder

// Use a variable if the request does not take any parameters
@RequestBuilder
var getUsers: RequestMiddleware = {
  "/users"
  Method.post
  header(key: "Content-Type", value: "application/json")
  header(key: "Accept", value: "application/json")
}

// Use a function if the request takes parameters
@RequestBuilder
func getUser(id: Int) -> RequestMiddleware {
  "/users/\(id)"
  Method.get
  header(key: "Accept", value: "application/json")
}
```

Note that the order inside the builder does not matter and middleware are applied
in the order they are defined. If the same middleware is defined multiple times,
the last one will be used. If you're defining custom middleware, try to make them idempotent so as to
avoid unexpected behavior.

Once you have an endpoint defined, you can use it to create a request for Foundation.

```swift
import Foundation

let urlRequest = URLRequest(
  getUsers(),
  baseURL: URL(string: "https://api.example.com")!
)

func getUser(id: Int) -> URLRequest {
  URLRequest(
    getUser(id: id),
    baseURL: URL(string: "https://api.example.com")!
  )
}
```

## Paths

This library comes with a `Path` type that can be used to define paths in a type-safe way.
Paths can be defined as string literals or arrays. There is even a custom operator that works on strings or other paths.

```swift
let path1: Path = "/users/12"
print(path1.fragments) // ["users", "12"]

let users = "users"

let path2: Path = users/"12"
print(path2.fragments) // ["users", "12"]

enum Action: String {
  case edit
  case view
}

let path3: Path = users/12/Action.edit
print(path3.fragments) // ["users", "12", "edit"]
```

My composing paths this way, it's easy to reuse parts of the path across different endpoints.

```swift
let version = "v1"
let api = "api"/version

let users = api/"users"
let createUser = users/Action.create

let games = api/"games"
let createGame = games/"create"
let featuredGames = games/"featured"
```

## Authentication Middleware

This library comes with a couple middleware functions to help with authentication.

### Basic Authentication

```swift
import HTTPRequestBuilder

@RequestBuilder
var signIn: RequestMiddleware = {
  "/sing-in"
  Method.get
  basicAuth(username: "user", password: "password")
}
```

### Bearer Token Authentication

```swift
import HTTPRequestBuilder

@RequestBuilder
var signIn: RequestMiddleware = {
  "/sing-in"
  Method.get
  bearerToken("some-token")
}
```

## Custom Middleware

A middleware is a function that takes a request and returns a new request.

```swift
(Request) throws -> (Request)
```

You can define your own middleware functions to encapsulate common logic
unique to your use case.

```swift
import HTTPRequestBuilder

func myHeaderMiddleware(
  value: String
) -> RequestMiddleware {
  header(key: "X-Custom-Header", value: value)
}
```

Your custom middleware can then be used in the same way as the built-in middleware.

```swift
import HTTPRequestBuilder

@RequestBuilder
var myRequest: RequestMiddleware = {
  "/path"
  Method.get
  myHeaderMiddleware(value: "some-value")
}
```

## License

This library is released under the MIT license. See LICENSE for details.
