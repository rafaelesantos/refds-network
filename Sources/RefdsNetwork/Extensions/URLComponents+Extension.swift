import Foundation

public extension URLComponents {
    func build(with configuration: RefdsNetworkBaseProtocol) -> Self {
        var urlComponents = self
        urlComponents.scheme = configuration.scheme.rawValue
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
        urlComponents.queryItems = queryItems.values.isEmpty ? nil : queryItems.values

        return urlComponents
    }
}
