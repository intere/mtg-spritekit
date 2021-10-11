//
//  CardSearchResultTests.swift
//  CardGameTests
//
//  Created by Eric Internicola on 10/10/21.
//  Copyright © 2021 iColasoft. All rights reserved.
//

@testable import CardGame
import XCTest

class CardSearchResultTests: XCTestCase {

    func testDeserializeGrowthSpiralSearch() throws {
        guard let data = try loadTestBundleJson(named: "Search-GrowthSpiral") else {
            return XCTFail("No data")
        }

        let result = try JSONDecoder().decode(CardSearchResults.self, from: data)
        XCTAssertNotNil(result.cards)
        XCTAssertNotEqual(0, result.cards?.count ?? 0)
    }

    func testDeserializeIslandSearch() throws {
        guard let data = try loadTestBundleJson(named: "Search-Island") else {
            return XCTFail("No data")
        }

        let result = try JSONDecoder().decode(CardSearchResults.self, from: data)
        XCTAssertNotNil(result.cards)
        XCTAssertNotEqual(0, result.cards?.count ?? 0)
    }

    func testHostileHostelSearch() throws {
        guard let data = try loadTestBundleJson(named: "Search-HostileHostel") else {
            return XCTFail("No data")
        }
        let result = try JSONDecoder().decode(CardSearchResults.self, from: data)
        XCTAssertNotNil(result.cards)
        XCTAssertNotEqual(0, result.cards?.count ?? 0)
    }

    func testBorkedSearch() {
        do {
            guard let data = try loadTestBundleJson(named: "Search-HostileHostel")?.halfOfTheData() else {
                return XCTFail("No data")
            }
            let result = try JSONDecoder().decode(CardSearchResults.self, from: data)
            XCTFail("This should have thrown")
            XCTAssertNil(result)
        } catch {
            print("Success - this should fail with error: \(error)")
        }
    }

}

private extension CardSearchResultTests {

    var testBundle: Bundle { return Bundle(for: CardSearchResultTests.self) }

    func loadTestBundleJson(named name: String) throws -> Data? {
        guard let path = testBundle.path(forResource: name, ofType: ".json") else {
            XCTFail("No resource found for file: '\(name).json'")
            return nil
        }
        return try Data(contentsOf: URL(fileURLWithPath: path))
    }
}

private extension Data {
    func halfOfTheData() throws -> Data? {
        guard let string = String(data: self, encoding: .utf8) else { return nil }
        let middle = string.index(string.startIndex, offsetBy: string.count / 2)
        return String(string[string.startIndex...middle]).data(using: .utf8)
    }
}
