//
//  Game.swift
//  CardGameV2
//
//  Created by Eric Internicola on 9/29/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import Foundation
import MTGSDKSwift
import GameplayKit

typealias CreateGameBlock = (Game?, Error?) -> Void

class Game {

    /// The PlayerBoard objects in the game
    var boards: [PlayerBoard]

    /// The game type (Modern by default)
    var format: String = "Modern"

    private var playsFirstIndex = 0

    var turn = 0

    init(boards: [PlayerBoard]) {
        self.boards = boards
    }

    /// Creates the game by going off and loading the cards for each deck.  When
    /// This process completes for both decks, the completion block then runs.
    ///
    /// - Parameters:
    ///   - player1: The first player's name.
    ///   - deck1: The first player's deck.
    ///   - player2: The second player's name.
    ///   - deck2: The second player's deck.
    ///   - completion: The block to handle the completion of the deck loading.
    static func createGame(player1: String, deck1: URL, player2: String, deck2: URL, completion: @escaping CreateGameBlock) {
        guard let firstDeck = DeckReader.shared.readFile(path: deck1),
            let secondDeck = DeckReader.shared.readFile(path: deck2) else {
            return completion(nil, nil)
        }
        var firstCached = false
        var secondCached = false

        let finish = {
            guard firstCached && secondCached else {
                return
            }
            let game = Game(boards: [
                PlayerBoard(player: Player(name: player1, deck: firstDeck)),
                PlayerBoard(player: Player(name: player2, deck: secondDeck))
            ])
            completion(game, nil)
        }

        MtgApiService.shared.cache(deck: firstDeck) { error in
            if let error = error {
                return completion(nil, error)
            }
            firstCached = true
            finish()
        }
        MtgApiService.shared.cache(deck: secondDeck) { error in
            if let error = error {
                return completion(nil, error)
            }
            secondCached = true
            finish()
        }
    }
}
