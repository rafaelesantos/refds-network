import Foundation

public enum RefdsNetworkWebSocketModel<T: Codable> {
    case message(String)
    case codable(T)
    case uncodable(Data)
}
