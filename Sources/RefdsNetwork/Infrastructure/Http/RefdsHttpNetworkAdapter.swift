import Foundation

public class RefdsHttpNetworkAdapter: RefdsHttpClient {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func request<Request>(
        _ request: Request,
        completion: @escaping (Result<Request.Response, RefdsHttpError>) -> Void
    ) where Request : RefdsHttpRequest {
        guard let httpEndpoint = request.httpEndpoint,
              let url = httpEndpoint.url else {
            let error = RefdsHttpError.invalidUrl
            error.logger()
            return completion(.failure(error))
        }
        
        var urlRequest = httpEndpoint.urlRequest(url: url)
        urlRequest.httpMethod = httpEndpoint.method.rawValue
        urlRequest.httpBody = httpEndpoint.body
        
        session.dataTask(with: urlRequest) { data, response, error in
            let result: Result<Request.Response, RefdsHttpError>
            defer { completion(result) }
            
            guard let data = data, let response = response, error == nil else {
                let error = RefdsHttpError.noConnectivity(statusCode: 0, url: url)
                error.logger()
                return result = .failure(error)
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                let error = RefdsHttpError.noConnectivity(statusCode: 0, url: url)
                error.logger()
                return result = .failure(error)
            }
            
            guard let decoded = try? request.decode(data) else {
                let error = self.handleError(url, statusCode: statusCode)
                error.logger()
                return result = .failure(error)
            }
            
            result = .success(decoded)
        }.resume()
    }
    
    private func handleError(_ url: URL, statusCode: Int) -> RefdsHttpError {
        switch statusCode {
        case 401: return .unauthorized(statusCode: statusCode, url: url)
        case 403: return .forbidden(statusCode: statusCode, url: url)
        case 400...499: return .badRequest(statusCode: statusCode, url: url)
        case 500...599: return .serverError(statusCode: statusCode, url: url)
        default: return .noConnectivity(statusCode: statusCode, url: url)
        }
    }
}
