//
//  AppStorageManager.swift
//  CurrencySync
//
//  Created by Andrew Trach on 06.04.2025.
//

import Combine
import Foundation

// MARK: - Protocols

/// Storage protocol for data persistence
protocol StorageProtocol {
    func save<T: Codable>(_ value: T, forKey key: String)
    func load<T: Codable>(forKey key: String) -> T?
}

/// Protocol for managing favorite currencies
protocol FavoritesManagerProtocol {
    var favorites: [String] { get }
    var favoritesPublisher: PassthroughSubject<[String], Never> { get }
    func setFavorites(_ newFavorites: [String])
    func addFavorite(_ code: String)
    func removeFavorite(_ code: String)
}

// MARK: - AppStorageManager
/// UserDefaults based storage implementation
class AppStorageManager: StorageProtocol {
    func save<T: Codable>(_ value: T, forKey key: String) where T: Encodable {
        if let encoded = try? JSONEncoder().encode(value),
           let string = String(data: encoded, encoding: .utf8) {
            UserDefaults.standard.set(string, forKey: key)
        }
    }
    
    func load<T: Codable>(forKey key: String) -> T? where T: Decodable {
        guard let string = UserDefaults.standard.string(forKey: key),
              let data = string.data(using: .utf8),
              let decoded = try? JSONDecoder().decode(T.self, from: data)
        else {
            return nil
        }
        return decoded
    }
}
