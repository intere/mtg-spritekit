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
    let deck = DeckReader.shared.readBundleFile(fileNamed: "deck.txt")

}

// MARK: - Entire Deck Loading Tests

extension MtgApiServiceTests {

    func testLoadCardsOnlyInkmoth() {
        let deck = Deck(mainboard: [CardGroup(name: "Inkmoth Nexus", quantity: 1)], sideboard: [])
        let exp = expectation(description: "loadCards")

        MtgApiService.shared.loadCards(forDeck: deck) { result in
            defer {
                exp.fulfill()
            }

            switch result {
            case .error(let error):
                XCTFail("Failed with error: \(error.localizedDescription)")

            case .success(let cards):
                XCTAssertEqual(1, cards.count, "Not enough cards came back")

                for card in cards {
                    guard let cardName = card.name else {
                        XCTFail("card without a name: \(card.multiverseid!)")
                        continue
                    }
                    XCTAssertNotNil(card.imageUrl, "Card \(cardName) had a nil image")
                }
            }
        }

        waitForExpectations(timeout: 10, handler: nil)
        for group in deck.mainboard {
            XCTAssertNotNil(group.card, "Missing the card")
            XCTAssertEqual(group.name, group.card?.name)
        }
    }

    func testLoadDeckOfCards() {
        Magic.enableLogging = true
        guard let deck = deck else {
            return XCTFail("No test deck to play with")
        }
        XCTAssertEqual(60, deck.mainboardCount)
        let uniqueCount = deck.uniqueCardNames.count

        let exp = expectation(description: "loadCards")
        MtgApiService.shared.loadCards(forDeck: deck) { result in
            defer {
                exp.fulfill()
            }

            switch result {
            case .error(let error):
                XCTFail("Failed with error: \(error.localizedDescription)")

            case .success(let cards):
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
        }

        waitForExpectations(timeout: 10, handler: nil)
    }
}

// MARK: - Problem Cards

extension MtgApiServiceTests {

    func testLoadDampingSphere() {

        let exp = expectation(description: "loadCards")

        search(forCard: "Damping Sphere") { result in
            defer {
                exp.fulfill()
            }
            switch result {
            case .error(let error):
                XCTFail(error.localizedDescription)

            case .success(let cards):
                XCTAssertNotEqual(0, cards.count)
                for card in cards {
                    XCTAssertNotNil(card.imageUrl)
                }
            }
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func testLoadInkmothNexus() {
        let exp = expectation(description: "loadCards")

        search(forCard: "Inkmoth Nexus") { result in
            defer {
                exp.fulfill()
            }
            switch result {
            case .error(let error):
                XCTFail(error.localizedDescription)

            case .success(let cards):
                XCTAssertNotEqual(0, cards.count)
                for card in cards {
                    XCTAssertNotNil(card.imageUrl)
                }
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}

// MARK: - Image Loading Tests

extension MtgApiServiceTests {

    func testLoadImages() {
        let exp = expectation(description: "loadCards")

        search(forCard: "Inkmoth Nexus") { result in
            switch result {
            case .error(let error):
                XCTFail(error.localizedDescription)

            case .success(let cards):
                guard let inkmothNexusImageUrl = cards.first?.imageUrl else {
                    return XCTFail("No image came back for Inkmoth Nexus")
                }
                MtgApiService.shared.loadImage(urlString: inkmothNexusImageUrl) { result in
                    defer {
                        exp.fulfill()
                    }
                    switch result {
                    case .error(let error):
                        XCTFail("Error loading image: \(error.localizedDescription)")

                    case .success(let image):
                        do {
                            try UIImagePNGRepresentation(image)?.write(to: URL(fileURLWithPath: "/tmp/nexus.png"))
                        } catch {
                            XCTFail("Failed to write the nexus image")
                        }
                    }
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
        let config = MTGSearchConfiguration(pageSize: 10, pageTotal: 1)
        Magic.enableLogging = true

        let params = [
            CardSearchParameter(parameterType: .name, value: cardName),
            CardSearchParameter(parameterType: .contains, value: "imageUrl")
        ]
        magic.fetchCards(params, configuration: config, completion: completion)
    }
}
