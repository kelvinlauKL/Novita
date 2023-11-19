import HTTPTypes
import OpenAPIRuntime
import Foundation

struct AuthenticationMiddleware: ClientMiddleware {
  let bearerToken: String
  
  func intercept(
    _ request: HTTPRequest,
    body: HTTPBody?,
    baseURL: URL,
    operationID: String,
    next: @Sendable (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
  ) async throws -> (HTTPResponse, HTTPBody?) {
    var request = request
    request.headerFields[.authorization] = "Bearer \(bearerToken)"
    return try await next(request, body, baseURL)
  }
}
