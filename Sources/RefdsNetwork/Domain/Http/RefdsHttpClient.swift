import Foundation
import RefdsShared

public protocol RefdsHttpClient {
    func request<Request: RefdsHttpRequest, Response: Codable>(
        with request: Request,
        type: Response.Type
    ) async throws -> Response
}
