//
//  URLSession+Extension.swift
//  
//
//  Created by Rafael Santos on 26/04/22.
//

import Foundation
import Combine

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public extension URLSession {
    func publisher<R: Decodable>(
        for endpoint: RefdsNetworkEndpointProtocol,
        using requestData: RefdsNetworkRequestDataProtocol,
        on runLoop: RunLoop = .main,
        decoder: JSONDecoder = .init()
    ) -> AnyPublisher<R, Error> {
        do {
            let request = try endpoint.setupRequest(with: requestData)
            return dataTaskPublisher(for: request)
                .receive(on: runLoop)
                .map(\.data)
                .decode(type: R.self, decoder: decoder)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}
