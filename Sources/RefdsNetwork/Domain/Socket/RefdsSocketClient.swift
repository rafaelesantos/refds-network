import Foundation
import RefdsShared

public protocol RefdsSocketClient: Sendable {
    func send(message: String) async throws
    func connect<Request: RefdsSocketRequest>(with request: Request) async throws -> AsyncThrowingStream<String, Error>
}
