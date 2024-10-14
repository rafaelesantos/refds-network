import Foundation
import RefdsShared

public protocol RefdsHttpRequest: Sendable {
    var client: RefdsHttpClient { get async }
    var endpoint: RefdsHttpEndpoint? { get async }
    
    func decode<Decoded: RefdsModel>(
        _ data: Data,
        type: Decoded.Type
    ) async throws -> Decoded
}

public extension RefdsHttpRequest {
    func decode<Decoded: RefdsModel>(
        _ data: Data,
        type: Decoded.Type
    ) async throws -> Decoded {
        guard let decoded: Decoded = data.asModel() else {
            throw RefdsHttpError.invalidResponse(content: data)
        }
        await decoded.logger()
        return decoded
    }
}
