//
//  RefdsNetworkEndpointProtocol.swift
//
//
//  Created by Rafael Santos on 26/04/22.
//

import Foundation

public protocol RefdsNetworkEndpointProtocol {
    var base: RefdsNetworkBaseProtocol { get }
    var path: RefdsNetworkPathProtocol { get }
    var queryItems: RefdsNetworkQueryItemsProtocol { get }

    func setupRequest(
        with dataRequest: RefdsNetworkRequestDataProtocol
    ) throws -> URLRequest
}

public extension RefdsNetworkEndpointProtocol {
    func setupRequest(
        with dataRequest: RefdsNetworkRequestDataProtocol
    ) throws -> URLRequest {
        let components = URLComponents()
            .build(with: base)
            .with(path: path)
            .with(queryItems: queryItems)

        guard let url = components.url else { throw RefdsNetworkError.invalidURL }
        return URLRequest(url: url)
            .prepared(with: dataRequest)
    }
}
