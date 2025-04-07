//
//  FavoritesViewModel.swift
//  CurrencySync
//
//  Created by Andrew Trach on 06.04.2025.
//

import SwiftUI
import Combine

// MARK: - Asset View Model
@MainActor
class AssetViewModel: ObservableObject {
    
    // MARK: - Enums
    enum Event {
        case back
    }
    
    enum ViewState {
        case loading
        case loaded
        case emptyData
        case emptySearchResults
    }
    
    enum Action {
        case back
        case done
        case retry
        case toggleFavorite(key: String)
    }
    
    // MARK: - Published Properties
    @Published var currencyPairs: [CurrencyPair] = []
    @Published var searchText = ""
    @Published var state: ViewState = .loading
    
    // MARK: - Private Properties
    private var favoritesManager: FavoritesManagerProtocol
    private var rawPairs: [(key: String, value: CurrencyRate)] = []
    private var subscriptions = Set<AnyCancellable>()
    private let onEvent: (Event) -> Void
    
    // Temporary favorites to track changes before saving
    private var temporaryFavorites: [String] = []
    
    // MARK: - Initialization
    init(favoritesManager: FavoritesManagerProtocol,
         onEvent: @escaping (Event) -> Void) {
        self.favoritesManager = favoritesManager
        self.onEvent = onEvent
        
        self.temporaryFavorites = favoritesManager.favorites
        
        fetchExchangeRates()
        subscription()
    }
    
    // MARK: - Public Method
    func handleAction(_ action: Action) {
        switch action {
        case .back:
            onEvent(.back)
        case .done:
            saveFavorites()
            onEvent(.back)
        case .retry:
            fetchExchangeRates()
        case .toggleFavorite(let key):
            toggleFavorite(key: key)
        }
    }
    
    // MARK: - Computed Properties
    /// Filtered currency pairs based on search text
    var filteredCurrencyPairs: [CurrencyPair] {
        if searchText.isEmpty {
            return currencyPairs
        } else {
            return currencyPairs.filter {
                $0.title.lowercased().contains(searchText.lowercased()) ||
                $0.pairCode.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    // MARK: - Private Methods
    // Set up search text observation
    private func subscription() {
        $searchText
            .sink { [weak self] _ in
                self?.updateViewState()
            }
            .store(in: &subscriptions)
    }
    
    /// Updates the view state based on current conditions
    private func updateViewState() {
        if state == .loading {
            return
        }
        
        if currencyPairs.isEmpty {
            state = .emptyData
        } else if !searchText.isEmpty && filteredCurrencyPairs.isEmpty {
            state = .emptySearchResults
        } else {
            state = .loaded
        }
    }
    
    /// Saves favorites to permanent storage
    private func saveFavorites() {
        favoritesManager.setFavorites(temporaryFavorites)
    }
    
    /// Toggles favorite status for a currency (only in temporary storage)
    private func toggleFavorite(key: String) {
        if temporaryFavorites.contains(key) {
            temporaryFavorites.removeAll { $0 == key }
        } else {
            temporaryFavorites.append(key)
        }
        
        // Update UI without saving to permanent storage
        updateCurrencyPairs()
    }
    
    /// Updates currency pairs with current favorite status
    private func updateCurrencyPairs() {
        self.currencyPairs = rawPairs.map { key, value in
            let title = String(key.suffix(3))
            let isFavorite = temporaryFavorites.contains(title)
            
            return CurrencyPair(
                pairCode: key,
                rate: value,
                isFavorite: isFavorite
            )
        }.sorted { $0.pairCode < $1.pairCode }
        
        updateViewState()
    }
    
    /// Fetches exchange rates from API
    private func fetchExchangeRates() {
        state = .loading
        
        APIClient.exchangerClient.getExchangerate(currencies: "")
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching exchange rates: \(error)")
                    self?.state = .emptyData
                case .finished:
                    break
                }
            } receiveValue: { [weak self] data in
                guard let self = self else { return }
                self.state = .loaded
                self.rawPairs = data.quotes.map { ($0, $1) }
                self.updateCurrencyPairs()
            }
            .store(in: &subscriptions)
    }
}
