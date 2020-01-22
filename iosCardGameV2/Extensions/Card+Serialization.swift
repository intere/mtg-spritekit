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

extension Card {

    /// Converts this specific card into a single card json payload
    /// which would be nested under a "cards" array in a real JSON payload
    /// (see https://api.magicthegathering.io/v1/cards?name=nissa,%20worldwaker|jace|ajani)
    var toJsonMap: CardMap {
        var map = CardMap()
        if let name = name {
            map[Parser.CardJsonKey.name] = name
        }
        if let names = names {
            map[Parser.CardJsonKey.names] = names
        }
        if let manaCost = manaCost {
            map[Parser.CardJsonKey.manaCost] = manaCost
        }
        if let cmc = cmc {
            map[Parser.CardJsonKey.cmc] = cmc
        }
        if let colors = colors {
            map[Parser.CardJsonKey.colors] = colors
        }
        if let colorIdentiy = colorIdentity {
            map[Parser.CardJsonKey.colorIdentity] = colorIdentiy
        }
        if let type = type {
            map[Parser.CardJsonKey.type] = type
        }
        if let supertypes = supertypes {
            map[Parser.CardJsonKey.supertypes] = supertypes
        }
        if let types = types {
            map[Parser.CardJsonKey.types] = types
        }
        if let subtypes = subtypes {
            map[Parser.CardJsonKey.subtypes] = subtypes
        }
        if let rarity = rarity {
            map[Parser.CardJsonKey.rarity] = rarity
        }
        if let set = set {
            map[Parser.CardJsonKey.set] = set
        }
        if let setName = setName {
            map[Parser.CardJsonKey.setName] = setName
        }
        if let text = text {
            map[Parser.CardJsonKey.text] = text
        }
        if let artist = artist {
            map[Parser.CardJsonKey.artist] = artist
        }
        if let number = number {
            map[Parser.CardJsonKey.number] = number
        }
        if let power = power {
            map[Parser.CardJsonKey.power] = power
        }
        if let toughness = toughness {
            map[Parser.CardJsonKey.toughness] = toughness
        }
        if let layout = layout {
            map[Parser.CardJsonKey.layout] = layout
        }
        if let multiverseid = multiverseid {
            map[Parser.CardJsonKey.multiverseid] = multiverseid
        }
        if let imageUrl = imageUrl {
            map[Parser.CardJsonKey.imageUrl] = imageUrl
        }
        if let rulings = rulings {
            map[Parser.CardJsonKey.rulings] = rulings
        }
        if let foreignNames = foreignNames {
            map[Parser.CardJsonKey.foreignNames] = foreignNames
        }
        if let printings = printings {
            map[Parser.CardJsonKey.printings] = printings
        }
        if let originalText = originalText {
            map[Parser.CardJsonKey.originalText] = originalText
        }
        if let originalType = originalType {
            map[Parser.CardJsonKey.originalType] = originalType
        }
        if let id = id {
            map[Parser.CardJsonKey.id] = id
        }
        if let loyalty = loyalty {
            map[Parser.CardJsonKey.loyalty] = loyalty
        }
        var legalityArray = [[String: String]]()
        legalities.forEach { (arg) in
            let (key, value) = arg
            legalityArray.append([
                Parser.CardJsonKey.legalitiesFormat.rawValue: key,
                Parser.CardJsonKey.legalitiesLegality.rawValue: value
            ])
        }
        map[Parser.CardJsonKey.legalities] = legalityArray

        return map
    }

}

