import Foundation
import RefdsShared

public protocol RefdsWebSocketClient {
    func send<Value: RefdsModel>(
        value: Value,
        type: Value.Type
    ) async throws
    func connect<Request: RefdsWebSocketRequest>(with request: Request) async throws -> AsyncThrowingStream<Data, Error>
}
