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
    ) -> AnyPublisher<R, RefdsNetworkError> {
        do {
            let request = try endpoint.setupRequest(with: requestData)
            return dataTaskPublisher(for: request)
                .receive(on: runLoop)
                .tryMap { [weak self] output in
                    try self?.verifyError(from: output.response)
                    if output.data.isEmpty { throw RefdsNetworkError.finishedWithoutValue }
                    return output.data
                }
                .decode(type: R.self, decoder: decoder)
                .mapError { error in
                    switch error {
                    case is Swift.DecodingError:
                        return .decodingFailed
                    default:
                        return .unknown(error)
                    }
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: RefdsNetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
    }
    
    private func verifyError(from response: URLResponse) throws {
        guard let response = response as? HTTPURLResponse else { throw RefdsNetworkError.invalidResponse }
        if response.statusCode != 200 { throw RefdsNetworkError.statusCode(response.statusCode) }
        
    }
}
