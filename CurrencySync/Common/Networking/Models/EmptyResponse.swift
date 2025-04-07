//
//  EmptyResponse.swift
//  CurrencySync
//
//  Created by Andrew Trach on 06.04.2025.
//

import Foundation

struct EmptyResponse: Codable { }

extension Encodable {
    var data: Data? {
        try? CodableService.defaultEncoder.encode(self)
    }
}
