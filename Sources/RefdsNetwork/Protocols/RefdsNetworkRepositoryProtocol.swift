import Combine
import Foundation

public protocol RefdsNetworkRepositoryProtocol {
    associatedtype Model: Codable
    var serviceConfiguration: RefdsNetworkServiceConfigurationProtocol { get }

    func request() -> AnyPublisher<Model, RefdsNetworkError>
    func request(completion: @escaping (Result<Model, RefdsNetworkError>) -> Void)
    func request() async throws -> Model
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public extension RefdsNetworkRepositoryProtocol {
    func request() -> AnyPublisher<Model, RefdsNetworkError> {
        return RefdsNetwork.shared.request(for: serviceConfiguration)
    }

    func request(completion: @escaping (Result<Model, RefdsNetworkError>) -> Void) {
        RefdsNetwork.shared.request(for: serviceConfiguration, completion: completion)
    }

    func request() async throws -> Model {
        return try await RefdsNetwork.shared.request(for: serviceConfiguration)
    }
}
