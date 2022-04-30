//
//  RefdsNetworkModelProtocol.swift
//  
//
//  Created by Rafael Santos on 27/04/22.
//

import Foundation
import Combine

var IdentifiableBodyKey = "kIdentifiableBodyKey"
var IdentifiableQueryItemsKey = "kIdentifiableQueryItemsKey"

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public protocol RefdsNetworkModelProtocol: Codable {
    static var serviceConfiguration: RefdsNetworkServiceConfigurationProtocol { get }
    static var body: Data? { get set }
    static var queryItems: [URLQueryItem] { get set }
    
    static func request() -> AnyPublisher<Self, Error>
    static func request(completion: @escaping (Result<Self, Error>) -> ())
    static func request() async throws -> Self
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
extension RefdsNetworkModelProtocol {
    public static var body: Data? {
        get { return objc_getAssociatedObject(self, &IdentifiableBodyKey) as? Data }
        set { objc_setAssociatedObject(self, &IdentifiableBodyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    public static var queryItems: [URLQueryItem]? {
        get { return objc_getAssociatedObject(self, &IdentifiableQueryItemsKey) as? [URLQueryItem] }
        set { objc_setAssociatedObject(self, &IdentifiableQueryItemsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
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
