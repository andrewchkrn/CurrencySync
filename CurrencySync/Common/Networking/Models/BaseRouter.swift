//
//  BaseRouter.swift
//  CurrencySync
//
//  Created by Andrew Trach on 06.04.2025.
//

import Foundation

class BaseRouter {
    
    private let apiKey = "77e8a76a3f0dd5442abbebdfbe49e435"

    var baseUrl: String {
        "https://api.exchangerate.host"
    }

    var method: HTTPMethod {
        fatalError("You have to override method property")
    }

    var path: String {
        return .empty
    }

    var headers: [String: String]? {
        return nil
    }

    var queryItems: [URLQueryItem]? {
        return nil
    }

    var body: Data? {
        return nil
    }

    func asURLRequest() throws -> URLRequest {

        var components = URLComponents(string: baseUrl)!

        components.path = path
        var allQueryItems = queryItems ?? []
        allQueryItems.append(URLQueryItem(name: "access_key", value: apiKey))
        components.queryItems = allQueryItems

        var request = URLRequest(url: components.url!)

        request.httpMethod = method.rawValue
        request.httpBody = body
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        headers?.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }

        return request
    }
}
