//
//  Card+SerializationTests.swift
//  CardGameTests
//
//  Created by Eric Internicola on 9/27/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

@testable import CardGame
@testable import MTGSDKSwift
import XCTest

class Card_SerializationTests: XCTestCase {

    var chandra: Card? {
        guard let chandra = readMapped(jsonfile: "417683.json") else {
            return nil
        }
        return Parser.parseCards(json: chandra).first
    }

    var emrakul: Card? {
        guard let emrakul = readMapped(jsonfile: "397905.json") else {
            return nil
        }
        return Parser.parseCards(json: emrakul).first
    }

    func testSerializeChandra() {
        guard let chandra = chandra else {
            return XCTFail("Failed to load chandra")
        }
        let serialized = [ Parser.JsonKeys.cards: [ chandra.toJsonMap ] ]

        guard let deserialized = Parser.parseCards(json: serialized).first else {
            return XCTFail("Failed to deserialize our payload")
        }
        XCTAssertEqual(chandra.name, deserialized.name, "The name field was not the same")
        XCTAssertEqual(chandra.names, deserialized.names, "The names field was not the same")
        XCTAssertEqual(chandra.manaCost, deserialized.manaCost, "The manaCost field was not the same")
        XCTAssertEqual(chandra.cmc, deserialized.cmc, "The cmc field was not the same")
        XCTAssertEqual(chandra.colors, deserialized.colors, "The colors field was not the same")
        XCTAssertEqual(chandra.colorIdentity, deserialized.colorIdentity, "The colorIdentity field was not the same")
        XCTAssertEqual(chandra.type, deserialized.type, "The type field was not the same")
        XCTAssertEqual(chandra.supertypes, deserialized.supertypes, "The supertypes field was not the same")
        XCTAssertEqual(chandra.types, deserialized.types, "The types field was not the same")
        XCTAssertEqual(chandra.subtypes, deserialized.subtypes, "The subtypes field was not the same")
        XCTAssertEqual(chandra.rarity, deserialized.rarity, "The rarity field was not the same")
        XCTAssertEqual(chandra.set, deserialized.set, "The set field was not the same")
        XCTAssertEqual(chandra.setName, deserialized.setName, "The setName field was not the same")
        XCTAssertEqual(chandra.text, deserialized.text, "The text field was not the same")
        XCTAssertEqual(chandra.artist, deserialized.artist, "The artist field was not the same")
        XCTAssertEqual(chandra.number, deserialized.number, "The number field was not the same")
        XCTAssertEqual(chandra.power, deserialized.power, "The power field was not the same")
        XCTAssertEqual(chandra.toughness, deserialized.toughness, "The toughness field was not the same")
        XCTAssertEqual(chandra.layout, deserialized.layout, "The layout field was not the same")
        XCTAssertEqual(chandra.multiverseid, deserialized.multiverseid, "The multiverseid field was not the same")
        XCTAssertEqual(chandra.imageUrl, deserialized.imageUrl, "The imageUrl field was not the same")
        XCTAssertEqual(chandra.rulings, deserialized.rulings, "The rulings field was not the same")
        XCTAssertEqual(chandra.foreignNames, deserialized.foreignNames, "The foreignNames field was not the same")
        XCTAssertEqual(chandra.printings, deserialized.printings, "The printings field was not the same")
        XCTAssertEqual(chandra.originalText, deserialized.originalText, "The originalText field was not the same")
        XCTAssertEqual(chandra.originalType, deserialized.originalType, "The originalType field was not the same")
        XCTAssertEqual(chandra.id, deserialized.id, "The id field was not the same")
        XCTAssertEqual(chandra.flavor, deserialized.flavor, "The flavor field was not the same")
        XCTAssertEqual(chandra.loyalty, deserialized.loyalty, "The loyalty field was not the same")

        chandra.legalities.forEach { (key, value) in
            XCTAssertTrue(deserialized.legalities.keys.contains(key))
            XCTAssertEqual(value, deserialized.legalities[key])
        }
    }

    func testSerializeEmrakul() {
        guard let emrakul = emrakul else {
            return XCTFail("Failed to load chandra")
        }
        let serialized = [ Parser.JsonKeys.cards: [ emrakul.toJsonMap ] ]

        guard let deserialized = Parser.parseCards(json: serialized).first else {
            return XCTFail("Failed to deserialize our payload")
        }
        XCTAssertEqual(emrakul.name, deserialized.name, "The name field was not the same")
        XCTAssertEqual(emrakul.names, deserialized.names, "The names field was not the same")
        XCTAssertEqual(emrakul.manaCost, deserialized.manaCost, "The manaCost field was not the same")
        XCTAssertEqual(emrakul.cmc, deserialized.cmc, "The cmc field was not the same")
        XCTAssertEqual(emrakul.colors, deserialized.colors, "The colors field was not the same")
        XCTAssertEqual(emrakul.colorIdentity, deserialized.colorIdentity, "The colorIdentity field was not the same")
        XCTAssertEqual(emrakul.type, deserialized.type, "The type field was not the same")
        XCTAssertEqual(emrakul.supertypes, deserialized.supertypes, "The supertypes field was not the same")
        XCTAssertEqual(emrakul.types, deserialized.types, "The types field was not the same")
        XCTAssertEqual(emrakul.subtypes, deserialized.subtypes, "The subtypes field was not the same")
        XCTAssertEqual(emrakul.rarity, deserialized.rarity, "The rarity field was not the same")
        XCTAssertEqual(emrakul.set, deserialized.set, "The set field was not the same")
        XCTAssertEqual(emrakul.setName, deserialized.setName, "The setName field was not the same")
        XCTAssertEqual(emrakul.text, deserialized.text, "The text field was not the same")
        XCTAssertEqual(emrakul.artist, deserialized.artist, "The artist field was not the same")
        XCTAssertEqual(emrakul.number, deserialized.number, "The number field was not the same")
        XCTAssertEqual(emrakul.power, deserialized.power, "The power field was not the same")
        XCTAssertEqual(emrakul.toughness, deserialized.toughness, "The toughness field was not the same")
        XCTAssertEqual(emrakul.layout, deserialized.layout, "The layout field was not the same")
        XCTAssertEqual(emrakul.multiverseid, deserialized.multiverseid, "The multiverseid field was not the same")
        XCTAssertEqual(emrakul.imageUrl, deserialized.imageUrl, "The imageUrl field was not the same")
        XCTAssertEqual(emrakul.rulings, deserialized.rulings, "The rulings field was not the same")
        XCTAssertEqual(emrakul.foreignNames, deserialized.foreignNames, "The foreignNames field was not the same")
        XCTAssertEqual(emrakul.printings, deserialized.printings, "The printings field was not the same")
        XCTAssertEqual(emrakul.originalText, deserialized.originalText, "The originalText field was not the same")
        XCTAssertEqual(emrakul.originalType, deserialized.originalType, "The originalType field was not the same")
        XCTAssertEqual(emrakul.id, deserialized.id, "The id field was not the same")
        XCTAssertEqual(emrakul.flavor, deserialized.flavor, "The flavor field was not the same")
        XCTAssertEqual(emrakul.loyalty, deserialized.loyalty, "The loyalty field was not the same")

        emrakul.legalities.forEach { (key, value) in
            XCTAssertTrue(deserialized.legalities.keys.contains(key))
            XCTAssertEqual(value, deserialized.legalities[key])
        }
    }

}

// MARK: - Implementation

extension Card_SerializationTests {

    /// Reads the provided json file as a JSONResults (`[String: Any]`)
    ///
    /// - Parameter named: the name of the file to open.
    /// - Returns: the JSONResults object if possible.
    func readMapped(jsonfile named: String) -> JSONResults? {
        guard let data = read(jsonfile: named) else {
            return nil
        }
        do {
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSONResults
        } catch {
            XCTFail("Failed to parse JSON: \(error.localizedDescription)")
            return nil
        }
    }

    /// Reads the provided json file to data.
    ///
    /// - Parameter named: the file name to read.
    /// - Returns: the data from the file or nil.
    func read(jsonfile named: String) -> Data? {
        guard let filePath = Bundle(for: type(of: self)).path(forResource: named, ofType: nil) else {
            XCTFail("Failed to locate the file: \(named)")
            return nil
        }
        do {
            return try Data(contentsOf: URL(fileURLWithPath: filePath))
        } catch {
            XCTFail("Failed to read data from file \(filePath): \(error.localizedDescription)")
            return nil
        }
    }
}
