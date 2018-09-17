//
//  CardManagerTests.swift
//  CardGameTests
//
//  Created by Eric Internicola on 9/17/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

@testable import CardGame
import MTGSDKSwift
import XCTest

class CardManagerTests: XCTestCase {

    let deck = DeckReader.shared.read(fileNamed: "deck.txt")

    func testLoadCards() {
        guard let deck = deck else {
            return XCTFail("No test deck to play with")
        }
        XCTAssertEqual(60, deck.mainboardCount)

        let exp = expectation(description: "loadCards")
        CardManager.shared.loadCards(forDeck: deck) { (cards, error) in
            defer {
                exp.fulfill()
            }
            if let error = error {
                XCTFail("Failed with error: \(error.localizedDescription)")
            }
            guard let cards = cards else {
                return XCTFail("Cards came back nil")
            }
            XCTAssertTrue(cards.count > 5, "Not enough cards came back")
            for card in cards {
                XCTAssertNotNil(card.imageUrl, "Card \(card.name!) had a nil image")
            }
        }

        waitForExpectations(timeout: 10, handler: nil)
    }
    
}
