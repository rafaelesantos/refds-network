import Foundation

public protocol RefdsNetworkErrorProtocol: Error {
    var title: String { get }
    var description: String { get }
}
