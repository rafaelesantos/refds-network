//
//  RefdsNetworkConfigurationProtocol.swift
//
//
//  Created by Rafael Santos on 27/04/22.
//

import Foundation

public protocol RefdsNetworkBaseProtocol {
    var scheme: RefdsNetworkScheme { get set }
    var host: String { get set }
}
