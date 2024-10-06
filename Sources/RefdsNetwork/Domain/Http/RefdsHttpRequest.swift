import Foundation
import RefdsShared

public protocol RefdsHttpRequest {
    var client: RefdsHttpClient { get }
    var endpoint: RefdsHttpEndpoint? { get }
    
    func decode<Decoded: Codable>(
        _ data: Data,
        type: Decoded.Type
    ) throws -> Decoded
}

public extension RefdsHttpRequest {
    func decode<Decoded: Codable>(
        _ data: Data,
        type: Decoded.Type
    ) throws -> Decoded {
        guard let decoded: Decoded = data.asModel() else {
            throw RefdsHttpError.invalidResponse(content: data)
        }
        endpoint?.logger()
        RefdsLoggerSystem.shared.info(message: decoded.json.content)
        return decoded
    }
}
