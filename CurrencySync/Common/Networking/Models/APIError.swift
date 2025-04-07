//
//  APIError.swift
//  CurrencySync
//
//  Created by Andrew Trach on 06.04.2025.
//

import Foundation

enum APIError: LocalizedError {

    case `default`(code: String = APIErrorCode.default.rawValue)
    case unathorized

    var errorDescription: String? {
        switch self {
        case .default(let code):
            return (APIErrorCode(rawValue: code) ?? .default).localizedMessage
        case .unathorized:
            return "Unathorized"
        }
    }
}
