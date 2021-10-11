//
//  CombineFetchURLIntegrationTests.swift
//  CardGameTests
//
//  Created by Eric Internicola on 10/8/21.
//  Copyright © 2021 iColasoft. All rights reserved.
//

@testable import CardGame
import XCTest

class CombineMagicCardSearchTests: XCTestCase {
    enum Constants {
        static let timeout: TimeInterval = 10
    }

    let subject = CombineMagicCardSearch()

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testFetchGrowthSpiral() {
        let exp = expectation(description: "fetch")
        subject.search(for: "Growth Spiral") { result in
            switch result {
            case .success(let results):
                XCTAssertNotNil(results.cards)
                XCTAssertFalse(results.cards?.isEmpty ?? true)
            case .failure(let error):
                XCTFail("failed with error: \(error)")
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: Constants.timeout, handler: nil)
    }

    func testFetchTibaltsTrickery() {
        let exp = expectation(description: "fetch")
        subject.search(for: "Tibalt's Trickery") { result in
            switch result {
            case .success(let results):
                XCTAssertNotNil(results.cards)
                XCTAssertFalse(results.cards?.isEmpty ?? true)
            case .failure(let error):
                XCTFail("failed with error: \(error)")
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: Constants.timeout, handler: nil)
    }

    func testFetchDoubleSidedCardFrontFace() {
        let exp = expectation(description: "fetch")
        subject.search(for: "Hostile Hostel") { result in
            switch result {
            case .success(let results):
                XCTAssertNotNil(results.cards)
                XCTAssertFalse(results.cards?.isEmpty ?? true)
            case .failure(let error):
                XCTFail("failed with error: \(error)")
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: Constants.timeout, handler: nil)
    }

    func testFetchDoubleSidedCardBackFace() {
        let exp = expectation(description: "fetch")
        subject.search(for: "Creeping Inn") { result in
            switch result {
            case .success(let results):
                XCTAssertNotNil(results.cards)
                XCTAssertFalse(results.cards?.isEmpty ?? true)
            case .failure(let error):
                XCTFail("failed with error: \(error)")
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: Constants.timeout, handler: nil)
    }

    func testFetchUgin() {
        let exp = expectation(description: "fetch")
        subject.search(for: "Ugin, the Spirit Dragon") { result in
            switch result {
            case .success(let results):
                XCTAssertNotNil(results.cards)
                XCTAssertFalse(results.cards?.isEmpty ?? true)
            case .failure(let error):
                XCTFail("failed with error: \(error)")
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: Constants.timeout, handler: nil)
    }

    func testFetchRiverglidePathway() {
        let exp = expectation(description: "fetch")
        subject.search(for: "Riverglide Pathway") { result in
            switch result {
            case .success(let results):
                XCTAssertNotNil(results.cards)
                XCTAssertFalse(results.cards?.isEmpty ?? true)
            case .failure(let error):
                XCTFail("failed with error: \(error)")
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: Constants.timeout, handler: nil)
    }

    func testFetchBarkchannelPathway() {
        let exp = expectation(description: "fetch")
        subject.search(for: "Barkchannel Pathway") { result in
            switch result {
            case .success(let results):
                XCTAssertNotNil(results.cards)
                XCTAssertFalse(results.cards?.isEmpty ?? true)
            case .failure(let error):
                XCTFail("failed with error: \(error)")
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: Constants.timeout, handler: nil)
    }

    func testFetchSteamVents() {
        let exp = expectation(description: "fetch")
        subject.search(for: "Steam Vents") { result in
            switch result {
            case .success(let results):
                XCTAssertNotNil(results.cards)
                XCTAssertFalse(results.cards?.isEmpty ?? true)
            case .failure(let error):
                XCTFail("failed with error: \(error)")
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: Constants.timeout, handler: nil)
    }

    func testFetchCragcrownPathway() {
        let exp = expectation(description: "fetch")
        subject.search(for: "Cragcrown Pathway") { result in
            switch result {
            case .success(let results):
                XCTAssertNotNil(results.cards)
                XCTAssertFalse(results.cards?.isEmpty ?? true)
            case .failure(let error):
                XCTFail("failed with error: \(error)")
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: Constants.timeout, handler: nil)
    }

    func testFetchThassasOracle() {
        let exp = expectation(description: "fetch")
        subject.search(for: "Thassa's Oracle (THB) 73") { result in
            switch result {
            case .success(let results):
                XCTAssertNotNil(results.cards)
                XCTAssertFalse(results.cards?.isEmpty ?? true)
            case .failure(let error):
                XCTFail("failed with error: \(error)")
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: Constants.timeout, handler: nil)
    }
}
