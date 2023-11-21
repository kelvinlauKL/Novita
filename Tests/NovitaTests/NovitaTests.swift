import XCTest
import Novita
import HTTPTypes
import OpenAPIRuntime
import Foundation

final class NovitaTests: XCTestCase {
  func testImg2Img() async throws {
    let client = NovitaClient(apiKey: ProcessInfo.processInfo.environment["API_KEY"]!)
    let req = Img2ImgRequest(
      prompt: "ironman",
      sampler_name: .DPM_plus__plus__space_2M_space_Karras,
      batch_size: 1,
      n_iter: 1,
      steps: 20,
      cfg_scale: 7,
      height: 1024,
      width: 568,
      model_name: "realisticVisionV30_v30VAE_74303.safetensors",
      init_images: [base64String(forImageFileName: "Ironman.png")]
    )
    let response = try await client.getImg2Img(req)
    XCTAssertEqual(response.code, 0)
    XCTAssertTrue(response.msg.isEmpty)
    XCTAssertFalse(response.data.task_id.isEmpty)
    XCTAssertNil(response.data.warn)
  }
  
  func testGetProgress() async throws {
    let client = NovitaClient(apiKey: ProcessInfo.processInfo.environment["API_KEY"]!)
    let response = try await client.getProgress(taskId: "5b4cd16f-4905-4502-a497-18cc0a78f0d5")
    XCTAssertEqual(response.code, 0)
    XCTAssertTrue(response.msg.isEmpty)
    XCTAssertEqual(response.data.status, 2)
    XCTAssertEqual(response.data.progress, 1.0)
    XCTAssertEqual(response.data.eta_relative, 0.0)
    XCTAssertEqual(response.data.imgs, ["https://stars-test.s3.amazonaws.com/free-prod/5b4cd16f-4905-4502-a497-18cc0a78f0d5-0.png"])
    XCTAssertTrue(response.data.failed_reason?.isEmpty == true)
    XCTAssertNil(response.data.current_images)
  }
  
  func testMergeFaceResponse() async throws {
    let client = NovitaClient(apiKey: ProcessInfo.processInfo.environment["API_KEY"]!)
    let angelina = base64String(forImageFileName: "angelina.png")
    let conan = base64String(forImageFileName: "conan.png")
    let response = try await client.mergeFace(faceImageString: angelina, imageString: conan)
    XCTAssertFalse(response.image_file.isEmpty)
  }
}

private extension NovitaTests {
  func base64String(forImageFileName fileName: String) -> String {
    let url = Bundle.module.url(forResource: fileName, withExtension: nil)!
    return try! Data(contentsOf: url).base64EncodedString()
  }
}
