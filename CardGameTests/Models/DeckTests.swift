//
//  DeckTests.swift
//  CardGameTests
//
//  Created by Eric Internicola on 9/29/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

@testable import CardGame
import MTGSDKSwift
import XCTest

class DeckTests: BaseDeckTest {

    func testGetMainboard() {
        let mainboard = deck.mainboardCards
        XCTAssertEqual(60, mainboard.count)
    }

}
