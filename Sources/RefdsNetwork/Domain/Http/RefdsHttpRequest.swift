import Foundation
import RefdsShared

public protocol RefdsHttpRequest {
    associatedtype Response
    
    var httpClient: RefdsHttpClient { get set }
    var httpEndpoint: RefdsHttpEndpoint { get set }
    
    func decode(_ data: Data, endpoint: RefdsHttpEndpoint?) throws -> Response
}

public extension RefdsHttpRequest where Response: RefdsModel {
    func decode(_ data: Data, endpoint: RefdsHttpEndpoint?) throws -> Response {
        guard let decoded: Response = data.asModel() else { throw RefdsHttpError.invalidResponse(content: data) }
        endpoint?.logger()
        decoded.logger()
        return decoded
    }
}
