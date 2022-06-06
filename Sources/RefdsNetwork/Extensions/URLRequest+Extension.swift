import Foundation

public extension URLRequest {
    /**
     Create request with body, method and headers
     - Parameters:
        - requestData: A protocol of type `RefdsNetworkRequestDataProtocol` with `body`, `method` and `headers`
     - Returns: A URL request with all fields filled
     */
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
