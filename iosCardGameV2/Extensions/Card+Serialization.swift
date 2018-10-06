//
//  Card+Serialization.swift
//  CardGame
//
//  Created by Eric Internicola on 9/27/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import Foundation
import MTGSDKSwift

extension Card {

    /// Converts this specific card into a single card json payload
    /// which would be nested under a "cards" array in a real JSON payload
    /// (see https://api.magicthegathering.io/v1/cards?name=nissa,%20worldwaker|jace|ajani)
    var toJsonMap: [String: Any] {
        var map = [String: Any]()
        if let name = name {
            map[Parser.JsonKeys.name] = name
        }
        if let names = names {
            map[Parser.JsonKeys.names] = names
        }
        if let manaCost = manaCost {
            map[Parser.JsonKeys.manaCost] = manaCost
        }
        if let cmc = cmc {
            map[Parser.JsonKeys.cmc] = cmc
        }
        if let colors = colors {
            map[Parser.JsonKeys.colors] = colors
        }
        if let colorIdentiy = colorIdentity {
            map[Parser.JsonKeys.colorIdentity] = colorIdentiy
        }
        if let type = type {
            map[Parser.JsonKeys.type] = type
        }
        if let supertypes = supertypes {
            map[Parser.JsonKeys.supertypes] = supertypes
        }
        if let types = types {
            map[Parser.JsonKeys.types] = types
        }
        if let subtypes = subtypes {
            map[Parser.JsonKeys.subtypes] = subtypes
        }
        if let rarity = rarity {
            map[Parser.JsonKeys.rarity] = rarity
        }
        if let set = set {
            map[Parser.JsonKeys.set] = set
        }
        if let setName = setName {
            map[Parser.JsonKeys.setName] = setName
        }
        if let text = text {
            map[Parser.JsonKeys.text] = text
        }
        if let artist = artist {
            map[Parser.JsonKeys.artist] = artist
        }
        if let number = number {
            map[Parser.JsonKeys.number] = number
        }
        if let power = power {
            map[Parser.JsonKeys.power] = power
        }
        if let toughness = toughness {
            map[Parser.JsonKeys.toughness] = toughness
        }
        if let layout = layout {
            map[Parser.JsonKeys.layout] = layout
        }
        if let multiverseid = multiverseid {
            map[Parser.JsonKeys.multiverseid] = multiverseid
        }
        if let imageUrl = imageUrl {
            map[Parser.JsonKeys.imageUrl] = imageUrl
        }
        if let rulings = rulings {
            map[Parser.JsonKeys.rulings] = rulings
        }
        if let foreignNames = foreignNames {
            map[Parser.JsonKeys.foreignNames] = foreignNames
        }
        if let printings = printings {
            map[Parser.JsonKeys.printings] = printings
        }
        if let originalText = originalText {
            map[Parser.JsonKeys.originalText] = originalText
        }
        if let originalType = originalType {
            map[Parser.JsonKeys.originalType] = originalType
        }
        if let id = id {
            map[Parser.JsonKeys.id] = id
        }
        if let loyalty = loyalty {
            map[Parser.JsonKeys.loyalty] = loyalty
        }
        var legalityArray = [[String: String]]()
        legalities.forEach { (arg) in
            let (key, value) = arg
            legalityArray.append([
                Parser.JsonKeys.legalityFormat: key,
                Parser.JsonKeys.legalityLegality: value
                ])
        }
        map[Parser.JsonKeys.legalities] = legalityArray

        return map
    }

}

