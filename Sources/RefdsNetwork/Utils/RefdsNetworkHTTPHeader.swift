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
        case let .accept(value):
            return ("Accept", value.rawValue)
        case let .authorization(value):
            return ("Authorization", value)
        case let .contentType(value):
            return ("Content-Type", value.rawValue)
        case let .custom(key, value):
            return (key, value)
        }
    }
}
