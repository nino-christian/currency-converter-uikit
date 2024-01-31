//
//  ResponseModel.swift
//  currency-converter
//
//  Created by Nino-Christian on 1/30/24.
//

import Foundation

struct ResponseModel: Codable {
    var timestamp: Int
    var base: String
    var rates: [String: Double]
}
