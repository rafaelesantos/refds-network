//
//  RefdsNetworkEndpoint.swift
//  
//
//  Created by Rafael Santos on 26/04/22.
//

import Foundation

import Foundation

public protocol RefdsNetworkEndpointProtocol {
    var configuration: RefdsNetworkConfigurationProtocol { get set }
    var path: RefdsNetworkPathProtocol { get set }
    var queryItems: RefdsNetworkQueryItemsProtocol { get set }
    
    func setupRequest(with dataRequest: RefdsNetworkRequestDataProtocol) throws -> URLRequest
}

public struct RefdsNetworkEndpoint<Response: Decodable>: RefdsNetworkEndpointProtocol {
    public var configuration: RefdsNetworkConfigurationProtocol
    public var path: RefdsNetworkPathProtocol
    public var queryItems: RefdsNetworkQueryItemsProtocol
    
    public init(
        configuration: RefdsNetworkConfigurationProtocol,
        path: RefdsNetworkPathProtocol,
        queryItems: RefdsNetworkQueryItemsProtocol
    ) {
        self.configuration = configuration
        self.path = path
        self.queryItems = queryItems
    }
}

public extension RefdsNetworkEndpoint {
    func setupRequest(with dataRequest: RefdsNetworkRequestDataProtocol) throws -> URLRequest {
        let components = URLComponents()
            .build(with: configuration)
            .with(path: path)
            .with(queryItems: queryItems)
        
        guard let url = components.url else { throw RefdsNetworkError.invalidURL }
        return URLRequest(url: url)
            .prepared(with: dataRequest)
    }
}
