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

    /// Tests parsing a deck with an empty line separating the mainboard from the sideboard
    func testParseWithEmptyLine() {
        let listWithEmptyLine = "4 Ancient Stirrings\n2 Animation Module\n4 Arcbound Ravager\n4 Arcbound Worker\n1 Blinkmoth Nexus\n4 Darksteel Citadel\n1 Evolutionary Leap\n6 Forest\n4 Hangarback Walker\n4 Hardened Scales\n2 Horizon Canopy\n4 Inkmoth Nexus\n4 Mox Opal\n1 Pendelhaven\n1 Phyrexia's Core\n1 Ruins of Oran-Rief\n4 Steel Overseer\n2 Throne of Geth\n4 Walking Ballista\n3 Welding Jar\n\n\n4 Damping Sphere\n2 Dismember\n1 Grafdigger's Cage\n2 Karn, Scion of Urza\n4 Nature's Claim\n2 Surgical Extraction"

        let deck = DeckReader.shared.read(fileContent: listWithEmptyLine)

        XCTAssertEqual(60, deck.mainboardCount)
        XCTAssertEqual(15, deck.sideboardCount)
    }

    /// Tests parsing a deck with an empty line separating the mainboard from the sideboard
    /// and uses the windows-style CRLF line separation
    func testParseWithEmptyLineAndCrLf() {
        let listWithEmptyLine = "4 Ancient Stirrings\r\n2 Animation Module\r\n4 Arcbound Ravager\r\n4 Arcbound Worker\r\n1 Blinkmoth Nexus\r\n4 Darksteel Citadel\r\n1 Evolutionary Leap\r\n6 Forest\r\n4 Hangarback Walker\r\n4 Hardened Scales\r\n2 Horizon Canopy\r\n4 Inkmoth Nexus\r\n4 Mox Opal\r\n1 Pendelhaven\r\n1 Phyrexia's Core\r\n1 Ruins of Oran-Rief\r\n4 Steel Overseer\r\n2 Throne of Geth\r\n4 Walking Ballista\r\n3 Welding Jar\r\n\r\n4 Damping Sphere\r\n2 Dismember\r\n1 Grafdigger's Cage\r\n2 Karn, Scion of Urza\r\n4 Nature's Claim\r\n2 Surgical Extraction"

        let deck = DeckReader.shared.read(fileContent: listWithEmptyLine)

        XCTAssertEqual(60, deck.mainboardCount)
        XCTAssertEqual(15, deck.sideboardCount)
    }

    /// Tests a deck that has a "Sideboard:" to separate the mainboard from the sideboard
    func testParseWithSideboardLine() {
        let listWithSideboardLine = "4 Ancient Stirrings\n2 Animation Module\n4 Arcbound Ravager\n4 Arcbound Worker\n1 Blinkmoth Nexus\n4 Darksteel Citadel\n1 Evolutionary Leap\n6 Forest\n4 Hangarback Walker\n4 Hardened Scales\n2 Horizon Canopy\n4 Inkmoth Nexus\n4 Mox Opal\n1 Pendelhaven\n1 Phyrexia's Core\n1 Ruins of Oran-Rief\n4 Steel Overseer\n2 Throne of Geth\n4 Walking Ballista\n3 Welding Jar\nSideboard\n\n4 Damping Sphere\n2 Dismember\n1 Grafdigger's Cage\n2 Karn, Scion of Urza\n4 Nature's Claim\n2 Surgical Extraction"

        let deck = DeckReader.shared.read(fileContent: listWithSideboardLine)

        XCTAssertEqual(60, deck.mainboardCount)
        XCTAssertEqual(15, deck.sideboardCount)
    }

    func testReadBundledDeck() {
        guard let deck = DeckReader.shared.readBundleFile(fileNamed: "deck.txt") else {
            return XCTFail("Failed to load deck")
        }
        XCTAssertEqual(60, deck.mainboardCount)
        XCTAssertEqual(15, deck.sideboardCount)
    }
    
}
