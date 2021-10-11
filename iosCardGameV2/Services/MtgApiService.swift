//
//  CardManager.swift
//  CardGame
//
//  Created by Eric Internicola on 9/17/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import Foundation
import Kingfisher
//import MTGSDKSwift

/// A callback handler for when the deck is cached
typealias DeckCached = (Error?) -> Void

typealias CardCompletion = (Result<[CardSearchResults.Card], Error>) -> Void


/// Responsible for interacting with the cards service API (magicthegathering.io)
struct MtgApiService {

    static let shared = MtgApiService()
    let service = CombineMagicCardSearch()

    /// Ensures the cards in the deck are populated in the cache for you.
    ///
    /// - Parameters:
    ///   - deck: The deck to cache.
    ///   - completion: An optional completion handler that will have a nil error on success
    ///         and an error on failure.
    func cache(deck: Deck, completion: DeckCached? = nil) {
        loadCards(forDeck: deck) { result in
            switch result {
            case .success(let cards):
                    for card in cards {
                        guard let imageUrl = card.imageURL else {
                            continue
                        }
                        self.loadImage(urlString: imageUrl) { result in
                            switch result {
                            case .failure(let error):
                                print("Error loading image: \(error.localizedDescription)")
                            default:
                                break
                            }
                        }
                }
                completion?(nil)
                
            case .failure(let error):
                print("Error loading deck: \(error.localizedDescription)")
                completion?(error)
            }
        }
    }

    /// Loads an image for you.
    ///
    /// - Parameters:
    ///   - urlString: the image you want to load.
    ///   - completion: the completion handler.
    func loadImage(urlString: String, completion: @escaping CardImageCompletion) {
        if ImageCache.default.imageCachedType(forKey: urlString).cached {
            ImageCache.default.retrieveImage(forKey: urlString, options: nil) { (image, _) in
                guard let image = image else {
                    return completion(.failure(MtgApiServiceError.imageNotFoundInCache(imageName: urlString)))
                }
                completion(Result.success(image))
            }
        } else {
            service.loadImage(urlString: urlString) { result in
                switch result {
                case .success(let image):
                    ImageCache.default.store(image, forKey: urlString, toDisk: true)

                case .failure(let error):
                    print("Error fetching image \(urlString): \(error.localizedDescription)")
                }
                completion(result)
            }
        }

    }

    /// Loads the cards for an entire deck and assigns the card object to each
    /// of the `CardGroup` objects when loaded.
    ///
    /// - Parameters:
    ///   - deck: The deck to load the cards for.
    ///   - completion: The handler that handles the completion of the loading of the cards.
    func loadCards(forDeck deck: Deck, completion: @escaping CardCompletion) {
        let cardSet = Set(deck.uniqueCardNames)

        var results = [CardSearchResults.Card]()
        var errorResult: Error?

        cardSet.forEach { cardName in
            do {
                if let card = try CardCacheService.shared.loadCachedCard(named: cardName) {
                    results.append(card)
                    let set = cardSet.subtracting(results.compactMap({ $0.name }))
                    print("We have \(results.count) of \(cardSet.count) responses back: \(cardName)")
                    print("Updated Set: \(set)")
                    // Assign the card to the card in the deck
                    deck.getCards(byName: cardName).forEach { $0.card = card }

                    if set.isEmpty {
                        if let error = errorResult {
                            completion(.failure(error))
                        } else {
                            completion(.success(results))
                        }
                    }
                    return
                }
            } catch {
                print("ERROR: \(error.localizedDescription)")
                completion(.failure(error))
            }

            service.search(for: cardName) { result in
                let card = CardName.fromCardName(string: cardName)

                switch result {
                case .failure(let error):
                    errorResult = error
                case .success(let fetchedCards):
                    guard let card = fetchedCards.cards?.filter({ $0.name == card.name && $0.multiverseid != nil }).first else {
                        return completion(.failure(MtgApiServiceError.cardNotFoundInSearchResults(name: cardName)))
                    }
                    results.append(card)
                    try? CardCacheService.shared.cache(card: card)
                    deck.getCards(byName: cardName).forEach { $0.card = card }

                    let set = cardSet.subtracting(results.compactMap({ $0.name }))
                    print("We have \(results.count) of \(cardSet.count) responses back: \(cardName)")
                    print("Updated Set: \(set)")

                    if set.isEmpty {
                        if let error = errorResult {
                            completion(.failure(error))
                        } else {
                            completion(.success(results))
                        }
                    }
                }
            }
        }
    }

}

enum MtgApiServiceError: LocalizedError {
    case imageNotFoundInCache(imageName: String)
    case cardNotFoundInSearchResults(name: String)

    var errorDescription: String? {
        switch self {
        case .imageNotFoundInCache(let imageName):
            return "The image couldn't be found in the cache: '\(imageName)'"
        case .cardNotFoundInSearchResults(let name):
            return "The card wasn't found in the search results: '\(name)'"
        }
    }
}
