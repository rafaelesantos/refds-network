//
//  NetworkResponse.swift
//  
//
//  Created by Rafael Santos on 26/04/22.
//

import Foundation

public struct RefdsNetworkResponse<Wrapped: Decodable>: Decodable {
    public var result: Wrapped
}
