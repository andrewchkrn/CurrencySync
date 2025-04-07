//
//  ErrorResponse.swift
//  CurrencySync
//
//  Created by Andrew Trach on 06.04.2025.
//

import Foundation

struct ErrorResponse: Decodable {
    let code: String
    let message: String

    var apiError: APIError {
        .default(code: code)
    }
}
