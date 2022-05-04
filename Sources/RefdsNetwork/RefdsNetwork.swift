//
//  RefdsNetwork.swift
//
//
//  Created by Rafael Santos on 26/04/22.
//
import Combine
import Foundation

public struct RefdsNetwork {
    public struct Configuration {}

    public static let shared = RefdsNetwork()
    private let urlSession = URLSession.shared
    public let configuration = Configuration()

    public func request<R: Decodable>(
        for service: RefdsNetworkServiceConfigurationProtocol
    ) -> AnyPublisher<R, RefdsNetworkError> {
        return urlSession
            .publisher(
                for: service.endpoint,
                using: service.requestData
            )
    }

    public func request<R: Decodable>(
        for service: RefdsNetworkServiceConfigurationProtocol,
        completion: @escaping (Result<R, RefdsNetworkError>) -> Void
    ) {
        _ = urlSession
            .publisher(
                for: service.endpoint,
                using: service.requestData
            )
            .sink(receiveCompletion: { result in
                var finishedWithoutValue = true
                switch result {
                case .finished:
                    if finishedWithoutValue {
                        completion(.failure(.finishedWithoutValue))
                    }
                case let .failure(error):
                    finishedWithoutValue = false
                    completion(.failure(error))
                }
            }, receiveValue: { completion(.success($0)) })
    }

    public func request<R: Decodable>(
        for service: RefdsNetworkServiceConfigurationProtocol
    ) async throws -> R {
        return try await urlSession
            .publisher(
                for: service.endpoint,
                using: service.requestData
            )
            .async()
    }
}

public extension RefdsNetwork {
    func request<R: Decodable>(
        scheme: RefdsNetworkScheme = .https,
        host: String,
        path: String,
        queryItems: [URLQueryItem] = [],
        method: RefdsNetworkHTTPMethod,
        headers: RefdsNetworkHTTPHeaders,
        responseType: R.Type
    ) -> AnyPublisher<R, RefdsNetworkError> {
        let service = configuration.service(
            scheme: scheme,
            host: host,
            path: path,
            queryItems: queryItems,
            method: method,
            headers: headers,
            responseType: responseType
        )

        return urlSession
            .publisher(
                for: service.endpoint,
                using: service.requestData
            )
    }

    func request<R: Decodable>(
        scheme: RefdsNetworkScheme = .https,
        host: String,
        path: String,
        queryItems: [URLQueryItem] = [],
        method: RefdsNetworkHTTPMethod,
        headers: RefdsNetworkHTTPHeaders,
        responseType: R.Type,
        completion: @escaping (Result<R, RefdsNetworkError>) -> Void
    ) {
        let service = configuration.service(
            scheme: scheme,
            host: host,
            path: path,
            queryItems: queryItems,
            method: method,
            headers: headers,
            responseType: responseType
        )

        _ = urlSession
            .publisher(
                for: service.endpoint,
                using: service.requestData
            )
            .sink(receiveCompletion: { result in
                var finishedWithoutValue = true
                switch result {
                case .finished:
                    if finishedWithoutValue {
                        completion(.failure(.finishedWithoutValue))
                    }
                case let .failure(error):
                    finishedWithoutValue = false
                    completion(.failure(error))
                }
            }, receiveValue: { completion(.success($0)) })
    }

    func request<R: Decodable>(
        scheme: RefdsNetworkScheme = .https,
        host: String,
        path: String,
        queryItems: [URLQueryItem] = [],
        method: RefdsNetworkHTTPMethod,
        headers: RefdsNetworkHTTPHeaders,
        responseType: R.Type
    ) async throws -> R {
        let service = configuration.service(
            scheme: scheme,
            host: host,
            path: path,
            queryItems: queryItems,
            method: method,
            headers: headers,
            responseType: responseType
        )
        return try await urlSession
            .publisher(
                for: service.endpoint,
                using: service.requestData
            )
            .async()
    }
}
