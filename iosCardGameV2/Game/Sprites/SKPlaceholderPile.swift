//
//  SKPlaceholderPile.swift
//  CardGame
//
//  Created by Eric Internicola on 11/18/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import MTGSDKSwift
import SpriteKit

class SKPlaceholderPile {
    let placeholder = SKCardPlaceholder()
    let pile: SKCardPile

    init(title: String, cards: [Card], faceDown: Bool = true) {
        pile = SKCardPile(title: title, cards: cards, faceDown: faceDown)
        
    }
}
