//
//  CurrencySyncApp.swift
//  CurrencySync
//
//  Created by Andrew Trach on 06.04.2025.
//

import SwiftUI

@main
struct CurrencySyncApp: App {
    
    var body: some Scene {
        WindowGroup {
            CurrencyCoordinator(viewModel: CurrencyCoordinatorViewModel())
                .topConnectionAlert()
        }
    }
}
