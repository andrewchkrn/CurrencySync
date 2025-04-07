//
//  FavoritesManager.swift
//  CurrencySync
//
//  Created by Andrew Trach on 06.04.2025.
//

import Foundation
import Combine

// MARK: - FavoritesManager
/// Favorites manager with persistent storage
class FavoritesManager: ObservableObject, FavoritesManagerProtocol {
    
    // MARK: - Properties
    private enum Constants {
        static let key = "favorites"
        static let defaultFavorites = ["USD", "GBP", "EUR"]
        static let defaultsSetKey = "favoritesDefaultsHaveBeenSet" 
    }
    
    let favoritesPublisher = PassthroughSubject<[String], Never>()
    private let storage: StorageProtocol
    
    @Published var favorites: [String] = [] {
        didSet {
            storage.save(favorites, forKey: Constants.key)
            favoritesPublisher.send(favorites)
        }
    }
    
    // MARK: - Initialization
    
    init(storage: StorageProtocol = AppStorageManager()) {
        self.storage = storage
        
        // Check if we've ever set default values before
        let defaultsHaveBeenSet: Bool = storage.load(forKey: Constants.defaultsSetKey) ?? false
        
        if let saved: [String] = storage.load(forKey: Constants.key) {
            self.favorites = saved
            
            // If the array is empty but we've never set defaults before
            if saved.isEmpty && !defaultsHaveBeenSet {
                self.favorites = Constants.defaultFavorites
                storage.save(true, forKey: Constants.defaultsSetKey)
            }
        } else {
            // First app launch (key doesn't exist in storage)
            self.favorites = Constants.defaultFavorites
            storage.save(true, forKey: Constants.defaultsSetKey)
        }
    }
    
    // MARK: - Public Methods
    func setFavorites(_ newFavorites: [String]) {
        favorites = newFavorites
    }
    
    func addFavorite(_ code: String) {
        if !favorites.contains(code) {
            favorites.append(code)
        }
    }
    
    func removeFavorite(_ code: String) {
        favorites.removeAll { $0 == code }
    }
}

// MARK: - Testing
/// Mock storage for unit tests
class MockStorageManager: StorageProtocol {
    var storage: [String: Data] = [:]
    
    func save<T: Codable>(_ value: T, forKey key: String) {
        if let encoded = try? JSONEncoder().encode(value) {
            storage[key] = encoded
        }
    }
    
    func load<T: Codable>(forKey key: String) -> T? {
        guard let data = storage[key],
              let decoded = try? JSONDecoder().decode(T.self, from: data)
        else {
            return nil
        }
        return decoded
    }
}
