//
//  RefdsNetwork.swift
//
//
//  Created by Rafael Santos on 26/04/22.
//
import Foundation
import Combine

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public struct RefdsNetwork {
    public static let shared = RefdsNetwork()
    private let urlSession = URLSession.shared
    
    public func load<R: Decodable>(
        for endpoint: RefdsNetworkEndpointProtocol,
        using requestData: RefdsNetworkRequestDataProtocol
    ) -> AnyPublisher<R, Error> {
        return urlSession.publisher(for: endpoint, using: requestData)
    }
    
    public func load<R: Decodable>(
        scheme: String = "https",
        host: String,
        path: String,
        queryItems: [URLQueryItem] = [],
        method: RefdsNetworkHTTPMethod,
        headers: RefdsNetworkHTTPHeaders,
        responseType: R.Type
    ) -> AnyPublisher<R, Error> {
        let configuration = Configuration(scheme: scheme, host: host)
        let path = Path(value: path)
        let queryItems = QueryItems(value: queryItems)
        let endpoint = Endpoint(configuration: configuration, path: path, queryItems: queryItems)
        let requestData = RequestData(method: method, headers: headers)
        return urlSession.publisher(for: endpoint, using: requestData)
    }
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
extension RefdsNetwork {
    private struct Endpoint: RefdsNetworkEndpointProtocol {
        var configuration: RefdsNetworkConfigurationProtocol
        var path: RefdsNetworkPathProtocol
        var queryItems: RefdsNetworkQueryItemsProtocol
    }
    
    private struct Configuration: RefdsNetworkConfigurationProtocol {
        var scheme: String
        var host: String
    }
    
    private struct Path: RefdsNetworkPathProtocol {
        var value: String
    }
    
    private struct QueryItems: RefdsNetworkQueryItemsProtocol {
        var value: [URLQueryItem]
    }
    
    private struct RequestData: RefdsNetworkRequestDataProtocol {
        var body: Data?
        var method: RefdsNetworkHTTPMethod
        var headers: RefdsNetworkHTTPHeaders
    }
}
