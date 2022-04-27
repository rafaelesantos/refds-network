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
public protocol RefdsNetworkModelProtocol: RefdsNetworkRequestDataProtocol, Codable {
    var endpoint: RefdsNetworkEndpoint<Self> { get set }
    func load() -> AnyPublisher<Self, Error>
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
extension RefdsNetworkModelProtocol {
    func load() -> AnyPublisher<Self, Error> {
        return RefdsNetwork.shared.load(for: endpoint, using: self)
    }
}
