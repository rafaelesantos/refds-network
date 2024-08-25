import Foundation
import RefdsShared

public protocol RefdsHttpClient {
    func request<Request: RefdsHttpRequest>(
        _ request: Request,
        completion: @escaping (RefdsResult<Request.Response>) -> Void
    )
}
