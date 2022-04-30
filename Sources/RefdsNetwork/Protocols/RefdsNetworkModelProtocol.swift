//
//  RefdsNetworkModelProtocol.swift
//  
//
//  Created by Rafael Santos on 27/04/22.
//

import Foundation
import Combine

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public protocol RefdsNetworkModelProtocol: Codable {
    static var body: Data? { get set }
    static var queryItems: RefdsNetworkQueryItemsProtocol? { get set }
    static var serviceConfiguration: RefdsNetworkServiceConfigurationProtocol { get }
    static func request() -> AnyPublisher<Self, Error>
    static func request(completion: @escaping (Result<Self, Error>) -> ())
    static func request() async throws -> Self
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
extension RefdsNetworkModelProtocol {
    public static func request() -> AnyPublisher<Self, Error> {
        return RefdsNetwork.shared.request(for: serviceConfiguration)
    }
    
    public static func request(completion: @escaping (Result<Self, Error>) -> ()) {
        return RefdsNetwork.shared.request(for: serviceConfiguration, completion: completion)
    }
    
    public static func request() async throws -> Self {
        return try await RefdsNetwork.shared.request(for: serviceConfiguration)
    }
}
