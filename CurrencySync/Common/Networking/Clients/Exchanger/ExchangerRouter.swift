//
//  ExchangerRouter.swift
//  CurrencySync
//
//  Created by Andrew Trach on 06.04.2025.
//

import Foundation

enum ExchangerEndpoint {
    case getExchangerate(_ currencies: String)
}

final class ExchangerRouter: BaseRouter {

    private let endpoint: ExchangerEndpoint

    init(endpoint: ExchangerEndpoint) {
        self.endpoint = endpoint
    }

    override var path: String {
        switch endpoint {
        case .getExchangerate:
            return "/change"
        }
    }

    override var method: HTTPMethod {
        switch endpoint {
        case .getExchangerate:
            return .get
        }
    }

    override var queryItems: [URLQueryItem]? {
        switch endpoint {
        case .getExchangerate(let currencies):
            return [URLQueryItem(name: "currencies", value: currencies)]
        }
    }

    override var body: Data? {
        switch endpoint {
        case .getExchangerate:
            return nil
        }
    }
}
