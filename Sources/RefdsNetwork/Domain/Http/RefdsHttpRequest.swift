import Foundation
import RefdsShared

public protocol RefdsHttpRequest {
    associatedtype Response
    
    var httpClient: RefdsHttpClient { get }
    var httpEndpoint: RefdsHttpEndpoint? { get }
    
    func decode(_ data: Data) throws -> Response
}

public extension RefdsHttpRequest where Response: RefdsModel {
    func decode(_ data: Data) throws -> Response {
        guard let decoded: Response = data.asModel() else { throw RefdsHttpError.invalidResponse(content: data) }
        httpEndpoint?.logger()
        decoded.logger()
        return decoded
    }
}
