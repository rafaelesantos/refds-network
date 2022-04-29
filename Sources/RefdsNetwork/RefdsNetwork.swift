//
//  RefdsNetwork.swift
//
//
//  Created by Rafael Santos on 26/04/22.
//
import Foundation
import Combine

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public struct RefdsNetwork {
    public struct Configuration {}
    
    public static let shared = RefdsNetwork()
    private let urlSession = URLSession.shared
    public let configuration = Configuration()
    
    public func request<R: Decodable>(for service: RefdsNetworkServiceConfigurationProtocol) -> AnyPublisher<R, Error> {
        return urlSession.publisher(for: service.endpoint, using: service.requestData)
    }
    
    public func request<R: Decodable>(for service: RefdsNetworkServiceConfigurationProtocol, completion: @escaping (Result<R, Error>) -> ()) {
        _ = urlSession.publisher(for: service.endpoint, using: service.requestData)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished: break
                case .failure(let error): completion(.failure(error))
                }
            }, receiveValue: { completion(.success($0)) })
    }
    
    public func request<R: Decodable>(for service: RefdsNetworkServiceConfigurationProtocol) async throws -> R {
        return try await urlSession.publisher(for: service.endpoint, using: service.requestData).async()
    }
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
extension RefdsNetwork {
    public func request<R: Decodable>(
        scheme: RefdsNetworkScheme = .https,
        host: String,
        path: String,
        queryItems: [URLQueryItem] = [],
        method: RefdsNetworkHTTPMethod,
        headers: RefdsNetworkHTTPHeaders,
        responseType: R.Type
    ) -> AnyPublisher<R, Error> {
        let service = configuration.service(
            scheme: scheme,
            host: host,
            path: path,
            queryItems: queryItems,
            method: method,
            headers: headers,
            responseType: responseType
        )
        return urlSession.publisher(for: service.endpoint, using: service.requestData)
    }
    
    public func request<R: Decodable>(
        scheme: RefdsNetworkScheme = .https,
        host: String,
        path: String,
        queryItems: [URLQueryItem] = [],
        method: RefdsNetworkHTTPMethod,
        headers: RefdsNetworkHTTPHeaders,
        responseType: R.Type,
        completion: @escaping (Result<R, Error>) -> ()
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
        
        _ = urlSession.publisher(for: service.endpoint, using: service.requestData)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished: break
                case .failure(let error): completion(.failure(error))
                }
            }, receiveValue: { completion(.success($0)) })
    }
    
    public func request<R: Decodable>(
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
        return try await urlSession.publisher(for: service.endpoint, using: service.requestData).async()
    }
}
