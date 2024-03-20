import Foundation

public enum RefdsHttpHeader {
    case accept(type: RefdsHttpHeaderAcceptType)
    case authorization(token: String)
    case contentType(type: RefdsHttpHeaderContentType)
    case custom(key: String, value: String)

    public var rawValue: (key: String, value: String) {
        switch self {
        case let .accept(acceptType): return ("Accept", acceptType.rawValue)
        case let .authorization(token): return ("Authorization", token)
        case let .contentType(contentType): return ("Content-Type", contentType.rawValue)
        case let .custom(key, value): return (key, value)
        }
    }
}

public enum RefdsHttpHeaderAcceptType: String {
    case applicationJson = "application/json"
}

public enum RefdsHttpHeaderContentType: String {
    case applicationJson = "application/json"
}

public extension Array where Element == RefdsHttpHeader {
    var asDictionary: [String: String] {
        var dictionary = [String: String]()
        self.forEach({ dictionary[$0.rawValue.key] = $0.rawValue.value })
        return dictionary
    }
}
