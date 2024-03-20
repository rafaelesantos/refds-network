import Foundation

public protocol RefdsHttpClient {
    func request<Request: RefdsHttpRequest>(
        _ request: Request,
        completion: @escaping (Result<Request.Response, RefdsHttpError>) -> Void
    )
}
