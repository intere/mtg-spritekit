/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import SpriteKit

enum CardLevel :CGFloat {
    case board = 10
    case moving = 100
    case enlarged = 200
}

class GameScene: SKScene {

    override func didMove(to view: SKView) {
        let bg = SKSpriteNode(imageNamed: "bg_blank")
        bg.anchorPoint = CGPoint.zero
        bg.position = CGPoint.zero
        addChild(bg)

        var startX = 100
        for type in CardType.types {
            let card = Card(cardType: type)
            card.position = CGPoint(x: startX, y: 200)
            addChild(card)
            startX += 150
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)           // 1
            if let card = atPoint(location) as? Card {        // 2
                if card.enlarged { return }
                card.position = location
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let location = touch.location(in: self)
            if let card = atPoint(location) as? Card {
                if touch.tapCount > 1 {
                    card.enlarge()
                    return
                }

                if card.enlarged { return }

                card.zPosition = CardLevel.moving.rawValue
                card.removeAction(forKey: "drop")
                card.run(SKAction.group([
                    SKAction.scale(to: 1.3, duration: 0.25),
                    SKAction.repeatForever(SKAction.sequence([
                        SKAction.rotate(toAngle: 0.1, duration: 0.25),
                        SKAction.rotate(toAngle: -0.1, duration: 0.25)
                        ]))
                    ]), withKey: "pickup")
                wiggle(it: card)
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let card = atPoint(location) as? Card {
                guard !card.enlarged else {
                    return
                }
                card.zPosition = CardLevel.board.rawValue
                card.removeFromParent()
                addChild(card)
                card.removeAction(forKey: "pickup")
                card.run(SKAction.rotate(toAngle: 0, duration: 0.25), withKey: "stop")
                card.run(SKAction.scale(to: 1.0, duration: 0.25), withKey: "drop")
                stopWiggle(it: card)
            }
        }
    }

    func wiggle(it card: Card) {
        let wiggleIn = SKAction.scaleX(to: 1.0, duration: 0.2)
        let wiggleOut = SKAction.scaleX(to: 1.2, duration: 0.2)
        let wiggle = SKAction.sequence([wiggleIn, wiggleOut])

        card.run(SKAction.repeatForever(wiggle), withKey: "wiggle")
    }

    func stopWiggle(it card: Card) {
        card.removeAction(forKey: "wiggle")
    }

}
