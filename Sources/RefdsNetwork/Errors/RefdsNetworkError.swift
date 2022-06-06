import Foundation

/// All errors of RefdsNetwork with auxiliaries functions
public enum RefdsNetworkError: RefdsNetworkErrorProtocol {
    /// When invalid url occurs
    case invalidURL
    
    /// When completion finish withou value
    case finishedWithoutValue
    
    /// When there is a failure to decode the data
    case decodingFailed
    
    /// When the error is not identified
    /// - Parameters:
    ///    - error: Generic error
    case unknown(Error)
    
    /// When an invalid response occurs
    case invalidResponse
    
    /// When a status code that represents an error occurs
    /// - Parameters:
    ///    - statusCode: Integer representing HTTP Status Code
    case statusCode(Int)
    
    
    /// The title of the error
    public var title: String {
        return content.title
    }

    /// The message of the error
    public var description: String {
        return content.message
    }
}

extension RefdsNetworkError {
    private struct Content {
        var title: String
        var message: String
    }

    /// Get title and description for the reported error
    private var content: Content {
        switch self {
        case .invalidURL:
            return .init(
                title: "Invalid URL",
                message: "You need to check the app version."
            )
        case .finishedWithoutValue:
            return .init(
                title: "Finished Without Value",
                message: "The request returned no data."
            )
        case .decodingFailed:
            return .init(
                title: "Decoding Failed",
                message: "Não foi possivel serializar ou decodificar os dados recebidos."
            )
        case let .unknown(error):
            return .init(
                title: "Unknown Error",
                message: error.localizedDescription
            )
        case .invalidResponse:
            return .init(
                title: "Invalid Response",
                message: "Could not find a response from the server."
            )
        case let .statusCode(statusCode):
            switch statusCode {
            case 100...199:
                return .init(
                    title: "Redirection",
                    message: "Additional actions are required to complete the request."
                )
            case 500...599:
                return .init(
                    title: "Server Error",
                    message: "The server failed to fulfil a request."
                )
            case 400:
                return .init(
                    title: "Bad Request",
                    message: "The server cannot or will not process the request due to an apparent client error (e.g., malformed request syntax, size too large, invalid request message framing, or deceptive request routing)."
                )
            case 401:
                return .init(
                    title: "Unauthorized",
                    message: "Required authentication not provided."
                )
            case 403:
                return .init(
                    title: "Forbidden",
                    message: "The request contained valid data and was understood by the server, but the server is refusing action. This may be due to the user not having the necessary permissions for a resource or needing an account of some sort, or attempting a prohibited action."
                )
            case 404:
                return .init(
                    title: "Not Found",
                    message: "The requested resource could not be found but may be available in the future. Subsequent requests by the client are permissible."
                )
            default:
                return .init(
                    title: "Client Error",
                    message: "The requested request was not valid for the server, check what was sent."
                )
            }
        }
    }
}
