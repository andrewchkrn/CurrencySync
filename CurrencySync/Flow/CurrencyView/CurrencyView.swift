//
//  CurrencyView.swift
//  CurrencySync
//
//  Created by Andrew Trach on 06.04.2025.
//

import SwiftUI

// MARK: - Currency View
struct CurrencyView: View {
    
    // MARK: - Properties
    @StateObject var viewModel: CurrencyViewModel
    
    // MARK: - Body
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                loadingView
            case .loaded:
                currencyListView
            case .empty:
                emptyStateView
            case .error:
                errorView
            }
        }
        .animation(.easeInOut, value: viewModel.currencyPairs.count)
        .refreshable {
            viewModel.handleAction(.refreshRates)
        }
        .navigationTitle(Constants.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                headerView
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                addButton
            }
        }
        .onAppear {
            viewModel.handleAction(.viewAppeared)
        }
        .onDisappear {
            viewModel.handleAction(.viewDisappeared)
        }
    }
    
    // MARK: - View Components
    private var headerView: some View {
        VStack {
            Text(Constants.navigationTitle)
                .font(.headline)
            LastUpdateTimeView(lastUpdateTime: viewModel.lastUpdateTime)
                .font(.caption)
        }
    }
    
    private var addButton: some View {
        Button {
            viewModel.handleAction(.openCurrencySelector)
        } label: {
            Image(systemName: "plus")
        }
        .padding(.trailing)
    }
    
    private var loadingView: some View {
        VStack {
            ProgressView()
                .padding()
            Text(Constants.loadingMessage)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
    
    private var errorView: some View {
        VStack(spacing: Constants.emptyStateSpacing) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: Constants.errorIconSize))
                .foregroundColor(.red)
            
            Text(Constants.errorTitle)
                .font(.headline)
            
            Text(Constants.errorMessage)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Constants.emptyMessageHorizontalPadding)
            
            Button {
                viewModel.handleAction(.refreshRates)
            } label: {
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
        .background(Color(.systemGroupedBackground))
    }
    
    private var emptyStateView: some View {
        VStack(spacing: Constants.emptyStateSpacing) {
            Image(systemName: "dollarsign.circle")
                .font(.system(size: Constants.emptyIconSize))
                .foregroundColor(.gray)
            
            Text(Constants.emptyTitle)
                .font(.headline)
            
            Button {
                viewModel.handleAction(.openCurrencySelector)
            } label: {
                Text(Constants.addButtonText)
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
        .background(Color(.systemGroupedBackground))
    }
    
    private var currencyListView: some View {
        List {
            ForEach(viewModel.currencyPairs) { pair in
                CurrencyRowView(
                    model: CurrencyRowModel(
                        title: pair.title,
                        subtitle: pair.subtitle,
                        value: pair.value,
                        changed: pair.changed
                    )
                )
                .swipeActions {
                    Button(role: .destructive) {
                        withAnimation {
                            viewModel.handleAction(.removeCurrency(key: pair.key))
                        }
                    } label: {
                        Label(Constants.deleteActionLabel, systemImage: "trash")
                    }
                }
            }
        }
    }
}

extension CurrencyView {
    // MARK: - Constants
    private enum Constants {
        static let navigationTitle = "Exchange Rates"
        static let loadingMessage = "Loading exchange rates..."
        static let emptyTitle = "No currencies to display"
        static let addButtonText = "Add Currencies"
        static let deleteActionLabel = "Delete"
        static let errorTitle = "Failed to load rates"
        static let errorMessage = "We couldn't load the exchange rates. Please check your connection."
        static let retryButtonText = "Retry"
        
        static let emptyIconSize: CGFloat = 64
        static let errorIconSize: CGFloat = 64
        static let buttonHorizontalPadding: CGFloat = 24
        static let buttonVerticalPadding: CGFloat = 10
        static let cornerRadius: CGFloat = 8
        static let emptyMessageHorizontalPadding: CGFloat = 40
        static let emptyStateSpacing: CGFloat = 16
        static let topPadding: CGFloat = 8
    }
}
