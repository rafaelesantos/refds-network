import Foundation
import RefdsShared

public protocol RefdsWebSocketClient {
    typealias RequestData = RefdsModel
    
    var status: ((RefdsWebSocketStatus) -> Void)? { get set }
    var error: ((RefdsWebSocketError) -> Void)? { get set }
    var success: ((Data) -> Void)? { get set }
    var repeats: Bool { get }
    
    func webSocket<Request: RefdsWebSocketRequest>(request: Request, repeats: Bool) -> Self
    func send(with requestData: RequestData)
    func stopRepeats()
}
