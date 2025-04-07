//
//  CurrencyCoordinatorViewModel.swift
//  CurrencySync
//
//  Created by Andrew Trach on 06.04.2025.
//

import Foundation
import FlowStacks

@MainActor
class CurrencyCoordinatorViewModel: ObservableObject {
    
    enum Screen {
        case home
        case asset
    }
    
    // MARK: - Wrapped Properties
    @Published var favoritesManager = FavoritesManager()
    @Published var routes: Routes<Screen> = [.root(.home, embedInNavigationView: true)]
}

// Extensions for initializing view models
extension CurrencyCoordinatorViewModel {
    @MainActor
    func initCurrencyViewModel() -> CurrencyViewModel {
        CurrencyViewModel(favoritesManager: favoritesManager) { [weak self] event in
            switch event {
            case .showAsset:
                self?.routes.push(.asset)
            }
        }
    }
    
    @MainActor
    func initAssetViewModel() -> AssetViewModel {
        AssetViewModel(favoritesManager: favoritesManager) { [weak self] onEvent in
            switch onEvent {
            case .back:
                self?.routes.goBack()
            }
        }
    }
    
}
