import Combine
import Foundation

public extension URLSession {
    func publisher<R: Decodable>(
        for endpoint: RefdsNetworkEndpointProtocol,
        using requestData: RefdsNetworkRequestDataProtocol,
        on runLoop: RunLoop = .main,
        decoder: JSONDecoder = .init()
    ) -> AnyPublisher<R, RefdsNetworkError> {
        return restRequest(
            for: endpoint,
            using: requestData,
            on: runLoop,
            decoder: decoder
        )
    }
    
    
}

public extension URLSession {
    private func restRequest<R: Decodable>(
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
                    
                    if output.data.isEmpty {
                        throw RefdsNetworkError.finishedWithoutValue
                    }

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
        } catch RefdsNetworkError.invalidURL {
            return Fail(error: RefdsNetworkError.invalidURL)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: RefdsNetworkError.unknown(error))
                .eraseToAnyPublisher()
        }
    }
}

public extension URLSession {
    private func verifyError(from response: URLResponse) throws {
        guard let response = response as? HTTPURLResponse else {
            throw RefdsNetworkError.invalidResponse
        }

        if response.statusCode / 100 != 2 {
            throw RefdsNetworkError.statusCode(response.statusCode)
        }
    }
    
    private func isRest(for scheme: RefdsNetworkScheme) -> Bool {
        return scheme == .https || scheme == .http
    }
}
