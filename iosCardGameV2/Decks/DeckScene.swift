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
    let theCamera = SKCameraNode()
    var selected: SKCard?

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        camera = theCamera
        theCamera.setScale(1)
        theCamera.position = CGPoint(x: frame.midX, y: frame.midY)

        addLoadingLabel()
        cacheDeck()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            guard let card = card(for: touch) else {
                continue
            }
            if let selected = selected {
                if selected == card {
                    selected.deselect()
                    self.selected = nil
                } else {
                    selected.deselect()
                    card.select()
                    self.selected = card
                }

            } else {
                card.select()
                self.selected = card
            }

            return
        }
    }
}

// MARK: - Implementation

extension DeckScene {

    /// Gets you the card for the provided touch.
    ///
    /// - Parameter touch: The touch event
    /// - Returns: An SKCard if there was one at the touch point.
    func card(for touch: UITouch) -> SKCard? {
        let location = touch.location(in: self)
        return card(at: location)
    }

    /// Gets you the card at the provided location.
    ///
    /// - Parameter location: The location to check for a cad.
    /// - Returns: The SKCard if it exists at the provided point.
    func card(at location: CGPoint) -> SKCard? {
        return atPoint(location) as? SKCard
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
                    self?.messageLabel?.text = "Error loading deck from API: \n\(error.localizedDescription)"
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
        var startX = CGFloat(0)
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

        adjustCamera()
    }

    func adjustCamera() {
        guard let camera = camera else {
            return assertionFailure("No camera to adjust")
        }
        var minX = CGFloat.greatestFiniteMagnitude
        var minY = CGFloat.greatestFiniteMagnitude
        var maxX = CGFloat(0)
        var maxY = CGFloat(0)

        for card in children where card is SKCard {
            minX = min(minX, card.position.x)
            minY = min(minY, card.position.y)
            maxX = max(maxX, card.position.x)
            maxY = max(maxY, card.position.y)
        }

        let rect = CGRect(x: minX, y: minY, width: maxX-minX, height: maxY-minY)
        let centerPoint = CGPoint(x: rect.midX, y: rect.midY)
        camera.position = centerPoint
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

// MARK: - CGPoint Extension

extension CGPoint {

    func panMove(by point: CGPoint) -> CGPoint {
        return CGPoint(x: x - point.x, y: y + point.y)
    }

}
