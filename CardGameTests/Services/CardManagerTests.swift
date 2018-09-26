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

    func testLoadDampingSphere() {
        let cardName = "Damping Sphere"

        let magic = Magic()
        magic.fetchPageSize = "2"
        magic.fetchPageTotal = "1"
        Magic.enableLogging = true

        let exp = expectation(description: "loadCards")
        let params = [
            CardSearchParameter(parameterType: .name, value: cardName),
            CardSearchParameter(parameterType: .contains, value: "imageUrl")
        ]
        magic.fetchCards(params) { (cards, error) in
            defer {
                exp.fulfill()
            }
            if let error = error {
                XCTFail(error.localizedDescription)
            }
            guard let cards = cards else {
                return XCTFail("Cards came back nil")
            }
            XCTAssertNotEqual(0, cards.count)
            for card in cards {
                XCTAssertNotNil(card.imageUrl)
            }
        }

        waitForExpectations(timeout: 10, handler: nil)

    }

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
