import Foundation
import RefdsShared

public protocol RefdsHttpClient {
    func request<Request: RefdsHttpRequest, Response: RefdsModel>(
        with request: Request,
        type: Response.Type
    ) async throws -> Response
}
