//
//  BaseDeckTest.swift
//  CardGameTests
//
//  Created by Eric Internicola on 9/29/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

@testable import CardGame
import MTGSDKSwift
import XCTest

class BaseDeckTest: XCTestCase {
    
    let deck = DeckReader.shared.readBundleFile(fileNamed: "deck.txt")!

    override func setUp() {
        super.setUp()
        let exp = expectation(description: "cacheDeck")
        MtgApiService.shared.cache(deck: deck) { (error) in
            defer {
                exp.fulfill()
            }
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
}
