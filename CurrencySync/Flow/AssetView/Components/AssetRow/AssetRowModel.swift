//
//  AssetRowModel.swift
//  CurrencySync
//
//  Created by Andrew Trach on 06.04.2025.
//

import Foundation

// MARK: - AssetRowModel
struct AssetRowModel {
    let title: String
    let isFavorite: Bool
    let onToggleFavorite: () -> Void
}
