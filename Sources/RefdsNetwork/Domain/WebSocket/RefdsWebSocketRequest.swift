import Foundation
import RefdsShared

public protocol RefdsWebSocketRequest: Sendable {
    var client: RefdsWebSocketClient { get }
    var endpoint: RefdsWebSocketEndpoint? { get }
    
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
        guard let decoded: Decoded = data.asModel() else {
            throw RefdsWebSocketError.invalidResponse(content: data)
        }
        return decoded
    }
}
