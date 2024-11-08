import Foundation
import RefdsShared
import Network

public actor RefdsSocketNetworkAdapter: RefdsSocketClient {
    private var connection: NWConnection?
    
    public init() {}
    
    public func connect<Request: RefdsSocketRequest>(with request: Request) async throws -> AsyncThrowingStream<String, Error> {
        guard let endpoint = await request.endpoint else {
            let error = RefdsError.request(for: .badURL)
            await error.logger()
            throw error
        }
        
        await endpoint.logger()
        connection = try await NWConnection(
            host: endpoint.host,
            port: endpoint.port,
            using: endpoint.parameters
        )
        
        return AsyncThrowingStream { continuation in
            Task(priority: .high) {
                let stream = try await connect()
                for await status in stream {
                    switch status {
                    case .open: await receive(on: continuation)
                    case .close: continuation.finish()
                    }
                }
                
                continuation.onTermination = { [weak self] _ in
                    guard let self else { return }
                    Task { await disconnect() }
                }
            }
        }
    }
    
    private func connect() async throws -> AsyncStream<RefdsSocketStatus> {
        AsyncStream { continuation in
            connection?.stateUpdateHandler = { state in
                switch state {
                case .ready:
                    continuation.yield(.open)
                case .cancelled, .failed:
                    continuation.yield(.close)
                default:
                    break
                }
            }
            connection?.start(
                queue: DispatchQueue(
                    label: UUID().uuidString,
                    qos: .userInitiated,
                    attributes: .concurrent
                )
            )
        }
    }
    
    private func receive(on continuation: AsyncThrowingStream<String, Error>.Continuation) async {
        connection?.receive(
            minimumIncompleteLength: 1,
            maximumLength: 65536
        ) { [weak self] content, contentContext, isComplete, error in
            guard let self else { return }
            if let error = error { return continuation.finish(throwing: error) }
            if let data = content, let value = String(data: data, encoding: .utf8) { continuation.yield(value) }
            if isComplete { return continuation.finish() }
            Task(priority: .high) { await receive(on: continuation) }
        }
    }
    
    public func send(message: String) async throws {
        guard let content = message.enter().data(using: .utf8) else {
            let error = RefdsError.request(for: .requestBodyStreamExhausted)
            await error.logger()
            throw error
        }
        await message.logger()
        try await withCheckedThrowingContinuation { continuation in
            connection?.send(
                content: content,
                completion: .contentProcessed { error in
                    guard let error else { return continuation.resume() }
                    return continuation.resume(throwing: error)
                }
            )
        }
    }
    
    private func disconnect() {
        connection?.cancel()
    }
}
