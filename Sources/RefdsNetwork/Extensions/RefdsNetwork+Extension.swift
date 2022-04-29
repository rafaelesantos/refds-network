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
extension RefdsNetwork.Configuration {
    public func base(
        scheme: RefdsNetworkScheme,
        host: String
    ) -> RefdsNetworkBaseProtocol {
        return Base(
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
        base: RefdsNetworkBaseProtocol,
        path: RefdsNetworkPathProtocol,
        queryItems: RefdsNetworkQueryItemsProtocol,
        _ type: R.Type
    ) -> RefdsNetworkEndpointProtocol {
        return Endpoint<R>(
            base: configuration,
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
    ) -> RefdsNetworkServiceConfigurationProtocol {
        return ServiceConfiguration(
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
    ) -> RefdsNetworkServiceConfigurationProtocol {
        let configuration = Base(scheme: scheme, host: host)
        let path = Path(value: path)
        let queryItems = QueryItems(values: queryItems)
        let endpoint = Endpoint<R>(base: configuration, path: path, queryItems: queryItems)
        let requestData = RequestData(method: method, headers: headers)
        
        return ServiceConfiguration(endpoint: endpoint, requestData: requestData)
    }
}

// MARK: Structs Based On Protocols

@available(iOS 13.0, *)
@available(macOS 10.15, *)
extension RefdsNetwork.Configuration {
    private struct Base: RefdsNetworkBaseProtocol {
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
        var base: RefdsNetworkBaseProtocol
        var path: RefdsNetworkPathProtocol
        var queryItems: RefdsNetworkQueryItemsProtocol
    }
    
    private struct ServiceConfiguration: RefdsNetworkServiceConfigurationProtocol {
        var endpoint: RefdsNetworkEndpointProtocol
        var requestData: RefdsNetworkRequestDataProtocol
    }
}
