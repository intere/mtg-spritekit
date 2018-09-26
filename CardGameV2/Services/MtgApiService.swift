//
//  CardManager.swift
//  CardGame
//
//  Created by Eric Internicola on 9/17/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import Foundation
import MTGSDKSwift

/// Responsible for interacting with the cards service API (magicthegathering.io)
struct MtgApiService {

    static let shared = MtgApiService()
    let magic = Magic()

    init() {
        magic.fetchPageSize = "10"
        magic.fetchPageTotal = "1"
        Magic.enableLogging = true
    }

    /// Loads an image for you.
    ///
    /// - Parameters:
    ///   - urlString: the image you want to load.
    ///   - completion: the completion handler.
    func loadImage(urlString: String, completion: @escaping Magic.CardImageCompletion) {
        var card = MTGSDKSwift.Card()
        card.imageUrl = urlString

        magic.fetchImageForCard(card, completion: completion)
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
            magic.fetchCards(params, completion: { (cards, error) in
                if let error = error {
                    errorResult = error
                }
                guard let cards = cards, let card = cards.filter({ $0.imageUrl != nil }) .first else {
                    return
                }
                results.append(card)
                if results.count == cardSet.count {
                    completion(results, errorResult)
                }
            })
        }
    }

}
