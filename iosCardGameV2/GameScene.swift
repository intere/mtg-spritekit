

import MTGSDKSwift
import SpriteKit

enum CardLevel :CGFloat {
    case board = 10
    case moving = 100
    case enlarged = 200
}

class GameScene: SKScene {

    override func didMove(to view: SKView) {
        #if !os(tvOS)
        let bg = SKSpriteNode(imageNamed: "bg_blank")
        bg.anchorPoint = CGPoint.zero
        bg.position = CGPoint.zero
        addChild(bg)
        #endif

        guard NSClassFromString("XCTestCase") == nil else {
            return
        }

        guard let deck = DeckReader.shared.read(fileNamed: "deck.txt") else {
            return
        }

        MtgApiService.shared.loadCards(forDeck: deck) { (cards, error) in
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

}

// MARK: - Implementation

extension GameScene {

    /// Wiggle animation for when you're moving the card
    ///
    /// - Parameter card: The card you want to animate the wiggle on.
    func wiggle(it card: SKCard) {
        let wiggleIn = SKAction.scaleX(to: 1.0, duration: 0.2)
        let wiggleOut = SKAction.scaleX(to: 1.2, duration: 0.2)
        let wiggle = SKAction.sequence([wiggleIn, wiggleOut])

        card.run(SKAction.repeatForever(wiggle), withKey: "wiggle")
    }

    /// Stops the wigling animation on the card
    ///
    /// - Parameter card: The card you want to stop the wiggle on.
    func stopWiggle(it card: SKCard) {
        card.removeAction(forKey: "wiggle")
    }

    /// Renders the deck on the screen (makes use of the deck and the cards).
    ///
    /// - Parameters:
    ///   - deck: The deck to show on the screen.
    ///   - cards: The cards to show on the screen.
    func show(deck: Deck, cards: [MTGSDKSwift.Card]) {
        var cardHash = [String: MTGSDKSwift.Card]()
        cards.forEach { card in
            guard let name = card.name else {
                return print("ERROR: Card with no name")
            }
            cardHash[name] = card
        }

        var startX = CGFloat(100)
        var startY = CGFloat(frame.maxY - 10) - SKCard.Constants.height / 2

        for card in deck.mainboard {
            guard let apiCard = cardHash[card.name] else {
                print("ERROR: no API Card for \(card.name)")
                continue
            }
            guard apiCard.imageUrl != nil else {
                print("ERROR: no image for card \(card.name)")
                continue
            }
            for _ in 0..<card.quantity {
                let skCard = SKCard(card: apiCard)
                skCard.position = CGPoint(x: startX, y: startY)
                if reset(y: startY) {
                    resetPosition(card: skCard)
                    startX = skCard.position.x
                    startY = skCard.position.y
                }
                addChild(skCard)
//                print("added card at \(skCard.position)")
                startY -= 25
            }
            startY -= SKCard.Constants.height
        }
    }

    /// Should the y be reset (based on the current Y value)?
    ///
    /// - Parameter y: The y value we want to drop a card in at.
    /// - Returns: True if the y value would have the card too low, false if not.
    func reset(y: CGFloat) -> Bool {
        return y - SKCard.Constants.height / 2 < 10
    }

    /// Takes the provided card and moves it up and to the right.
    ///
    /// - Parameter card: The card to be repositioned.
    func resetPosition(card: SKCard) {
        let newY = CGFloat(frame.maxY - 10) - SKCard.Constants.height / 2
        let newX = card.position.x + 20 + SKCard.Constants.width

        card.position = CGPoint(x: newX, y: newY)
    }
}
