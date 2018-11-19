//
//  SKPlaceholderPile.swift
//  CardGame
//
//  Created by Eric Internicola on 11/18/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import MTGSDKSwift
import SpriteKit

class SKPlaceholderPile: SKNode {
    var placeholder: SKCardPlaceholder
    var pile: SKCardPile

    init(pile: SKCardPile) {
        self.pile = pile
        placeholder = SKCardPlaceholder()
        super.init()
        addChild(placeholder)
        addChild(pile)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
