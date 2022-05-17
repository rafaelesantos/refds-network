import Foundation

public protocol RefdsNetworkServiceConfigurationProtocol {
    var endpoint: RefdsNetworkEndpointProtocol { get }
    var requestData: RefdsNetworkRequestDataProtocol { get }
}
