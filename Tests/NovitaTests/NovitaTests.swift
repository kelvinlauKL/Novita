import XCTest
import Novita

final class NovitaTests: XCTestCase {
  func testImg2Img() async throws {
    let novitaClient = NovitaClient(apiKey: ProcessInfo.processInfo.environment["API_KEY"]!)
    let url = Bundle.module.url(forResource: "Ironman.png", withExtension: nil)!
    let imgInBase64 = try Data(contentsOf: url).base64EncodedString()
    
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
      init_images: [imgInBase64]
    )
    let response = try await novitaClient.getImg2Img(req)
    XCTAssertEqual(response.code, 0)
    XCTAssertTrue(response.msg.isEmpty)
    XCTAssertFalse(response.data.task_id.isEmpty)
    XCTAssertNil(response.data.warn)
  }
  
  func testGetProgress() async throws {
    let novitaClient = NovitaClient(apiKey: ProcessInfo.processInfo.environment["API_KEY"]!)
    let response = try await novitaClient.getProgress(taskId: "62ad9eb6-7e42-45d3-9e77-d3a12dcb247b")
    XCTAssertEqual(response.code, 0)
    XCTAssertTrue(response.msg.isEmpty)
    XCTAssertEqual(response.data.status, 2)
    XCTAssertEqual(response.data.progress, 1.0)
    XCTAssertEqual(response.data.eta_relative, 0.0)
    XCTAssertEqual(response.data.imgs, ["https://stars-test.s3.amazonaws.com/free-prod/62ad9eb6-7e42-45d3-9e77-d3a12dcb247b-0.png"])
    XCTAssertTrue(response.data.failed_reason?.isEmpty == true)
    XCTAssertNil(response.data.current_images)
  }
}
