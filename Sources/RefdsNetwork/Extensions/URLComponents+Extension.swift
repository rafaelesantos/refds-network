import Foundation

public extension URLComponents {
    /**
     Generate complete URL with all components needed.
     - Parameters:
        - configuration: A protocol `RefdsNetworkBaseProtocol` with `scheme` and `host` attributes
     - Returns: A URL components
     */
    func build(with configuration: RefdsNetworkBaseProtocol) -> Self {
        var urlComponents = self
        urlComponents.scheme = configuration.scheme.rawValue
        urlComponents.host = configuration.host

        return urlComponents
    }
    
    /**
     Add path to URL
     - Parameters:
        - path: A Protocol `RefdsNetworkPathProtocol` with path string `value`
     - Returns: A URL components
     */
    func with(path: RefdsNetworkPathProtocol) -> Self {
        var urlComponents = self
        urlComponents.path = "/" + path.value

        return urlComponents
    }

    /**
     Add query items to URL
     - Parameters:
        - path: A Protocol `RefdsNetworkQueryItemsProtocol` with query items array string `value`
     - Returns: A URL components
     */
    func with(queryItems: RefdsNetworkQueryItemsProtocol) -> Self {
        var urlComponents = self
        urlComponents.queryItems = queryItems.values.isEmpty ? nil : queryItems.values

        return urlComponents
    }
}
