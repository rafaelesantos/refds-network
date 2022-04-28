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
    static func getRequestData() -> RefdsNetworkRequestDataProtocol
    static func load() -> AnyPublisher<Self, Error>
}
