//
//  RefdsNetwork+Extension.swift
//  
//
//  Created by Rafael Santos on 29/04/22.
//

import Foundation
import Combine

@available(iOS 13.0, *)
@available(macOS 10.15, *)
extension RefdsNetwork {
    public func configuration(
        scheme: RefdsNetworkScheme,
        host: String
    ) -> RefdsNetworkConfigurationProtocol {
        return Configuration(
            scheme: scheme,
            host: host
        )
    }
    
    public func path(value: String) -> RefdsNetworkPathProtocol {
        return Path(value: value)
    }
    
    public func queryItems(values: [URLQueryItem] = []) -> RefdsNetworkQueryItemsProtocol {
        return QueryItems(values: values)
    }
    
    public func endpoint<R: Decodable>(
        configuration: RefdsNetworkConfigurationProtocol,
        path: RefdsNetworkPathProtocol,
        queryItems: RefdsNetworkQueryItemsProtocol,
        _ type: R.Type
    ) -> RefdsNetworkEndpointProtocol {
        return Endpoint<R>(
            configuration: configuration,
            path: path,
            queryItems: queryItems
        )
    }
    
    public func requestData(
        body: Data? = nil,
        method: RefdsNetworkHTTPMethod,
        headers: RefdsNetworkHTTPHeaders
    ) -> RefdsNetworkRequestDataProtocol {
        return RequestData(
            body: body,
            method: method,
            headers: headers
        )
    }
    
    public func service(
        endpoint: RefdsNetworkEndpointProtocol,
        requestData: RefdsNetworkRequestDataProtocol
    ) -> RefdsNetworkServiceProtocol {
        return Service(
            endpoint: endpoint,
            requestData: requestData
        )
    }
    
    func service<R: Decodable>(
        scheme: RefdsNetworkScheme = .https,
        host: String,
        path: String,
        queryItems: [URLQueryItem] = [],
        method: RefdsNetworkHTTPMethod,
        headers: RefdsNetworkHTTPHeaders,
        responseType: R.Type
    ) -> RefdsNetworkServiceProtocol {
        let configuration = Configuration(scheme: scheme, host: host)
        let path = Path(value: path)
        let queryItems = QueryItems(values: queryItems)
        let endpoint = Endpoint<R>(configuration: configuration, path: path, queryItems: queryItems)
        let requestData = RequestData(method: method, headers: headers)
        
        return Service(endpoint: endpoint, requestData: requestData)
    }
}

// MARK: Structs Based On Protocols

@available(iOS 13.0, *)
@available(macOS 10.15, *)
extension RefdsNetwork {
    private struct Configuration: RefdsNetworkConfigurationProtocol {
        var scheme: RefdsNetworkScheme
        var host: String
    }
    
    private struct Path: RefdsNetworkPathProtocol {
        var value: String
    }
    
    private struct QueryItems: RefdsNetworkQueryItemsProtocol {
        var values: [URLQueryItem]
    }
    
    private struct RequestData: RefdsNetworkRequestDataProtocol {
        var body: Data?
        var method: RefdsNetworkHTTPMethod
        var headers: RefdsNetworkHTTPHeaders
    }
    
    private struct Endpoint<Response: Decodable>: RefdsNetworkEndpointProtocol {
        var configuration: RefdsNetworkConfigurationProtocol
        var path: RefdsNetworkPathProtocol
        var queryItems: RefdsNetworkQueryItemsProtocol
    }
    
    private struct Service: RefdsNetworkServiceProtocol {
        var endpoint: RefdsNetworkEndpointProtocol
        var requestData: RefdsNetworkRequestDataProtocol
    }
}
