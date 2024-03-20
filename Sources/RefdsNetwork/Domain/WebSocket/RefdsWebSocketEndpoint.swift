import Foundation
import RefdsShared

public protocol RefdsWebSocketEndpoint: RefdsLogger {
    var scheme: RefdsWebSocketScheme { get set }
    var host: String { get set }
    var path: String { get set }
    var queryItems: [URLQueryItem]? { get set }
    var headers: [RefdsHttpHeader]? { get set }
    var body: Data? { get set }
}

extension RefdsWebSocketEndpoint {
    public var urlComponents: URLComponents {
        var  urlComponents = URLComponents()
        urlComponents.scheme = scheme.rawValue
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        return urlComponents
    }
    
    public var url: URL? { urlComponents.url }
    
    public func logger() {
        guard let url = url else { return }
        var message = "\t ENDPOINT - \(url)"
        if let headers = headers {
            message += "\n\t HEADERS [\n\t\t\(headers.map({ "\($0.rawValue.key): \($0.rawValue.value)" }).joined(separator: ",\n\t\t"))]"
        }
        if let body = body, let bodyString = String(data: body, encoding: .utf8) {
            message += "\n\t BODY \(bodyString.replacingOccurrences(of: "\n", with: "\n\t\t"))"
        }
        loggerInstance.info(message: message)
    }
}