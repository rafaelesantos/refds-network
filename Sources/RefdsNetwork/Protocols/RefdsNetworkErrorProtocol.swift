//
//  RefdsNetworkErrorProtocol.swift
//  
//
//  Created by Rafael Santos on 04/05/22.
//

import Foundation

public protocol RefdsNetworkErrorProtocol: Error {
    var title: String { get }
    var description: String { get }
}
