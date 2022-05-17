import Combine
import Foundation

public protocol RefdsNetworkModelProtocol: Codable {
    static var serviceConfiguration: RefdsNetworkServiceConfigurationProtocol { get }
    static var body: Data? { get set }
    static var queryItems: [URLQueryItem] { get set }

    static func request() -> AnyPublisher<Self, RefdsNetworkError>
    static func request(completion: @escaping (Result<Self, RefdsNetworkError>) -> Void)
    static func request() async throws -> Self
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public extension RefdsNetworkModelProtocol {
    static func request() -> AnyPublisher<Self, RefdsNetworkError> {
        return RefdsNetwork.shared.request(for: serviceConfiguration)
    }

    static func request(completion: @escaping (Result<Self, RefdsNetworkError>) -> Void) {
        return RefdsNetwork.shared.request(for: serviceConfiguration, completion: completion)
    }

    static func request() async throws -> Self {
        return try await RefdsNetwork.shared.request(for: serviceConfiguration)
    }
}
