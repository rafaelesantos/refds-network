import Foundation
import RefdsShared
import Network

public protocol RefdsSocketEndpoint: RefdsLogger, Sendable {
    var host: NWEndpoint.Host { get async }
    var port: NWEndpoint.Port { get async throws }
    var parameters: NWParameters { get async }
}

extension RefdsSocketEndpoint {
    public func logger() async {
        do {
            let message = "\t HOST - \(await host) PORT - \(try await port) PARAMS - \(await parameters)"
            await Self.loggerInstance.info(message: message)
        } catch {
            await Self.loggerInstance.error(message: error.localizedDescription)
        }
    }
}
