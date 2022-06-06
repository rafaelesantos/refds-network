import Combine
import Foundation

public extension AnyPublisher {
    /**
     Convert to asynchronous call without observer
     - Returns: A response that needs to wait to be processed
     - Throws:`RefdsNetworkError.finishedWithoutValue`
                if `finishedWithoutValue` is true
     */
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
