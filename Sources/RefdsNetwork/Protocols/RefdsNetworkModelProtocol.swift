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
    static func getEndpoint() -> RefdsNetworkEndpoint<Self>
    static func getRequestData() -> RefdsNetworkRequestDataProtocol
    static func load() -> AnyPublisher<Self, Error>
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public extension RefdsNetworkModelProtocol {
    static func getRequestData() -> RefdsNetworkRequestDataProtocol {
        return RefdsNetworkRequestData(method: .get, headers: [.accept(.applicationJson)])
    }
    
    static func load() -> AnyPublisher<Self, Error> {
        return RefdsNetwork.shared.load(for: getEndpoint(), using: getRequestData())
    }
}
