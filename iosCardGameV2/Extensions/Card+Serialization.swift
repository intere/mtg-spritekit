//
//  Card+Serialization.swift
//  CardGame
//
//  Created by Eric Internicola on 9/27/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import Foundation
import MTGSDKSwift

typealias CardMap = [String: Any]

extension CardMap {
    subscript(index: Parser.CardJsonKey) -> Any? {
        get {
            return self[index.rawValue]
        }
        set(value) {
            self[index.rawValue] = value
        }
    }
}

extension CardSearchResults.Card {

    var jsonData: Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            print("Failed to encode JSON data: \(error)")
            return nil
        }
    }

    static func from(json data: Data) -> CardSearchResults.Card? {
        do {
            return try JSONDecoder().decode(CardSearchResults.Card.self, from: data)
        } catch {
            print("Error decoding Card JSON: \(error)")
            return nil
        }
    }

}

