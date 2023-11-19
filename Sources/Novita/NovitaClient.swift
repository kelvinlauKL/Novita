import HTTPTypes
import OpenAPIRuntime
import OpenAPIAsyncHTTPClient
import Foundation

public typealias Img2ImgRequest = Components.Schemas.Img2ImgRequest
public typealias Img2ImgResponse = Components.Schemas.Img2ImgResponse
public typealias ProgressResponse = Components.Schemas.ProgressResponse

public struct NovitaClient {
  public enum Error: LocalizedError {
    case undocumentedResponse(description: String)
  }
  
  private let client: Client
  
  public init(apiKey: String) {
    self.client = .init(
      serverURL: try! Servers.server1(),
      transport: AsyncHTTPClientTransport(configuration: .init()),
      middlewares: [
        AuthenticationMiddleware(bearerToken: apiKey)
      ]
    )
  }
  
  public func getImg2Img(_ request: Img2ImgRequest) async throws -> Img2ImgResponse {
    let input = Operations.getImg2Img.Input(body: .json(request))
    let response = try await client.getImg2Img(input)
    switch response {
    case .ok(let output):
      return try output.body.json
    case let .undocumented(statusCode, payload):
      throw Error.undocumentedResponse(description: "Status code: \(statusCode)\nUndocumented payload: \(String(describing: payload))")
    }
  }
  
  public func getProgress(taskId: String) async throws -> ProgressResponse {
    let response = try await client.getProgress(query: .init(task_id: taskId))
    switch response {
    case .ok(let output):
      return try output.body.json
    case let .undocumented(statusCode, payload):
      throw Error.undocumentedResponse(description: "Status code: \(statusCode)\nUndocumented payload: \(String(describing: payload))")
    }
  }
}
