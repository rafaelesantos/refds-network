import Foundation
import RefdsShared

public protocol RefdsWebSocketEndpoint: RefdsLogger, Sendable {
    var scheme: RefdsWebSocketScheme { get async }
    var host: String { get async }
    var path: String { get async }
    var queryItems: [URLQueryItem]? { get async }
    var headers: [RefdsHttpHeader]? { get async }
    var body: Data? { get async }
}

extension RefdsWebSocketEndpoint {
    public var queryItems: [URLQueryItem]? { nil }
    public var headers: [RefdsHttpHeader]? { nil }
    public var body: Data? { nil }
    
    public var url: URL? {
        get async {
            await urlComponents.url
        }
    }
    
    public var urlComponents: URLComponents {
        get async {
            var  urlComponents = URLComponents()
            urlComponents.scheme = await scheme.rawValue
            urlComponents.host = await host
            urlComponents.path = await path
            urlComponents.queryItems = await queryItems
            return urlComponents
        }
    }
    
    public func logger() async {
        guard let url = await url else { return }
        var message = "\t ENDPOINT - \(url)"
        if let headers = await headers {
            message += "\n\t HEADERS [\n\t\t\(headers.map({ "\($0.rawValue.key): \($0.rawValue.value)" }).joined(separator: ",\n\t\t"))]"
        }
        if let body = await body, let bodyString = String(data: body, encoding: .utf8) {
            message += "\n\t BODY \(bodyString.replacingOccurrences(of: "\n", with: "\n\t\t"))"
        }
        await Self.loggerInstance.info(message: message)
    }
}
