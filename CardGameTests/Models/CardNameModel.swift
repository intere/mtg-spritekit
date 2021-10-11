//
//  CardNameModel.swift
//  CardGameTests
//
//  Created by Eric Internicola on 10/10/21.
//  Copyright © 2021 iColasoft. All rights reserved.
//

@testable import CardGame
import XCTest

class CardNameModel: XCTestCase {

    func testCardNameAndSet() {
        // Thassa's Oracle (THB) 73
        let cardName: CardName = .fromCardName(string: "Thassa's Oracle (THB) 73")
        XCTAssertEqual("Thassa's Oracle", cardName.name)
        XCTAssertEqual("THB", cardName.setCode)
        XCTAssertEqual(73, cardName.number)
    }

}
