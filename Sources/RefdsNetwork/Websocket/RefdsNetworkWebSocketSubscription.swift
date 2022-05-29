import Foundation
import Combine

final class RefdsNetworkWebSocketSubscription<SubscriberType: Subscriber, T: Codable>:
    Subscription where SubscriberType.Input == Result<RefdsNetworkWebSocketModel<T>, RefdsNetworkError>,
                       SubscriberType.Failure == RefdsNetworkError {
    private var subscriber: SubscriberType?
    let webSocketTask: URLSessionWebSocketTask
    
    init(subscriber: SubscriberType, webSocketTask: URLSessionWebSocketTask) {
        self.subscriber = subscriber
        self.webSocketTask = webSocketTask
        receive()
    }
    
    func request(_ demand: Subscribers.Demand) { }
    
    func cancel() {
        subscriber = nil
    }
    
    func receive() {
        webSocketTask
            .receive {[weak self] result in
                guard let self = self else { return }
                
                let newResult: Result<RefdsNetworkWebSocketModel<T>, RefdsNetworkError> = result
                    .map { self.messageResult($0) }
                    .mapError { RefdsNetworkError.unknown($0) }
                
                if case Result.failure(let error) = newResult,
                   self.webSocketTask.closeCode != .invalid {
                    self.subscriber?.receive(completion: Subscribers.Completion.failure(error))
                } else {
                    _ = self.subscriber?.receive(newResult)
                }
                
                self.receive()
            }
    }
    
    private func messageResult(_ message: URLSessionWebSocketTask.Message) -> RefdsNetworkWebSocketModel<T> {
        switch message {
        case .string(let str):
            return .message(str)
        case .data(let data):
            if  let thing = try? JSONDecoder().decode(T.self, from: data) {
                return .codable(thing)
            } else {
                return .uncodable(data)
            }
        @unknown default:
            fatalError()
        }
    }
}

