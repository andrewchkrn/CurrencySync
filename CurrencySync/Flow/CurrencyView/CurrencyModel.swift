//
//  CurrencyModel.swift
//  Exchanger
//
//  Created by Andrew Trach on 06.04.2025.
//

import Foundation

// MARK: - Exchangerate
struct CurrencyModel: Codable, Hashable, Equatable {
    let change: Bool
    let quotes: [String: CurrencyRate]
    
    enum CodingKeys: String, CodingKey {
        case change, quotes
    }
}

struct CurrencyRate: Codable, Hashable {
    let startRate: Double
    let endRate: Double
    let change: Double
    let changePercentage: Double
    
    enum CodingKeys: String, CodingKey {
        case startRate = "start_rate"
        case endRate = "end_rate"
        case change
        case changePercentage = "change_pct"
    }
}

extension CurrencyModel {
    func getRate(from baseCurrency: String, to targetCurrency: String) -> CurrencyRate? {
        return quotes["\(baseCurrency)\(targetCurrency)"]
    }
}

struct CurrencyPair: Identifiable {
    let id = UUID()
    let pairCode: String
    let rate: CurrencyRate
    let isFavorite: Bool
    
    var title: String {
        return "\(String(pairCode.suffix(3)))"
    }
    
    var subtitle: String {
        return "\(String(format: "%.4f", rate.endRate))"
    }
    
    var value: String {
        return String(format: "%.4f", rate.endRate)
    }
    
    var changed: String {
        return String(format: "%.2f%%", rate.changePercentage)
    }
    
    var isPositive: Bool {
        return rate.change >= 0
    }
    
    var key: String {
        return "\(String(pairCode.suffix(3)))"
    }
}
