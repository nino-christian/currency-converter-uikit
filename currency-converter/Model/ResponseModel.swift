//
//  ResponseModel.swift
//  currency-converter
//
//  Created by DNA-User on 1/30/24.
//

import Foundation

struct ResponseModel: Codable {
    var timestamp: Int
    var base: String
    var rates: [String: Double]
}
