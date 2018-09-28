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

/// Responsible for interacting with the cards service API (magicthegathering.io)
struct MtgApiService {

    static let shared = MtgApiService()
    let magic = Magic()

    init() {
        magic.fetchPageSize = "10"
        magic.fetchPageTotal = "1"
    }

    /// Loads an image for you.
    ///
    /// - Parameters:
    ///   - urlString: the image you want to load.
    ///   - completion: the completion handler.
    func loadImage(urlString: String, completion: @escaping Magic.CardImageCompletion) {
        if ImageCache.default.isImageCached(forKey: urlString).cached {
            ImageCache.default.retrieveImage(forKey: urlString, options: nil) { (image, _) in
                completion(image, nil)
            }
        } else {
            var card = MTGSDKSwift.Card()
            card.imageUrl = urlString
            magic.fetchImageForCard(card) { (image, error) in
                guard let image = image else {
                    return completion(nil, error)
                }
                ImageCache.default.store(image, forKey: urlString, toDisk: true)
                completion(image, error)
            }
        }

    }

    /// Loads the cards for an entire deck
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

                    if set.isEmpty {
                        completion(results, errorResult)
                    }
                    return
                }
            } catch {
                print("ERROR: \(error.localizedDescription)")
            }
            magic.fetchCards(params) { (cards, error) in
                if let error = error {
                    errorResult = error
                    print("Network error with card \(cardName): \(error.localizedDescription)")
                }
                guard let cards = cards, let card = cards.filter({ $0.name == cardName }).first else {
                    return
                }
                results.append(card)
                try? CardCacheService.shared.cache(card: card)

                let set = cardSet.subtracting(results.compactMap({ $0.name }))
                if Magic.enableLogging {
                    print("We have \(results.count) of \(cardSet.count) responses back: \(cardName)")
                    print("Updated Set: \(set)")
                }

                if set.isEmpty {
                    completion(results, errorResult)
                }
            }
        }
    }

}
