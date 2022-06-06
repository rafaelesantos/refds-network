import Foundation

public extension Encodable {
    /// Get data from encodable
    var data: Data? {
        return try? JSONEncoder().encode(self)
    }
}
