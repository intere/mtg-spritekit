//
//  PlayerBoard.swift
//  CardGameV2
//
//  Created by Eric Internicola on 9/29/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import Foundation
import MTGSDKSwift

class PlayerBoard {

    /// The current player
    var player: Player

    private(set) var life = 20

    private(set) var poison = 0

    /// The number of mulligans the player took
    private(set) var mulligans = 0

    private(set) var canScry = false

    // TODO:
//    /// The player stats (life, poison, etc)
//    var stats: [StatType: Int]

    // TODO
//    var emblems: [Emblem]

    /// The player's library
    private(set) var library = [Card]()

    /// The player's graveyard
    private(set) var graveyard = [Card]()

    /// Cards the player has revealed
    var revealed = [Card]()

    /// The player's exiled cards
    var exile = [Card]()

    /// The player's hand
    var hand = [Card]()

    /// Gets you the player's deck
    var deck: Deck! {
        return player.deck
    }

    /// Tells you the number of cards in your hand.
    var cardsInHand: Int {
        return hand.count
    }

    /// Initializes the PlayerBoard using the provide player.  The library is then
    /// shuffled using the mainboard of the deck that belongs to the player.  The player
    /// is then dealt 7 cards from the deck.
    ///
    /// - Parameter player: The player to initialize this board from.
    init(player: Player) {
        self.player = player
    }

    /// Starts the game by shuffling the library and drawing 7 cards.
    func startGame() {
        library = player.deck.mainboardCards.shuffled()
        for _ in 0..<7 {
            hand.append(library.removeFirst())
        }
    }

    /// Takes a mulligan for you.
    func mulligan() {
        mulligans += 1
        canScry = true

        hand.removeAll()
        library = player.deck.mainboardCards.shuffled()
        let cardsInHand = 7 - mulligans
        guard cardsInHand > 0 else {
            return
        }
        for _ in 0..<cardsInHand {
            hand.append(library.removeFirst())
        }
    }
}
