//
//  PlayerBoardTests.swift
//  CardGameTests
//
//  Created by Eric Internicola on 9/29/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

@testable import CardGame
import XCTest

class PlayerBoardTests: BaseDeckTest {

    func testInitialization() {
        XCTAssertNotEqual(0, deck.mainboard.count)
        XCTAssertNotEqual(0, deck.sideboard.count)

        let player = Player(name: "Zoltan", deck: deck)
        let board = PlayerBoard(player: player)
        XCTAssertEqual(0, board.library.count)
        XCTAssertEqual(0, board.hand.count)

        board.startGame()
        XCTAssertEqual(53, board.library.count)
        XCTAssertEqual(7, board.hand.count)
    }

}
