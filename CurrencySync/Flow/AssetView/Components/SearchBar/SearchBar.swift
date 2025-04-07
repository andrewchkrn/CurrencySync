//
//  SearchBar.swift
//  CurrencySync
//
//  Created by Andrew Trach on 06.04.2025.
//

import SwiftUI

// MARK: - Search Bar
struct SearchBar: View {
    
    // MARK: - Properties
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        HStack {
            Image(systemName: Constants.iconName)
                .foregroundColor(.gray)
            
            TextField(placeholder, text: $text)
                .disableAutocorrection(true)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: Constants.clearIconName)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(Constants.padding)
        .background(Color(.systemGray6))
        .cornerRadius(Constants.cornerRadius)
    }
}

extension SearchBar {
    // MARK: - Private Constants
    private enum Constants {
        static let iconName = "magnifyingglass"
        static let clearIconName = "xmark.circle.fill"
        static let padding: CGFloat = 8
        static let cornerRadius: CGFloat = 10
    }
}
