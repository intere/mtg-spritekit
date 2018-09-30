//
//  Deck.swift
//  CardGameV2
//
//  Created by Eric Internicola on 9/29/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import Foundation
import MTGSDKSwift


/// Represents a unique card in a deck, it tells us the card name, quantity
/// and holds an optional reference to the card object itself.
/// For example, in a deck, you might have `4, Mox Opal` cards.  This would
/// correlate to a single `CardGroup`, with a `quantity` of 4, the `name` Mox Opal
/// and after the cache is populated, you should also have the associated `Card`.
class CardGroup {
    var name: String
    var quantity: Int
    var card: Card? = nil

    init(name: String = "", quantity: Int = 1, card: Card? = nil) {
        self.name = name
        self.quantity = quantity
        self.card = card
    }
}

class Deck {
    /// Gets you the mainboard of this deck
    var mainboard: [CardGroup]

    /// Gets you the sideboard of this deck
    var sideboard: [CardGroup]

    /// Tells you how many cards are in the mainboard
    var mainboardCount: Int {
        return mainboard.reduce(0, { $0 + $1.quantity })
    }

    /// Tells you how many cards are in the sideboard
    var sideboardCount: Int {
        return sideboard.reduce(0, { $0 + $1.quantity })
    }

    /// Gets you the unique set of card names from the deck.
    var uniqueCardNames: [String] {
        var set = Set(mainboard.map({ $0.name }))
        sideboard.forEach {
            set.insert($0.name)
        }

        return Array(set)
    }

    /// Initializer for the deck.  You can initialize with an optional `mainboard` and optional `sideboard`
    /// or it will default to an empty deck (no cards in either mainboard or sideboard).
    ///
    /// - Parameters:
    ///   - mainboard: The mainboard to initialize with or empty.
    ///   - sideboard: The sideboard to initialize with or empty.
    init(mainboard: [CardGroup] = [], sideboard: [CardGroup] = []) {
        self.mainboard = mainboard
        self.sideboard = sideboard
    }

    /// Gets you an array of cards (by name).  The reason it returns an array
    /// is that a unique card name can be in both the mainboard and the sideboard.
    /// A call to this function will return either 0, 1 or 2 cards, depending
    /// on whether the card lives in the mainboard, sideboard, both, or neither.
    ///
    /// - Parameter name: The name of the card you want.
    /// - Returns: An array of cards that match by name.
    func getCards(byName name: String) -> [CardGroup] {
        var results = mainboard.filter { $0.name.lowercased() == name.lowercased() }
        results.append(contentsOf: sideboard.filter({ $0.name.lowercased() == name.lowercased() }))
        return results
    }

    /// Gets you the cards in the main board.
    var mainboardCards: [Card] {
        return mainboard.flatMap { $0.cards }
    }

    /// Gets you the cards in the side board.
    var sideboardCards: [Card] {
        return sideboard.flatMap { $0.cards }
    }
}

// MARK: - Implementation

extension CardGroup {

    /// Assumes that the card is cached, and based on that assumption gives
    /// you the `quantity` number of cards back for this CardGroup
    var cards: [Card] {
        guard let card = card else {
            assertionFailure("\(name) is missing its card")
            return [Card]()
        }
        var cards = [Card]()
        for _ in 0..<quantity {
            cards.append(card)
        }
        return cards
    }
}
