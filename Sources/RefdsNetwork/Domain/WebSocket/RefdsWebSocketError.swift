import Foundation
import RefdsShared

public enum RefdsWebSocketError: Error, CustomStringConvertible {
    case invalidUrl
    case invalidResponse(content: Data)
    case decoded
    case invalidReceiveData
    case invalidSendData
    case custom(message: String)
    
    public var description: String {
        switch self {
        case .invalidUrl: return "Invalid URL"
        case let .invalidResponse(content): return "Invalid Response\n*\tReceived Response: \(String(data: content, encoding: .utf8) ?? "")"
        case .decoded: return "WebSocket failed cast string receive to data"
        case .invalidReceiveData: return "WebSocket do not receive a string value"
        case .invalidSendData: return "WebSocket do not send a string value"
        case let .custom(message): return "\(message)"
        }
    }
}

extension RefdsWebSocketError: RefdsLogger {
    public func logger() {
        Self.loggerInstance.error(message: description)
    }
}
