import Foundation
import RefdsShared

public actor RefdsHttpNetworkAdapter: RefdsHttpClient {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func request<Request: RefdsHttpRequest, Response: Codable>(
        with request: Request,
        type: Response.Type
    ) async throws -> Response {
        guard let endpoint = request.endpoint,
              let url = endpoint.url else {
            let error = RefdsHttpError.invalidUrl
            error.logger()
            throw RefdsError.requestError(error: error)
        }
        
        endpoint.logger()
        let urlRequest = endpoint.request(url: url)
        let result = try await session.data(for: urlRequest)
        
        return try request.decode(result.0, type: type)
    }
}
