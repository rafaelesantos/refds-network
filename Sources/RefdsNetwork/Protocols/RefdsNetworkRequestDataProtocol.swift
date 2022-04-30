//
//  RefdsNetworkRequestDataProtocol.swift
//  
//
//  Created by Rafael Santos on 27/04/22.
//

import Foundation

public protocol RefdsNetworkRequestDataProtocol {
    var body: Data? { get set }
    var method: RefdsNetworkHTTPMethod { get }
    var headers: RefdsNetworkHTTPHeaders { get }
}

// MARK: Default Values

extension RefdsNetworkRequestDataProtocol {
    public var body: Data? { return nil }
    public var method: RefdsNetworkHTTPMethod { return .get }
    public var headers: RefdsNetworkHTTPHeaders { return [.accept(.applicationJson)] }
}
