//
//  CurrencyRowView.swift
//  CurrencySync
//
//  Created by Andrew Trach on 06.04.2025.
//

import SwiftUI

struct CurrencyRowView: View {
    let model: CurrencyRowModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(model.title)
                    .font(.headline)
                Text(model.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(model.value)
                    .font(.headline)
                Text(model.changed)
                    .font(.subheadline)
                    .foregroundColor(Double(model.changed.dropLast()) ?? 0 >= 0 ? .green : .red)
            }
        }
        .padding(.vertical, 4)
    }
}
