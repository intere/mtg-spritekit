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

class Game {

    /// The PlayerBoard objects in the game
    var boards: [PlayerBoard]

    /// The seed of the current board
    var randomSeedString = {
        return GKARC4RandomSource().seed.base64EncodedString()
    }()

    /// We use a GameKit Random so we get consistent random number generation
    var random: GKARC4RandomSource!

    /// The game type (Modern by default)
    var format: String = "Modern"

    /// The turn number
    var turn = 0

    /// The index of the player who won the roll (and gets to choose to go first or not).
    private var rollWinningPlayer = 0

    init(boards: [PlayerBoard], randomSeedString: String? = nil) {
        self.boards = boards
        self.randomSeedString = randomSeedString ?? self.randomSeedString
        guard let seedData = self.randomSeedString.data(using: .utf8) else {
            assertionFailure("Failed to get the seed data")
            return
        }
        random = GKARC4RandomSource(seed: seedData)
        rollWinningPlayer = random.nextInt(upperBound: boards.count)
        assert(rollWinningPlayer < boards.count, "Start index is too high")
    }
}

// MARK: - API

extension Game {

    /// Did the first player (this player) win the roll?
    var firstPlayerWonRoll: Bool {
        return rollWinningPlayer == 0
    }

}
