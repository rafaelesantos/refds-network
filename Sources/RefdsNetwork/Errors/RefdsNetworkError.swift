//
//  EndpointError.swift
//  
//
//  Created by Rafael Santos on 27/04/22.
//

import Foundation

public enum RefdsNetworkError: RefdsNetworkErrorProtocol {
    case invalidURL
    case finishedWithoutValue
    case decodingFailed
    case unknown(Error)
    case invalidResponse
    case statusCode(Int)
    
    public var title: String {
        return self.content.title
    }
    
    public var description: String {
        return self.content.message
    }
}

extension RefdsNetworkError {
    private struct Content {
        var title: String
        var message: String
    }
    
    private var content: Content {
        switch self {
        case .invalidURL:
            return .init(title: "Invalid URL", message: "You need to check the app version.")
        case .finishedWithoutValue:
            return .init(title: "Finished Without Value", message: "The request returned no data.")
        case .decodingFailed:
            return .init(title: "Decoding Failed", message: "Não foi possivel serializar ou decodificar os dados recebidos.")
        case .unknown(let error):
            return .init(title: "Unknown Error", message: error.localizedDescription)
        case .invalidResponse:
            return .init(title: "Invalid Response", message: "Could not find a response from the server.")
        case .statusCode(let statusCode):
            if statusCode / 100 == 3 { return .init(title: "Redirection", message: "Additional actions are required to complete the request.") }
            else if statusCode / 100 == 5 { return .init(title: "Server Error", message: "The server failed to fulfil a request.") }
            else {
                if statusCode == 400 { return .init(title: "Bad Request", message: "The server cannot or will not process the request due to an apparent client error (e.g., malformed request syntax, size too large, invalid request message framing, or deceptive request routing).") }
                else if statusCode == 401 { return .init(title: "Unauthorized", message: "Required authentication not provided.") }
                else if statusCode == 403 { return .init(title: "Forbidden", message: "The request contained valid data and was understood by the server, but the server is refusing action. This may be due to the user not having the necessary permissions for a resource or needing an account of some sort, or attempting a prohibited action.") }
                else if statusCode == 404 { return .init(title: "Not Found", message: "The requested resource could not be found but may be available in the future. Subsequent requests by the client are permissible.") }
                else { return .init(title: "Client Error", message: "The requested request was not valid for the server, check what was sent.") }
            }
        }
    }
}
