//
//  CardCacheService.swift
//  CardGameTests
//
//  Created by Eric Internicola on 9/27/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import Foundation
//import MTGSDKSwift

class CardCacheService {
    static let shared = CardCacheService()

    /// An in-memory card cache
    var memoryCache = NSCache<NSString, AnyObject>()

    /// A mapping of card name -> multiverse id that's written to UserDefaults.
    /// The idea is so that we can take a card name and map it to the id and
    /// then look for the cache file for that id.
    var cardNameToMultiverseidMapping: [String: String] {
        get {
            return UserDefaults.standard.dictionary(forKey: DefaultKeys.cardNameCache) as? [String: String] ?? [:]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: DefaultKeys.cardNameCache)
        }
    }

    /// Caches the provided card by doing the following:
    /// 1. Serialize the card to a JSON file (multiverseid + ".json")
    /// 2. Populate the UserDefaults card hash (name: multiversid)
    ///
    /// - Parameter card: The card to cache
    func cache(card: CardSearchResults.Card) throws {
        guard let name = card.name, let multiverseid = card.multiverseid,
            let cacheDirectory = cacheDirectory else {
            return assertionFailure("ERROR: we are missing the minimal information to cache the card")
        }
        let path = cacheDirectory.appendingPathComponent("\(multiverseid).json")
        try card.jsonData?.write(to: path)
        cardNameToMultiverseidMapping[name.lowercased()] = multiverseid
        memoryCache.setObject(card as AnyObject, forKey: name.lowercased() as NSString)
    }

    /// Searches for a cached card by name, and if it's cached, gives it back to you.
    ///
    /// - Parameter name: The name of the cached card.
    /// - Returns: The card if it was cached, nil if not.
    /// - Throws: If there was an I/O issue.
    func loadCachedCard(named name: String) throws -> CardSearchResults.Card? {
        if let card = memoryCache.object(forKey: name.lowercased() as NSString) as? CardSearchResults.Card {
            return card
        }
        guard let multiverseid = cardNameToMultiverseidMapping[name.lowercased()],
            let cacheDirectory = cacheDirectory else {
            return nil
        }

        let path = cacheDirectory.appendingPathComponent("\(multiverseid).json")
        guard FileManager.default.fileExists(atPath: path.path) else {
            return nil
        }
        let data = try Data(contentsOf: path)
        guard let card = CardSearchResults.Card.from(json: data) else { return nil }

        // Put the card back into the in-memory cache:
        memoryCache.setObject(card as AnyObject, forKey: name.lowercased() as NSString)
        return card
    }

}

// MARK: - Implementation

extension CardCacheService {

    struct DefaultKeys {
        static let cardNameCache = "cardCache"
    }

    var cacheDirectory: URL? {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
    }

}
