import Foundation
import RefdsShared

public actor RefdsHttpNetworkAdapter: RefdsHttpClient {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func request<Request: RefdsHttpRequest, Response: RefdsModel>(
        with request: Request,
        type: Response.Type
    ) async throws -> Response {
        guard let endpoint = await request.endpoint,
              let url = await endpoint.url else {
            let error = RefdsHttpError.invalidUrl
            await error.logger()
            throw RefdsError.requestError(error: error)
        }
        
        await endpoint.logger()
        let urlRequest = await endpoint.request(url: url)
        let result = try await session.data(for: urlRequest)
        
        return try await request.decode(result.0, type: type)
    }
}
