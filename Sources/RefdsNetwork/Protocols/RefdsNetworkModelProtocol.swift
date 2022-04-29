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
public protocol RefdsNetworkModelProtocol: Decodable {
    static var serviceConfiguration: RefdsNetworkServiceConfigurationProtocol { get }
    static func request() -> AnyPublisher<Self, Error>
    static func request(completion: @escaping (Result<Self, Error>) -> ())
    static func request() async throws -> Self
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
extension RefdsNetworkModelProtocol {
    static func request() -> AnyPublisher<Self, Error> {
        return RefdsNetwork.shared.request(for: serviceConfiguration)
    }
    
    static func request(completion: @escaping (Result<Self, Error>) -> ()) {
        return RefdsNetwork.shared.request(for: serviceConfiguration, completion: completion)
    }
    
    static func request() async throws -> Self {
        return try await RefdsNetwork.shared.request(for: serviceConfiguration)
    }
}
