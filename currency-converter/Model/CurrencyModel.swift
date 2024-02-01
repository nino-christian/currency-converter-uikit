//
//  CurrencyModel.swift
//  currency-converter
//
//  Created by Nino-Christian on 1/30/24.
//

import Foundation

/// Data Model for list of rates under Response Model in [String: Double] type
struct CurrencyModel: Codable, Equatable {
    var name: String
    var rate: Double
}
