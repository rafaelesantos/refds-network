import Foundation
import RefdsShared

public enum RefdsHttpError: Error, CustomStringConvertible {
    case invalidUrl
    case invalidResponse(content: Data)
    case noConnectivity(statusCode: Int, url: URL)
    case badRequest(statusCode: Int, url: URL)
    case serverError(statusCode: Int, url: URL)
    case unauthorized(statusCode: Int, url: URL)
    case forbidden(statusCode: Int, url: URL)
    
    public var description: String {
        switch self {
        case .invalidUrl: return "Invalid URL"
        case let .invalidResponse(content): return "Invalid Response\n*\tReceived Response: \(String(data: content, encoding: .utf8) ?? "")"
        case let .noConnectivity(statusCode, url): return "No Connectivity\n*\tStatus Code: \(statusCode)\n*\tURL: \(url.absoluteString)"
        case let .badRequest(statusCode, url): return "Bad Request - The server cannot or will not process the request due to an apparent client error.\n*\tStatus Code: \(statusCode)\n*\tURL: \(url.absoluteString)"
        case let .serverError(statusCode, url): return "Server Error - A generic error message, given when an unexpected condition was encountered and no more specific message is suitable.\n*\tStatus Code: \(statusCode)\n*\tURL: \(url.absoluteString)"
        case let .unauthorized(statusCode, url): return "Unauthorized - Similar to Forbidden, but specifically for use when authentication is required and has failed or has not yet been provided.\n*\tStatus Code: \(statusCode)\n*\tURL: \(url.absoluteString)"
        case let .forbidden(statusCode, url): return "Forbidden - The request contained valid data and was understood by the server, but the server is refusing action.\n*\tStatus Code: \(statusCode)\n*\tURL: \(url.absoluteString)"
        }
    }
}

extension RefdsHttpError: RefdsLogger {
    public func logger() {
        Self.loggerInstance.error(message: description)
    }
}
