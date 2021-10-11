//
//  SKCard.swift
//  CardGame
//
//  Created by Eric Internicola on 9/27/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import MTGSDKSwift
import SpriteKit

class SKCard: SKSpriteNode {

    var cardTexture: SKTexture?
    var damage = 0
    var damageLabel: SKLabelNode?
    var faceUp = true
    var enlarged = false
    var savedPosition = CGPoint.zero
    var tapped = false
    var card: CardSearchResults.Card
    var selected = false

    init(card: CardSearchResults.Card) {
        self.card = card
        super.init(texture: Constants.cardBackTexture, color: .clear, size: Constants.defaultSize)

        makeTexture()
        damageLabel = makeDamageLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

}

// MARK: - Card Actions

extension SKCard {

    /// Card selection action
    func select() {
        let childCard = SKSpriteNode(texture: cardTexture)
        childCard.size = size

        texture = Constants.selectedTexture
        size = Constants.selectedSize

        addChild(childCard)
        selected = true
    }

    /// Card deselection action
    func deselect() {

        removeAllChildren()
        texture = cardTexture
        size = Constants.defaultSize
        selected = false
    }

    /// Taps this card
    func tap() {
        guard !tapped else {
            return
        }
        tapped = true
        run(SKAction.rotate(toAngle: 90.radians.cgFloat, duration: 0.3))
    }

    /// Untaps this card
    func untap() {
        guard tapped else {
            return
        }
        tapped = false
        run(SKAction.rotate(toAngle: -90.radians.cgFloat, duration: 0.3))
    }

    /// Creates the texture for this card
    func makeTexture() {
        guard let imageUrl = card.imageURL else {
            return
        }

        MtgApiService.shared.loadImage(urlString: imageUrl) { result in
            switch result {
            case .success(let image):
                self.cardTexture = SKTexture(image: image)
                DispatchQueue.main.async {
                    self.texture = self.cardTexture
                }

            default:
                break
            }
        }
    }

    func makeDamageLabel() -> SKLabelNode {
        let label = SKLabelNode(fontNamed: "OpenSans-Bold")
        label.name = "damageLabel"
        label.fontSize = 12
        label.fontColor = SKColor(red: 0.47, green: 0.0, blue: 0.0, alpha: 1.0)
        label.text = "0"
        label.position = CGPoint(x: 25, y: 40)
        label.isHidden = true
        addChild(label)

        return label
    }
}

// MARK: - Constants

extension SKCard {

    struct Constants {
        static let width: CGFloat = 100
        static let height: CGFloat = 140

        static let defaultSize = CGSize(width: Constants.width, height: Constants.height)
        static let selectedSize = CGSize(width: 106, height: 146)

        static let cardBackTexture = SKTexture(imageNamed: "mtg_back")
        static let selectedTexture = SKTexture(imageNamed: "selected")
    }

}
