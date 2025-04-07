//
//  CurrencyCoordinator.swift
//  CurrencySync
//
//  Created by Andrew Trach on 06.04.2025.
//

import FlowStacks
import SwiftUI

struct CurrencyCoordinator: View {
    
    // MARK: - Wrapped Properties
    @StateObject var viewModel: CurrencyCoordinatorViewModel
    
    // MARK: - Body View
    var body: some View {
        Router($viewModel.routes) { screen, _ in
            switch screen {
            case .home:
                CurrencyView(viewModel: viewModel.initCurrencyViewModel())
            case .asset:
                AssetView(viewModel: viewModel.initAssetViewModel())
            }
        }
    }
}
