//
//  ExchangerClient.swift
//  CurrencySync
//
//  Created by Andrew Trach on 06.04.2025.
//

import Foundation
import Combine

protocol ExchangerClientProtocol {
    func getExchangerate(currencies: String) -> AnyPublisher<CurrencyModel, Error>
}

final class ExchangerClient: ExchangerClientProtocol {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getExchangerate(currencies: String) -> AnyPublisher<CurrencyModel, Error> {
        networkService.performRequest(route: ExchangerRouter(endpoint: .getExchangerate(currencies)))
    }
}
