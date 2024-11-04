import Foundation
import RefdsShared

public protocol RefdsSocketRequest: Sendable {
    var client: RefdsSocketClient { get async }
    var endpoint: RefdsSocketEndpoint? { get async }
}
