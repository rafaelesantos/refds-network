import Foundation

public protocol RefdsWebSocketRequest {
    associatedtype Response
    
    var webSocketClient: RefdsWebSocketClient { get }
    var webSocketEndpoint: RefdsWebSocketEndpoint? { get }
    
    func decode(_ data: Data) throws -> Response
}

public extension RefdsWebSocketRequest where Response: Decodable {
    func decode(_ data: Data) throws -> Response {
        guard let decoded: Response = data.asModel() else { throw RefdsWebSocketError.invalidResponse(content: data) }
        return decoded
    }
}
