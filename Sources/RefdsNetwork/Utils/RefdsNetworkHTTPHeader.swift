//
//  RefdsNetworkHTTPHeader.swift
//  
//
//  Created by Rafael Santos on 27/04/22.
//

import Foundation

public typealias RefdsNetworkHTTPHeaders = [RefdsNetworkHTTPHeader]

public enum RefdsNetworkHTTPHeader {
    public enum Accept: String {
        case applicationJson = "application/json"
    }
    
    public enum ContentType: String {
        case applicationJson = "application/json"
    }
    
    case accept(Accept)
    case authorization(String)
    case contentType(ContentType)
    case custom(String, String)
    
    public var rawValue: (String, String) {
        switch self {
        case .accept(let value):
            return ("Accept", value.rawValue)
        case .authorization(let value):
            return ("Authorization", value)
        case .contentType(let value):
            return ("Content-Type", value.rawValue)
        case .custom(let key, let value):
            return (key, value)
        }
    }
}


