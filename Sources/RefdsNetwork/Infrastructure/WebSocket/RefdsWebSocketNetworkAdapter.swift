import Foundation

public class RefdsWebSocketNetworkAdapter: NSObject, RefdsWebSocketClient {
    private var session: URLSession
    private var webSocket: URLSessionWebSocketTask?
    private let openConnectionSemaphore = DispatchSemaphore(value: 1)
    private let receiveSemaphore = DispatchSemaphore(value: 1)
    private var currentRequestData: RequestData?
    
    public var status: ((RefdsWebSocketStatus) -> Void)?
    public var error: ((RefdsWebSocketError) -> Void)?
    public var success: ((Data) -> Void)?
    public var repeats: Bool = false
    
    private let receiveQueue = DispatchQueue(
        label: "refds.websocket.network.receive",
        qos: .default,
        attributes: .concurrent
    )
    
    private let subscribeQueue = DispatchQueue(
        label: "refds.websocket.network.subscribe",
        qos: .default,
        attributes: .concurrent
    )
    
    public override init() {
        self.session = .shared
        super.init()
        session = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: OperationQueue()
        )
    }
    
    public func webSocket<Request>(
        request: Request,
        repeats: Bool = false
    ) -> Self where Request : RefdsWebSocketRequest {
        guard let webSocketEndpoint = request.webSocketEndpoint,
              let url = webSocketEndpoint.url else {
            let error = RefdsWebSocketError.invalidUrl
            currentRequestData?.logger()
            error.logger()
            return self
        }
        self.repeats = repeats
        webSocket = session.webSocketTask(with: url)
        webSocket?.resume()
        openConnectionSemaphore.wait()
        return self
    }
    
    public func send(with requestData: RequestData) {
        openConnectionSemaphore.wait()
        currentRequestData = requestData
        if !self.repeats { requestData.logger() }
        subscribeQueue.async {
            let string = requestData.json
            guard string.success else { 
                let error = RefdsWebSocketError.custom(message: "Invalida data request")
                requestData.logger()
                error.logger()
                return
            }
            self.webSocket?.send(.string(string.content), completionHandler: { _ in })
            guard self.repeats else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { self.send(with: requestData) }
        }
        openConnectionSemaphore.signal()
    }
    
    public func stopRepeats() {
        repeats = false
    }
    
    private func didReceive() {
        webSocket?.receive(completionHandler: { result in
            self.receiveQueue.async {
                self.receiveSemaphore.wait()
                switch result {
                case .success(let message): self.success(didReceive: message)
                case .failure(let error): self.failure(message: error.localizedDescription)
                }
                self.receiveSemaphore.signal()
            }
            self.didReceive()
        })
    }
    
    private func success(didReceive message: URLSessionWebSocketTask.Message) {
        switch message {
        case .string(let string):
            if let data = string.data(using: .utf8) { success?(data) }
            else { failure(message: "WebSocket failed cast string receive to data") }
        default: failure(message: "WebSocket do not receive a string value")
        }
    }
    
    private func failure(message: String) {
        RefdsWebSocketError.custom(message: message).logger()
        error?(.custom(message: message))
    }
}

extension RefdsWebSocketNetworkAdapter: URLSessionWebSocketDelegate {
    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        status?(.open)
        didReceive()
        openConnectionSemaphore.signal()
    }
    
    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        status?(.close)
    }
}
