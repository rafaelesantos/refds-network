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
    func publisher<R>(for endpoint: RefdsNetworkEndpoint<R>, using requestData: RefdsNetworkRequestDataProtocol) -> AnyPublisher<R, Error> {
        do {
            let request = try endpoint.setupRequest(with: requestData)
            return dataTaskPublisher(for: request)
                .map(\.data)
                .decode(type: RefdsNetworkResponse<R>.self, decoder: JSONDecoder())
                .map(\.result)
                .mapError({ error in
                    print(error.localizedDescription)
                    return error
                })
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}
