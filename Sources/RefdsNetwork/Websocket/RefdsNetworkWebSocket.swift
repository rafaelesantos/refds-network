import Foundation
import Combine

final class RefdsNetworkWebSocket<T: Codable>: Publisher, Subscriber {
    public typealias Output = Result<RefdsNetworkWebSocketModel<T>, RefdsNetworkError>
    public typealias Input =  RefdsNetworkWebSocketModel<T>
    public typealias Failure = RefdsNetworkError
    
    let webSocketTask: URLSessionWebSocketTask
    public var combineIdentifier: CombineIdentifier = CombineIdentifier()
    
    public init(url: URL) {
        let urlSession = URLSession(configuration: .default)
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask.resume()
    }
    
    public func receive<S>(subscriber: S) where S: Subscriber, RefdsNetworkWebSocket.Failure == S.Failure, RefdsNetworkWebSocket.Output == S.Input {
        let subscription = RefdsNetworkWebSocketSubscription(subscriber: subscriber, webSocketTask: webSocketTask)
        subscriber.receive(subscription: subscription)
    }
    
    public func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }

    public func receive(_ input: RefdsNetworkWebSocketModel<T>) -> Subscribers.Demand {
        let message: URLSessionWebSocketTask.Message
        
        switch input {
        case .message(let string):
            message = URLSessionWebSocketTask.Message.string(string)
        case .codable(let codable):
            guard let data = try? JSONEncoder().encode(codable) else {  }
            message = URLSessionWebSocketTask.Message.data(data)
        case .uncodable(let data):
            message = URLSessionWebSocketTask.Message.data(data)
        }
    
        webSocketTask.send(message, completionHandler: { error in
            if let error = error {
                if  self.webSocketTask.closeCode != .invalid {
                    
                }
                Swift.print("ERROR on send \(error)")
            }
        })
        return .unlimited
    }

    public func receive(completion: Subscribers.Completion<RefdsNetworkError>) {
        Swift.print("Completion")
    }
}
