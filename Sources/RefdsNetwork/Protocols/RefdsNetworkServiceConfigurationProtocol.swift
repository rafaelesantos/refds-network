//
//  RefdsNetworkServiceConfigurationProtocol.swift
//  
//
//  Created by Rafael Santos on 29/04/22.
//

import Foundation

public protocol RefdsNetworkServiceConfigurationProtocol {
    var endpoint: RefdsNetworkEndpointProtocol { get }
    var requestData: RefdsNetworkRequestDataProtocol { get }
}
