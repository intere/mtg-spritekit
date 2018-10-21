//
//  Player.swift
//  CardGameV2
//
//  Created by Eric Internicola on 9/29/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import Foundation

class Player {
    var name: String
    var deck: Deck

    init(name: String, deck: Deck) {
        self.name = name
        self.deck = deck
    }
}
