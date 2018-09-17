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

import MTGSDKSwift
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


        guard let deck = DeckReader.shared.read(fileNamed: "deck.txt") else {
            return
        }

        CardManager.shared.loadCards(forDeck: deck) { (cards, error) in
            if let error = error {
                return print("ERROR loading deck: \(error.localizedDescription)")
            }
            guard let cards = cards else {
                return print("ERROR: no cards came back")
            }
            DispatchQueue.main.async { [weak self] in
                self?.show(deck: deck, cards: cards)
            }
        }
    }

    func show(deck: Deck, cards: [MTGSDKSwift.Card]) {
        var cardHash = [String: MTGSDKSwift.Card]()
        cards.forEach { card in
            guard let name = card.name else {
                return print("ERROR: Card with no name")
            }
            cardHash[name] = card
        }

        var startX = 100
        var startY = 100

        var count = 0

        for card in deck.mainboard {
            guard let apiCard = cardHash[card.name], apiCard.imageUrl != nil else {
                print("ERROR: no image for card \(card.name)")
                continue
            }
            for _ in 0..<card.quantity {
                let skCard = SKCard(card: apiCard)
                skCard.position = CGPoint(x: startX, y: startY)
                addChild(skCard)
                startX += 15
                startY += 15
            }

            count += 1
            startX = 100 + count * 20
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)           // 1
            if let card = atPoint(location) as? SKCard {        // 2
                if card.enlarged { return }
                card.position = location
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let location = touch.location(in: self)
            if let card = atPoint(location) as? SKCard {
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
            if let card = atPoint(location) as? SKCard {
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

    func wiggle(it card: SKCard) {
        let wiggleIn = SKAction.scaleX(to: 1.0, duration: 0.2)
        let wiggleOut = SKAction.scaleX(to: 1.2, duration: 0.2)
        let wiggle = SKAction.sequence([wiggleIn, wiggleOut])

        card.run(SKAction.repeatForever(wiggle), withKey: "wiggle")
    }

    func stopWiggle(it card: SKCard) {
        card.removeAction(forKey: "wiggle")
    }

}
