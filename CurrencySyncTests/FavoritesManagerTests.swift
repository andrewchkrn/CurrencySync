//
//  CurrencySyncTests.swift
//  CurrencySyncTests
//
//  Created by Andrew Trach on 06.04.2025.
//

import Testing
import XCTest
import Combine
@testable import CurrencySync

final class FavoritesManagerTests: XCTestCase {
    
    // MARK: - Properties
    
    private var mockStorage: MockStorageManager!
    private var favoritesManager: FavoritesManager!
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Setup/Teardown
    
    override func setUp() {
        super.setUp()
        mockStorage = MockStorageManager()
        favoritesManager = FavoritesManager(storage: mockStorage)
    }
    
    override func tearDown() {
        mockStorage = nil
        favoritesManager = nil
        subscriptions.removeAll()
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testInitWithEmptyStorage() {
        XCTAssertEqual(favoritesManager.favorites, ["USD", "GBP", "EUR"])
    }
    
    func testInitWithExistingData() {
        let existingFavorites = ["JPY", "CAD"]
        mockStorage.save(existingFavorites, forKey: "favorites")
        
        let manager = FavoritesManager(storage: mockStorage)
        
        XCTAssertEqual(manager.favorites, existingFavorites)
    }
    
    func testAddFavorite() {
        favoritesManager.addFavorite("JPY")
        
        XCTAssertTrue(favoritesManager.favorites.contains("JPY"))
        XCTAssertEqual(favoritesManager.favorites.count, 4)
        
        let savedFavorites: [String]? = mockStorage.load(forKey: "favorites")
        XCTAssertNotNil(savedFavorites)
        XCTAssertTrue(savedFavorites!.contains("JPY"))
    }
    
    func testAddExistingFavorite() {
        XCTAssertTrue(favoritesManager.favorites.contains("USD"))
        let initialCount = favoritesManager.favorites.count
        
        favoritesManager.addFavorite("USD")
        
        XCTAssertEqual(favoritesManager.favorites.count, initialCount)
    }
    
    func testRemoveFavorite() {
        favoritesManager.removeFavorite("EUR")
        
        XCTAssertFalse(favoritesManager.favorites.contains("EUR"))
        XCTAssertEqual(favoritesManager.favorites.count, 2)
        
        let savedFavorites: [String]? = mockStorage.load(forKey: "favorites")
        XCTAssertNotNil(savedFavorites)
        XCTAssertFalse(savedFavorites!.contains("EUR"))
    }
    
    func testRemoveNonexistentFavorite() {
        XCTAssertFalse(favoritesManager.favorites.contains("CAD"))
        let initialCount = favoritesManager.favorites.count
        
        favoritesManager.removeFavorite("CAD")
        
        XCTAssertEqual(favoritesManager.favorites.count, initialCount)
    }
    
    func testSetFavorites() {
        let newFavorites = ["CAD", "AUD", "NZD"]
        
        favoritesManager.setFavorites(newFavorites)
        
        XCTAssertEqual(favoritesManager.favorites, newFavorites)
        
        let savedFavorites: [String]? = mockStorage.load(forKey: "favorites")
        XCTAssertEqual(savedFavorites, newFavorites)
    }
    
    func testPublisherEmitsOnChange() {
        var receivedValues: [[String]] = []
        
        favoritesManager.favoritesPublisher
            .sink { values in
                receivedValues.append(values)
            }
            .store(in: &subscriptions)
        
        favoritesManager.addFavorite("JPY")
        favoritesManager.removeFavorite("USD")
        favoritesManager.setFavorites(["CAD", "AUD"])
        
        XCTAssertEqual(receivedValues.count, 3)
        XCTAssertEqual(receivedValues[0], ["USD", "GBP", "EUR", "JPY"])
        XCTAssertEqual(receivedValues[1], ["GBP", "EUR", "JPY"])
        XCTAssertEqual(receivedValues[2], ["CAD", "AUD"])
    }
}
