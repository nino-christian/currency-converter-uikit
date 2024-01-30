//
//  Environment.swift
//  currency-converter
//
//  Created by Nino-Christian on 1/30/24.
//

import Foundation

let environment = Environment.Development

enum Environment {
    
    case Development
    
    var APP_API: String {
        switch self {
        case .Development:
            return "https://openexchangerates.org/api/"
        }
    }
}

enum Endpoint {
    case LatestCurrencies(Environment)
    
    var url: String {
        switch self {
        case .LatestCurrencies(let Environment):
            return "\(Environment.APP_API)latest.json"
        }
    }
}
