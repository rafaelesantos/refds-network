import Combine
import Foundation

public extension RefdsNetwork.Configuration {
    func base(
        scheme: RefdsNetworkScheme,
        host: String
    ) -> RefdsNetworkBaseProtocol {
        return Base(
            scheme: scheme,
            host: host
        )
    }

    func path(value: String) -> RefdsNetworkPathProtocol {
        return Path(value: value)
    }

    func queryItems(values: [URLQueryItem] = []) -> RefdsNetworkQueryItemsProtocol {
        return QueryItems(values: values)
    }

    func endpoint<R: Decodable>(
        base: RefdsNetworkBaseProtocol,
        path: RefdsNetworkPathProtocol,
        queryItems: RefdsNetworkQueryItemsProtocol,
        _: R.Type
    ) -> RefdsNetworkEndpointProtocol {
        return Endpoint<R>(
            base: base,
            path: path,
            queryItems: queryItems
        )
    }

    func requestData(
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

    func service(
        endpoint: RefdsNetworkEndpointProtocol,
        requestData: RefdsNetworkRequestDataProtocol
    ) -> RefdsNetworkServiceConfigurationProtocol {
        return ServiceConfiguration(
            endpoint: endpoint,
            requestData: requestData
        )
    }

    internal func service<R: Decodable>(
        scheme: RefdsNetworkScheme = .https,
        host: String,
        path: String,
        queryItems: [URLQueryItem] = [],
        method: RefdsNetworkHTTPMethod,
        headers: RefdsNetworkHTTPHeaders,
        responseType _: R.Type
    ) -> RefdsNetworkServiceConfigurationProtocol {
        let base = Base(scheme: scheme, host: host)
        let path = Path(value: path)
        let queryItems = QueryItems(values: queryItems)
        let endpoint = Endpoint<R>(base: base, path: path, queryItems: queryItems)
        let requestData = RequestData(method: method, headers: headers)

        return ServiceConfiguration(endpoint: endpoint, requestData: requestData)
    }
}

// MARK: Structs Based On Protocols

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
