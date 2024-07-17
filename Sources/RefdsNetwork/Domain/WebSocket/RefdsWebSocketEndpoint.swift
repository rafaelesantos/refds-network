import Foundation
import RefdsShared

public protocol RefdsWebSocketEndpoint: RefdsLogger {
    var scheme: RefdsWebSocketScheme { get }
    var host: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: [RefdsHttpHeader]? { get }
    var body: Data? { get }
}

extension RefdsWebSocketEndpoint {
    public var queryItems: [URLQueryItem]? { nil }
    public var headers: [RefdsHttpHeader]? { nil }
    public var body: Data? { nil }
    public var url: URL? { urlComponents.url }
    
    public var urlComponents: URLComponents {
        var  urlComponents = URLComponents()
        urlComponents.scheme = scheme.rawValue
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        return urlComponents
    }
    
    public func logger() {
        guard let url = url else { return }
        var message = "\t ENDPOINT - \(url)"
        if let headers = headers {
            message += "\n\t HEADERS [\n\t\t\(headers.map({ "\($0.rawValue.key): \($0.rawValue.value)" }).joined(separator: ",\n\t\t"))]"
        }
        if let body = body, let bodyString = String(data: body, encoding: .utf8) {
            message += "\n\t BODY \(bodyString.replacingOccurrences(of: "\n", with: "\n\t\t"))"
        }
        Self.loggerInstance.info(message: message)
    }
}
