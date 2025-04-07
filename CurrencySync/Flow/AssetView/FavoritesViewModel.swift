//
//  FavoritesViewModel.swift
//  Exchanger
//
//  Created by Andrew Trach on 15.04.2023.
//

import SwiftUI
import Combine

//class AssetViewModel: ObservableObject {
//    
//    enum Event {
//        case back
//    }
//    
//    // MARK: - Wrapped Properties
//    @Published var currencyPairs: [CurrencyPair] = []
//    @Published var storage = StorageManager.shared
//    
//    // MARK: - Properties
//    private var subscriptions = Set<AnyCancellable>()
//    private let onEvent: (Event) -> Void
//    
//    init(onEvent: @escaping (Event) -> Void) {
//        self.onEvent = onEvent
//        fetchExchangeRates()
//    }
//    
//    // MARK: - Public func
//    func rowTapped(key: String) {
////        onEvent(.back())
//    }
//    
//    func delete(at offsets: IndexSet) {
////        storage.favorites.remove(atOffsets: offsets)
//    }
//    
//    private func fetchExchangeRates() {
//        APIClient.exchangerClient.getExchangerate(currencies: "")
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] completion in
//                switch completion {
//                case .failure(let error):
//                    print("Error fetching exchange rates: \(error)")
//                case .finished:
//                    break
//                }
//            } receiveValue: { [weak self] data in
//                guard let self = self else { return }
//                
//                self.currencyPairs = data.quotes.map { key, value in
//                    CurrencyPair(pairCode: key, rate: value)
//                }.sorted { $0.pairCode < $1.pairCode }
//            }
//            .store(in: &subscriptions)
//    }
//    
//}
