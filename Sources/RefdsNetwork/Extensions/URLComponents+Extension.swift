//
//  URLComponents+Extension.swift
//  
//
//  Created by Rafael Santos on 27/04/22.
//

import Foundation

public extension URLComponents {
    func build(with configuration: RefdsNetworkConfigurationProtocol) -> Self {
        var urlComponents = self
        urlComponents.scheme = configuration.scheme
        urlComponents.host = configuration.host
        return urlComponents
    }
    
    func with(path: RefdsNetworkPathProtocol) -> Self {
        var urlComponents = self
        urlComponents.path = "/" + path.value
        return urlComponents
    }
    
    func with(queryItems: RefdsNetworkQueryItemsProtocol) -> Self {
        var urlComponents = self
        urlComponents.queryItems = queryItems.value.isEmpty ? nil : queryItems.value
        return urlComponents
    }
}
