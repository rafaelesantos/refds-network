import Foundation

public extension URLRequest {
    func prepared(with requestData: RefdsNetworkRequestDataProtocol) -> Self {
        var request = self
        request.httpBody = requestData.body
        request.httpMethod = requestData.method.rawValue
        requestData.headers.forEach {
            request.setValue($0.rawValue.1, forHTTPHeaderField: $0.rawValue.0)
        }

        return request
    }
}
