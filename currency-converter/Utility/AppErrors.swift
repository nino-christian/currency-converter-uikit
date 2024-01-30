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
//    case decodingError(Error)
//    case networkFailure(CFNetworkErrors)
//    case resolvedNetworkError(Error)
    
    var description: String {
        switch self {
        case .invalidURL(let description):
            return "Invalid URL: \(description)"
        case .requestFailed(description: let description):
            return "Request failed: \(description)"
//        case .decodingError(_):
//            <#code#>
//        case .networkFailure(_):
//            <#code#>
//        case .resolvedNetworkError(_):
//            <#code#>
        }
    }
}

