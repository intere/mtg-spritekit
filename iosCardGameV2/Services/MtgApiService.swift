//
//  CardManager.swift
//  CardGame
//
//  Created by Eric Internicola on 9/17/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import Foundation
import Kingfisher
import MTGSDKSwift

/// A callback handler for when the deck is cached
typealias DeckCached = (Error?) -> Void

/// Responsible for interacting with the cards service API (magicthegathering.io)
struct MtgApiService {

    static let shared = MtgApiService()
    let magic = Magic()
    let config = MTGSearchConfiguration(pageSize: 20, pageTotal: 1)

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
                        guard let imageUrl = card.imageUrl else {
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
    func loadImage(urlString: String, completion: @escaping Magic.CardImageCompletion) {
        if ImageCache.default.imageCachedType(forKey: urlString).cached {
            ImageCache.default.retrieveImage(forKey: urlString, options: nil) { (image, _) in
                guard let image = image else {
                    return completion(.failure(NetworkError.fetchCardImageError("The card was not found in the cache")))
                }
                completion(Result.success(image))
            }
        } else {
            var card = MTGSDKSwift.Card()
            card.imageUrl = urlString
            magic.fetchImageForCard(card) { result in

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
    func loadCards(forDeck deck: Deck, completion: @escaping Magic.CardCompletion) {
        var cardSet = Set(deck.mainboard.map({ $0.name }))
        deck.sideboard.forEach { cardSet.insert($0.name) }

        var results = [MTGSDKSwift.Card]()
        var errorResult: NetworkError?

        cardSet.forEach { cardName in
            let params = [
                CardSearchParameter(parameterType: .name, value: cardName),
                CardSearchParameter(parameterType: .contains, value: "imageUrl")
            ]
            do {
                if let card = try CardCacheService.shared.loadCachedCard(named: cardName) {
                    results.append(card)
                    let set = cardSet.subtracting(results.compactMap({ $0.name }))
                    if Magic.enableLogging {
                        print("We have \(results.count) of \(cardSet.count) responses back: \(cardName)")
                        print("Updated Set: \(set)")
                    }
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
            }

            magic.fetchCards(params, configuration: config) { result in

                switch result {
                case .failure(let error):
                    errorResult = error
                    print("Network error with card \(cardName): \(error.localizedDescription)")

                case .success(let cards):
                    guard let card = cards.filter({ $0.name == cardName && $0.multiverseid != nil }).first else {
                        return
                    }
                    results.append(card)
                    try? CardCacheService.shared.cache(card: card)
                    deck.getCards(byName: cardName).forEach { $0.card = card }

                    let set = cardSet.subtracting(results.compactMap({ $0.name }))
                    if Magic.enableLogging {
                        print("We have \(results.count) of \(cardSet.count) responses back: \(cardName)")
                        print("Updated Set: \(set)")
                    }

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
