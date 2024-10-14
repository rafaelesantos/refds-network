import Foundation
import RefdsShared

public protocol RefdsHttpClient: Sendable {
    func request<Request: RefdsHttpRequest, Response: RefdsModel>(
        with request: Request,
        type: Response.Type
    ) async throws -> Response
}
