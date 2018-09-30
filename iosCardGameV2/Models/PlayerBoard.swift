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

    var life = 20

    var poison = 0

    // TODO:
//    /// The player stats (life, poison, etc)
//    var stats: [StatType: Int]

    // TODO
//    var emblems: [Emblem]

    /// The player's library
    var library: [Card]

    /// The player's graveyard
    var graveyard = [Card]()

    /// Cards the player has revealed
    var revealed = [Card]()

    /// The player's exiled cards
    var exile = [Card]()

    /// The player's hand
    var hand = [Card]()

    /// Gets you the player's deck
    var deck: Deck {
        return player.deck
    }

    /// Initializes the PlayerBoard using the provide player.  The library is then
    /// shuffled using the mainboard of the deck that belongs to the player.  The player
    /// is then dealt 7 cards from the deck.
    ///
    /// - Parameter player: The player to initialize this board from.
    init(player: Player) {
        self.player = player
        library = player.deck.mainboardCards.shuffled()
        for _ in 0..<7 {
            hand.append(library.removeFirst())
        }
    }
}
