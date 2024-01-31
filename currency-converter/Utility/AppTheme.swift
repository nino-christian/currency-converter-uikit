//
//  AppTheme.swift
//  currency-converter
//
//  Created by Nino-Christian on 1/26/24.
//

import Foundation
import UIKit

//struct AppTheme {
//
//    static let primaryBGColor: UIColor = .systemBackground
//    static let primaryTextColor: UIColor = .black
//    static let disabledTextColor: UIColor = .gray
//}

struct AppTheme {
    
    enum AppColor {
    
        case whiteSmoke,
             navyBlue,
             suvaGray,
             lightGray,
             watermelon,
             white,
             black
        
        var uiColor: UIColor {
            switch self {
            case .whiteSmoke:
                UIColor(hex: "F5F5F5") ?? .white
            case .navyBlue:
                UIColor(hex: "000080") ?? .black
            case .suvaGray:
                UIColor(hex: "666666") ?? .gray
            case .lightGray:
                UIColor(hex: "CCCCCC") ?? .lightGray
            case .watermelon:
                UIColor(hex: "FD4659") ?? .systemPink
            case .white:
                UIColor(hex: "FFFFFF") ?? .white
            case .black:
                UIColor(hex: "000000") ?? .black
            }
        }
    }
}

