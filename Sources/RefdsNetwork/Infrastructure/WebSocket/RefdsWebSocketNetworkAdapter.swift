import Foundation
import RefdsShared

public actor RefdsWebSocketNetworkAdapter: RefdsWebSocketClient {
    private let session: URLSession
    private var webSocketTask: URLSessionWebSocketTask?
    
    public init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    public func connect<Request: RefdsWebSocketRequest>(with request: Request) async throws -> AsyncThrowingStream<Data, Error> {
        guard let endpoint = await request.endpoint,
              let url = await endpoint.url else {
            let error = RefdsWebSocketError.invalidUrl
            await error.logger()
            throw error
        }
        
        await endpoint.logger()
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        
        return AsyncThrowingStream { [weak self] continuation in
            guard let self else { return }
            Task {
                do {
                    while let message = try await self.receive() {
                        continuation.yield(message)
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
            
            continuation.onTermination = { [weak self] _ in
                guard let self else { return }
                Task { await self.disconnect() }
            }
        }
    }
    
    public func send<Value: RefdsModel>(
        value: Value,
        type: Value.Type
    ) async throws {
        let encoded = value.json
        guard encoded.success else {
            let error = RefdsWebSocketError.invalidSendData
            await error.logger()
            throw error
        }
        value.logger()
        try await webSocketTask?.send(.string(encoded.content))
    }
    
    private func receive() async throws -> Data? {
        guard let webSocketTask else { return nil }
        let message = try await webSocketTask.receive()
        
        switch message {
        case .string(let string):
            guard let data = string.data(using: .utf8) else {
                let error = RefdsWebSocketError.decoded
                await error.logger()
                throw error
            }
            return data
        default:
            let error = RefdsWebSocketError.invalidReceiveData
            await error.logger()
            throw error
        }
    }
    
    private func disconnect() async {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        webSocketTask = nil
    }
}
