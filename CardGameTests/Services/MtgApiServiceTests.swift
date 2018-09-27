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

class MtgApiServiceTests: XCTestCase {

    let deck = DeckReader.shared.read(fileNamed: "deck.txt")

}

// MARK: - Entire Deck Loading Tests

extension MtgApiServiceTests {

    func testLoadCardsOnlyInkmoth() {
        let deck = Deck(mainboard: [CardGroup(name: "Inkmoth Nexus", quantity: 1)], sideboard: [])
        let exp = expectation(description: "loadCards")

        MtgApiService.shared.loadCards(forDeck: deck) { (cards, error) in
            defer {
                exp.fulfill()
            }
            if let error = error {
                XCTFail("Failed with error: \(error.localizedDescription)")
            }
            guard let cards = cards else {
                return XCTFail("Cards came back nil")
            }
            XCTAssertEqual(1, cards.count, "Not enough cards came back")

            for card in cards {
                guard let cardName = card.name else {
                    XCTFail("card without a name: \(card.id)")
                    continue
                }
                XCTAssertNotNil(card.imageUrl, "Card \(cardName) had a nil image")
            }
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func testLoadDeckOfCards() {
        guard let deck = deck else {
            return XCTFail("No test deck to play with")
        }
        XCTAssertEqual(60, deck.mainboardCount)
        let uniqueCount = deck.uniqueCardNames.count

        let exp = expectation(description: "loadCards")
        MtgApiService.shared.loadCards(forDeck: deck) { (cards, error) in
            defer {
                exp.fulfill()
            }
            if let error = error {
                XCTFail("Failed with error: \(error.localizedDescription)")
            }
            guard let cards = cards else {
                return XCTFail("Cards came back nil")
            }
            XCTAssertEqual(uniqueCount, cards.count, "Not enough cards came back")
            for card in cards {
                XCTAssertNotNil(card.imageUrl, "Card \(card.name!) had a nil image")
            }
            var hash = [String: Card]()
            cards.forEach {
                guard let name = $0.name else {
                    return XCTFail("Failed to get a name for a card")
                }
                hash[name] = $0
            }
            deck.mainboard.forEach { card in
                XCTAssertNotNil(hash[card.name], "\(card.name) had no card")
            }
            deck.sideboard.forEach { card in
                XCTAssertNotNil(hash[card.name], "\(card.name) had no card")
            }
        }

        waitForExpectations(timeout: 10, handler: nil)
    }
}

// MARK: - Problem Cards

extension MtgApiServiceTests {

    func testLoadDampingSphere() {

        let exp = expectation(description: "loadCards")

        search(forCard: "Damping Sphere") { (cards, error) in
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

    func testLoadInkmothNexus() {
        let exp = expectation(description: "loadCards")

        search(forCard: "Inkmoth Nexus") { (cards, error) in
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
}

// MARK: - Image Loading Tests

extension MtgApiServiceTests {

    func testLoadImages() {
        let exp = expectation(description: "loadCards")

        search(forCard: "Inkmoth Nexus") { (cards, error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
            guard let cards = cards else {
                return XCTFail("Cards came back nil")
            }
            guard let inkmothNexusImageUrl = cards.first?.imageUrl else {
                return XCTFail("No image came back for Inkmoth Nexus")
            }
            MtgApiService.shared.loadImage(urlString: inkmothNexusImageUrl) { (image, error) in
                defer {
                    exp.fulfill()
                }
                if let error = error {
                    XCTFail("Error loading image: \(error.localizedDescription)")
                }
                guard let image = image else {
                    return XCTFail("Nil image came back for url \(inkmothNexusImageUrl)")
                }
                do {
                    try UIImagePNGRepresentation(image)?.write(to: URL(fileURLWithPath: "/tmp/nexus.png"))
                } catch {
                    XCTFail("Failed to write the nexus image")
                }
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }

}

// MARK: - Implementation

extension MtgApiServiceTests {

    func search(forCard cardName: String, completion: @escaping Magic.CardCompletion) {
        let magic = Magic()
        magic.fetchPageSize = "10"
        magic.fetchPageTotal = "1"
        Magic.enableLogging = true

        let params = [
            CardSearchParameter(parameterType: .name, value: cardName),
            CardSearchParameter(parameterType: .contains, value: "imageUrl")
        ]
        magic.fetchCards(params, completion: completion)
    }
}
