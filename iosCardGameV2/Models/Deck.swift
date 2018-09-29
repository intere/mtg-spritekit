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
    var mainboard: [CardGroup]
    var sideboard: [CardGroup]

    var mainboardCount: Int {
        return mainboard.reduce(0, { $0 + $1.quantity })
    }

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
}
