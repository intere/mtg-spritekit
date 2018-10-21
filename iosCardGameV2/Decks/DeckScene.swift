//
//  DeckScene.swift
//  CardGame
//
//  Created by Eric Internicola on 10/20/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import SpriteKit
import UIKit

class DeckScene: SKScene {

    var deck: Deck?
    var messageLabel: SKLabelNode?

    override func didMove(to view: SKView) {
        super.didMove(to: view)

        addLoadingLabel()
        cacheDeck()
    }

    /// Loads the deck (deck.txt file) and caches all of the images for it.
    func cacheDeck() {
        guard let deck = deck else {
            return
        }

        // Ensure that we cache all of the cards in the deck, then continue
        MtgApiService.shared.cache(deck: deck) { (error) in
            DispatchQueue.main.async { [weak self] in
                if let error = error {
                    self?.messageLabel?.text = "Error loading deck from API\n\(error.localizedDescription)"
                    return
                }
                self?.messageLabel?.run(SKAction.fadeOut(withDuration: 0.5)) {
                    self?.messageLabel?.removeFromParent()
                }

                self?.show(deck: deck)
            }
        }
    }

    /// Adds a "loading" message to the view.
    func addLoadingLabel() {
        let messageLabel = SKLabelNode(text: "Loading cards, please wait...")
        messageLabel.fontSize = 36
        messageLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(messageLabel)
        self.messageLabel = messageLabel
    }

    /// Renders the deck on the screen (makes use of the deck and the cards).
    ///
    /// - Parameters:
    ///   - deck: The deck to show on the screen.
    ///   - cards: The cards to show on the screen.
    func show(deck: Deck) {

        var startX = CGFloat(50)
        var startY = CGFloat(frame.maxY - 10) - SKCard.Constants.height / 2

        for card in deck.mainboard {
            for _ in 0..<card.quantity {
                guard let cardInfo = card.card else {
                    print("Failed to find the card for \(card.name)")
                    continue
                }
                let skCard = SKCard(card: cardInfo)
                skCard.position = CGPoint(x: startX, y: startY)
                if reset(y: startY) {
                    resetPosition(card: skCard)
                    startX = skCard.position.x
                    startY = skCard.position.y
                }
                addChild(skCard)
                startY -= 25
            }
            startY -= SKCard.Constants.height
        }
    }

    func reset(y: CGFloat) -> Bool {
        return y - SKCard.Constants.height / 2 < 10
    }

    func resetPosition(card: SKCard) {
        let newY = CGFloat(frame.maxY - 10) - SKCard.Constants.height / 2
        let newX = card.position.x + 20 + SKCard.Constants.width

        card.position = CGPoint(x: newX, y: newY)
    }
}
