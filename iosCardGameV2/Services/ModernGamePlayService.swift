//
//  ModernGamePlayService.swift
//  CardGame
//
//  Created by Eric Internicola on 12/1/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import Foundation

class ModernGamePlayService {
    static let shared = ModernGamePlayService()

    /// Creates the game by going off and loading the cards for each deck.  When
    /// This process completes for both decks, the completion block then runs.
    ///
    /// - Parameters:
    ///   - player1: The first player's name.
    ///   - deck1: The first player's deck.
    ///   - player2: The second player's name.
    ///   - deck2: The second player's deck.
    ///   - randomSeedString: The Base64 Encoded UTF-8 String for the random generator.
    ///   - completion: The block to handle the completion of the deck loading.
    func createGame(player1: String, deck1: URL, player2: String, deck2: URL,
                           randomSeedString: String? = nil, completion: @escaping CreateGameBlock) {
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
                ], randomSeedString: randomSeedString)
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
