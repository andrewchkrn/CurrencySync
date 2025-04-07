//
//  String+Extensions.swift
//  CurrencySync
//
//  Created by Andrew Trach on 06.04.2025.
//

import Foundation

extension String {

    static var empty: String {
        String()
    }

    var deletingPathExtension: String {
        return NSString(string: self).deletingPathExtension
    }

    var pathExtension: String {
        return NSString(string: self).pathExtension
    }
    
    func localized() -> String {
        NSLocalizedString(self, comment: "")
    }
}

extension String: Identifiable {
    
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}
