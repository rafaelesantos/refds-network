//
//  RefdsNetworkConfigurationProtocol.swift
//  
//
//  Created by Rafael Santos on 27/04/22.
//

import Foundation

public protocol RefdsNetworkConfigurationProtocol {
    var scheme: RefdsNetworkScheme { get set }
    var host: String { get set }
}
