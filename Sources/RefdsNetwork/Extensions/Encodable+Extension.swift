//
//  Encodable+Extension.swift
//
//
//  Created by Rafael Santos on 30/04/22.
//

import Foundation

public extension Encodable {
    var data: Data? {
        return try? JSONEncoder().encode(self)
    }
}
