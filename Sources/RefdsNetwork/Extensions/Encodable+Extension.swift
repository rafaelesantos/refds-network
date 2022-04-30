//
//  Encodable+Extension.swift
//  
//
//  Created by Rafael Santos on 30/04/22.
//

import Foundation

extension Encodable {
    public var data: Data? {
        return try? JSONEncoder().encode(self)
    }
}
