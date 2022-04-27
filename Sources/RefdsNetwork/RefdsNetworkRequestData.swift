//
//  RefdsNetworkRequestData.swift
//  
//
//  Created by Rafael Santos on 27/04/22.
//

import Foundation

public protocol RefdsNetworkRequestDataProtocol {
    var body: Data? { get set }
    var method: RefdsNetworkHTTPMethod { get set }
    var headers: RefdsNetworkHTTPHeaders { get set }
}

public struct RefdsNetworkRequestData: RefdsNetworkRequestDataProtocol {
    public var body: Data?
    public var method: RefdsNetworkHTTPMethod
    public var headers: RefdsNetworkHTTPHeaders
    
    public init(body: Data? = nil, method: RefdsNetworkHTTPMethod, headers: RefdsNetworkHTTPHeaders) {
        self.body = body
        self.method = method
        self.headers = headers
    }
}

// MARK: Default Values

extension RefdsNetworkRequestDataProtocol {
    public var body: Data? { get { return nil } }
    public var method: RefdsNetworkHTTPMethod { get { return .get } }
    public var headers: RefdsNetworkHTTPHeaders { get { return [.accept(.applicationJson)] } }
}
