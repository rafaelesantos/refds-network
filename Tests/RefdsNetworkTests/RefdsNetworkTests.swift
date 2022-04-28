import XCTest
import Combine
@testable import RefdsNetwork

@available(iOS 13.0, *)
final class RefdsNetworkTests: XCTestCase {
    private var cancellable: AnyCancellable?
    
    func testExample() throws {
        struct CheckEmail: Codable {
            var message: String
            
            enum CodingKeys: String, CodingKey {
                case message = "mensagem"
            }
        }
        let expectation = XCTestExpectation(description: "Your expectation")
        self.cancellable = RefdsNetwork.shared
            .load(
                host: "priusonline.com.br",
                path: "wp-json/api/verificar-email",
                method: .post,
                headers: [.contentType(.applicationJson)],
                responseType: CheckEmail.self
            )
            .sink { completion in
                print(completion)
                expectation.fulfill()
            } receiveValue: { checkEmail in
                print(checkEmail)
                XCTAssertEqual(checkEmail.message, "0")
                expectation.fulfill()
            }
        self.wait(for: [expectation], timeout: 20)

    }
}
