import Foundation
import RefdsShared

public protocol RefdsWebSocketRequest: Sendable {
    var client: RefdsWebSocketClient { get async }
    var endpoint: RefdsWebSocketEndpoint? { get async }
    
    func decode<Decoded: RefdsModel>(
        _ data: Data,
        type: Decoded.Type
    ) async throws -> Decoded
}

public extension RefdsWebSocketRequest {
    func decode<Decoded: RefdsModel>(
        _ data: Data,
        type: Decoded.Type
    ) async throws -> Decoded {
        let decoded = try data.asModel(for: Decoded.self)
        return decoded
    }
}
