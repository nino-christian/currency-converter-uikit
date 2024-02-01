//
//  ResponseModel.swift
//  currency-converter
//
//  Created by Nino-Christian on 1/30/24.
//

import Foundation

/// Data Model for Data object returned from repository
struct ResponseModel: Codable {
    var timestamp: Int
    var base: String
    var rates: [String: Double]
}
