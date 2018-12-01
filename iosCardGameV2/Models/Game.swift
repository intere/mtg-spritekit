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
    var randomSeedString = {
        return GKARC4RandomSource().seed.base64EncodedString()
    }()
    var random: GKARC4RandomSource!

    /// The game type (Modern by default)
    var format: String = "Modern"

    private var firstPlayerIndex = 0

    var turn = 0

    init(boards: [PlayerBoard], randomSeedString: String? = nil) {
        self.boards = boards
        self.randomSeedString = randomSeedString ?? self.randomSeedString
        guard let seedData = self.randomSeedString.data(using: .utf8) else {
            assertionFailure("Failed to get the seed data")
            return
        }
        random = GKARC4RandomSource(seed: seedData)
        firstPlayerIndex = random.nextInt(upperBound: boards.count)
        assert(firstPlayerIndex < boards.count, "Start index is too high")
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

        // The block that will delegate to the completion handler when everything has called back
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

        // Cache the first deck
        MtgApiService.shared.cache(deck: firstDeck) { error in
            if let error = error {
                return completion(nil, error)
            }
            firstCached = true
            finish()
        }
        // Cache the second deck
        MtgApiService.shared.cache(deck: secondDeck) { error in
            if let error = error {
                return completion(nil, error)
            }
            secondCached = true
            finish()
        }
    }
}
