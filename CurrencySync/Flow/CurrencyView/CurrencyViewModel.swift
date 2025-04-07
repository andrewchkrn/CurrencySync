//
//  CurrencyViewModel.swift
//  CurrencySync
//
//  Created by Andrew Trach on 06.04.2025.
//

import Combine
import Foundation

// MARK: - CurrencyViewModel
@MainActor
class CurrencyViewModel: ObservableObject {
    // MARK: - Types
    enum Event {
        case showAsset
    }
    
    enum ViewState {
        case loading
        case loaded
        case empty
        case error
    }
    
    enum Action {
        case openCurrencySelector
        case removeCurrency(key: String)
        case refreshRates
        case viewAppeared
        case viewDisappeared
    }
    
    // MARK: - Published Properties
    @Published var currencyPairs: [CurrencyPair] = []
    @Published var lastUpdateTime: Date? = nil
    @Published var state: ViewState = .loading
    
    // MARK: - Private Properties
    private var favoritesManager: FavoritesManagerProtocol
    private var subscriptions = Set<AnyCancellable>()
    private var refreshTimer: AnyCancellable?
    private let onEvent: (Event) -> Void
    private let refreshInterval: TimeInterval = 5
    
    // MARK: - Initialization
    init(
        favoritesManager: FavoritesManagerProtocol,
        onEvent: @escaping (Event) -> Void) {
            self.favoritesManager = favoritesManager
            self.onEvent = onEvent
            
            // Subscribe to changes in favorites
            setupFavoritesSubscription()
        }
    
    // MARK: - Public Methods
    
    /// Handles all actions for the view
    func handleAction(_ action: Action) {
        switch action {
        case .openCurrencySelector:
            onEvent(.showAsset)
            
        case .removeCurrency(let key):
            removeCurrency(key: key)
            
        case .refreshRates:
            fetchExchangeRates()
            
        case .viewAppeared:
            fetchExchangeRates()
            startRefreshTimer()
            
        case .viewDisappeared:
            stopRefreshTimer()
        }
    }
    
    // MARK: - Private Method
    /// Sets up subscription to favorites changes
    private func setupFavoritesSubscription() {
        favoritesManager.favoritesPublisher
            .map { $0.count }
            .removeDuplicates()
            .scan((0, 0)) { accumulator, current in
                return (accumulator.1, current)
            }
            .filter { previous, current in
                return current > previous && previous > 0 // Skip initial value
            }
            .sink { [weak self] _ in
                self?.fetchExchangeRates()
            }
            .store(in: &subscriptions)
    }
    
    /// Starts timer for periodic exchange rate updates
    private func startRefreshTimer() {
        stopRefreshTimer()
        
        refreshTimer = Timer.publish(every: refreshInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.fetchExchangeRates()
            }
    }
    
    /// Stops the exchange rates refresh timer
    private func stopRefreshTimer() {
        refreshTimer?.cancel()
        refreshTimer = nil
    }
    
    /// Removes a currency from favorites (implementation)
    /// - Parameter key: Currency identifier to remove
    private func removeCurrency(key: String) {
        favoritesManager.removeFavorite(key)
        
        // Update UI after removal
        currencyPairs.removeAll { $0.key == key }
        updateViewState()
    }
    
    /// Updates the view state based on current data
    private func updateViewState() {
        if currencyPairs.isEmpty {
            state = .empty
        } else {
            state = .loaded
        }
    }
    
    /// Fetches exchange rates from API
    private func fetchExchangeRates() {
        state = currencyPairs.isEmpty ? .loading : .loaded
        
        guard !favoritesManager.favorites.isEmpty else {
            state = .empty
            lastUpdateTime = nil
            return
        }
        
        APIClient.exchangerClient.getExchangerate(currencies: favoritesManager.favorites.joined(separator: ","))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    guard let self = self else { return }
                    self.state = currencyPairs.isEmpty ? .error : .loaded
                    print("Error fetching exchange rates: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] data in
                guard let self = self else { return }
                
                self.updateCurrencyPairs(with: data)
                self.lastUpdateTime = Date()
                self.updateViewState()
            }
            .store(in: &subscriptions)
    }
    
    /// Updates currency pair models with API data
    /// - Parameter data: Exchange rate data from API
    private func updateCurrencyPairs(with data: CurrencyModel) {
        let favorites = favoritesManager.favorites
        
        self.currencyPairs = data.quotes.map { key, value in
            let title = String(key.suffix(3))
            let isFavorite = favorites.contains(title)
            
            return CurrencyPair(
                pairCode: key,
                rate: value,
                isFavorite: isFavorite
            )
        }.sorted { $0.pairCode < $1.pairCode }
    }
}
