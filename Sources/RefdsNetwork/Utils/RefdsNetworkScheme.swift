//
//  RefdsNetworkScheme.swift
//  
//
//  Created by Rafael Santos on 29/04/22.
//

import Foundation

public enum RefdsNetworkScheme: String, Codable {
    case https = "https"
    case http = "http"
    case ws = "ws"
    case wss = "wss"
}
