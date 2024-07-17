import Foundation
import RefdsShared

public enum RefdsWebSocketError: Error, CustomStringConvertible {
    case invalidUrl
    case invalidResponse(content: Data)
    case custom(message: String)
    
    public var description: String {
        switch self {
        case .invalidUrl: return "Invalid URL"
        case let .invalidResponse(content): return "Invalid Response\n*\tReceived Response: \(String(data: content, encoding: .utf8) ?? "")"
        case let .custom(message): return "\(message)"
        }
    }
}

extension RefdsWebSocketError: RefdsLogger {
    public func logger() {
        Self.loggerInstance.error(message: description)
    }
}
