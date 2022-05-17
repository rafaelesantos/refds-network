import Foundation

public extension Encodable {
    var data: Data? {
        return try? JSONEncoder().encode(self)
    }
}
