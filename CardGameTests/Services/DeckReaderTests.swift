//
//  DeckReaderTests.swift
//  CardGameTests
//
//  Created by Eric Internicola on 9/17/18.
//  Copyright © 2018 Brian Broom. All rights reserved.
//

@testable import CardGame
import XCTest

class DeckReaderTests: XCTestCase {

    func testParse() {
        let list = "4 Ancient Stirrings\n2 Animation Module\n4 Arcbound Ravager\n4 Arcbound Worker\n1 Blinkmoth Nexus\n4 Darksteel Citadel\n1 Evolutionary Leap\n6 Forest\n4 Hangarback Walker\n4 Hardened Scales\n2 Horizon Canopy\n4 Inkmoth Nexus\n4 Mox Opal\n1 Pendelhaven\n1 Phyrexia's Core\n1 Ruins of Oran-Rief\n4 Steel Overseer\n2 Throne of Geth\n4 Walking Ballista\n3 Welding Jar\n\n\n4 Damping Sphere\n2 Dismember\n1 Grafdigger's Cage\n2 Karn, Scion of Urza\n4 Nature's Claim\n2 Surgical Extraction"

        let deck = DeckReader.shared.read(fileContent: list)

        XCTAssertEqual(60, deck.mainboardCount)
        XCTAssertEqual(15, deck.sideboardCount)
    }

    func testReadBundledDeck() {
        guard let deck = DeckReader.shared.read(fileNamed: "deck.txt") else {
            return XCTFail("Failed to load deck")
        }
        XCTAssertEqual(60, deck.mainboardCount)
        XCTAssertEqual(15, deck.sideboardCount)
    }
    
}
