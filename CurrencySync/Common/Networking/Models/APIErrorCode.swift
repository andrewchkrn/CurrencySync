//
//  APIErrorCode.swift
//  CurrencySync
//
//  Created by Andrew Trach on 06.04.2025.
//

import Foundation

enum APIErrorCode: String {
    // MARK: - Default
    case `default` = "default_error_code"
}

extension APIErrorCode {
    var localizedMessage: String {
        rawValue.localized()
    }
}
