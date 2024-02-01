//
//  AppErrors.swift
//  currency-converter
//
//  Created by Nino-Christian on 1/30/24.
//

import Foundation

enum APIError: Error {
    case invalidURL(String)
    case requestFailed(Error)
    case decodingError(Error)
    case networkFailure(Error)
    case resolvedNetworkError(Error)
    
    var description: String {
        switch self {
        case .invalidURL(let description):
            return "Invalid URL: \(description)"
        case .requestFailed(let error):
            return "Request failed: \(error)"
        case .decodingError(let error):
            return "Decoding error: \(error)"
        case .networkFailure(let error):
            return "Network error: \(error)"
        case .resolvedNetworkError(let error):
            return "Resolved eror"
        }
    }
}

enum CoreDataError: Error {
    case fetchRequestFailed(Error)
    case saveContextFailed(Error)
    
    
    var description: String {
        switch self {
        case .fetchRequestFailed(let error):
            return "Fetch request for entities failed: \(error)"
        case .saveContextFailed(let error):
            return "Could not save to context: \(error)"
        }
    }
}
