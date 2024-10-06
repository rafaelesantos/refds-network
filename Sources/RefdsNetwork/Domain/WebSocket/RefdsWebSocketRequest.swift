import Foundation

public protocol RefdsWebSocketRequest {
    var client: RefdsWebSocketClient { get }
    var endpoint: RefdsWebSocketEndpoint? { get }
    
    func decode<Decoded: Codable>(
        _ data: Data,
        type: Decoded.Type
    ) throws -> Decoded
}

public extension RefdsWebSocketRequest {
    func decode<Decoded: Codable>(
        _ data: Data,
        type: Decoded.Type
    ) throws -> Decoded {
        guard let decoded: Decoded = data.asModel() else {
            throw RefdsWebSocketError.invalidResponse(content: data)
        }
        return decoded
    }
}
