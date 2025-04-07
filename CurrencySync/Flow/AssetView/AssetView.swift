//
//  FavoritesView.swift
//  CurrencySync
//
//  Created by Andrew Trach on 06.04.2025.
//

import SwiftUI

// MARK: - Asset View
struct AssetView: View {
    
    // MARK: - Properties
    @StateObject var viewModel: AssetViewModel
    
    // MARK: - Body
    var body: some View {
        VStack {
            SearchBar(text: $viewModel.searchText, placeholder: Constants.searchPlaceholder)
                .padding(.horizontal)
            
            // Content based on state
            switch viewModel.state {
            case .loading:
                loadingView
            case .emptyData:
                emptyDataView
            case .emptySearchResults:
                emptySearchResultsView
            case .loaded:
                currencyListView
            }
        }
        .navigationTitle(Constants.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(Constants.doneButtonText) {
                    viewModel.handleAction(.done)
                }
                .fontWeight(.bold)
            }
        }
    }
    
    // MARK: - View Components
    
    private var loadingView: some View {
        VStack {
            ProgressView()
                .padding()
            Text(Constants.loadingMessage)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyDataView: some View {
        VStack(spacing: Constants.spacing) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: Constants.iconSize))
                .foregroundColor(.orange)
            Text(Constants.noDataTitle)
                .font(.headline)
            Text(Constants.noDataMessage)
                .foregroundColor(.secondary)
            
            Button(action: {
                viewModel.handleAction(.retry)
            }) {
                Text(Constants.retryButtonText)
                    .fontWeight(.semibold)
                    .padding(.horizontal, Constants.buttonHorizontalPadding)
                    .padding(.vertical, Constants.buttonVerticalPadding)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(Constants.cornerRadius)
            }
            .padding(.top, Constants.topPadding)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptySearchResultsView: some View {
        VStack(spacing: Constants.spacing) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: Constants.iconSize))
                .foregroundColor(.gray)
            Text(Constants.noResultsTitle)
                .font(.headline)
            Text(Constants.noResultsMessage)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var currencyListView: some View {
        List {
            ForEach(viewModel.filteredCurrencyPairs) { pair in
                AssetRow(model: AssetRowModel(title: pair.title,
                                              isFavorite: pair.isFavorite,
                                              onToggleFavorite: {
                    self.viewModel.handleAction(.toggleFavorite(key: pair.key))
                })
                )
            }
        }
    }
}

extension AssetView {
    // MARK: - Constants
    private enum Constants {
        static let navigationTitle = "Add Asset"
        static let searchPlaceholder = "Search assets"
        static let doneButtonText = "Done"
        
        static let loadingMessage = "Loading currencies..."
        static let noDataTitle = "No currencies available"
        static let noDataMessage = "Please check your connection and try again"
        static let retryButtonText = "Retry"
        static let noResultsTitle = "No matches found"
        static let noResultsMessage = "Try different search terms"
        
        static let iconSize: CGFloat = 48
        static let spacing: CGFloat = 16
        static let buttonHorizontalPadding: CGFloat = 24
        static let buttonVerticalPadding: CGFloat = 10
        static let cornerRadius: CGFloat = 8
        static let topPadding: CGFloat = 8
    }
}
