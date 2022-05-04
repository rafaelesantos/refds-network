//
//  AnyPublisher+Extension.swift
//
//
//  Created by Rafael Santos on 29/04/22.
//

import Combine
import Foundation

extension AnyPublisher {
    func async() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var finishedWithoutValue = true

            _ = first().sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    if finishedWithoutValue {
                        continuation.resume(throwing: RefdsNetworkError.finishedWithoutValue)
                    }
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }, receiveValue: { output in
                finishedWithoutValue = false
                continuation.resume(with: .success(output))
            })
        }
    }
}
