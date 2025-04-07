//
//  AssetRow.swift
//  CurrencySync
//
//  Created by Andrew Trach on 06.04.2025.
//

import SwiftUI

// MARK: - Asset Row
struct AssetRow: View {
  let model: AssetRowModel
    
    var body: some View {
        HStack {
            Text(model.title)
            
            Spacer()
            
            Button(action: model.onToggleFavorite) {
                Image(systemName: model.isFavorite ? "star.fill" : "star")
                    .foregroundColor(model.isFavorite ? .yellow : .gray)
            }
        }
        .padding(.vertical, 4)
    }
}
