//
//  RefdsNetworkRequestDataProtocol.swift
//
//
//  Created by Rafael Santos on 27/04/22.
//

import Foundation

public protocol RefdsNetworkRequestDataProtocol {
    var body: Data? { get }
    var method: RefdsNetworkHTTPMethod { get }
    var headers: RefdsNetworkHTTPHeaders { get }
}

// MARK: Default Values

public extension RefdsNetworkRequestDataProtocol {
    var body: Data? { return nil }
    var method: RefdsNetworkHTTPMethod { return .get }
    var headers: RefdsNetworkHTTPHeaders { return [.accept(.applicationJson)] }
}
