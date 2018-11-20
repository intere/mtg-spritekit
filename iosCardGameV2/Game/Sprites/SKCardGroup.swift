//
//  SKCardGroup.swift
//  CardGame
//
//  Created by Eric Internicola on 11/18/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import MTGSDKSwift
import SpriteKit

class SKCardGroup: SKNode {

    private(set) var cards: [SKCard]

    init(name: String? = nil, cards: [SKCard] = []) {
        self.cards = cards
        super.init()
        self.name = name

        layout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func add(card: SKCard) {
        guard !cards.contains(card) else {
            return
        }
        cards.append(card)
        addChild(card)
        layout()
    }

    func remove(card: SKCard) {
        guard let index = cards.firstIndex(of: card) else {
            return
        }
        cards.remove(at: index)
        card.removeFromParent()
        layout()
    }

    func layout() {
        children.forEach { $0.removeFromParent() }

        let width = (SKCard.Constants.width + 5) * CGFloat(cards.count) + 5
        let boundsRect = SKShapeNode(rectOf: CGSize(width: width, height: SKCard.Constants.height + 10))
        boundsRect.position = CGPoint(x: width / 2 - SKCard.Constants.width / 2, y: 0)
        boundsRect.fillColor = UIColor.green.withAlphaComponent(0.5)
        addChild(boundsRect)

        var startX: CGFloat = 5
        for card in cards {
            addChild(card)
            card.position = CGPoint(x: startX, y: 0)
            startX += card.frame.width + 5
        }
    }

}
