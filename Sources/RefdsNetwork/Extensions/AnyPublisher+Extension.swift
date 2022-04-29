//
//  AnyPublisher+Extension.swift
//  
//
//  Created by Rafael Santos on 29/04/22.
//

import Foundation
import Combine

@available(iOS 13.0, *)
@available(macOS 10.15, *)
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
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }, receiveValue: { output in
                finishedWithoutValue = false
                continuation.resume(with: .success(output))
            })
        }
    }
}
