//
//  SKCardPile.swift
//  CardGame
//
//  Created by Eric Internicola on 10/21/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import MTGSDKSwift
import SpriteKit

class SKCardPile: SKSpriteNode {
    var cards: [Card] {
        didSet {
            titleLabel.text = "\(title) - \(cards.count) cards"
        }
    }
    let title: String
    let faceDown: Bool
    let titleLabel = SKLabelNode(fontNamed: "OpenSans-Bold")

    init(title: String, cards: [Card], faceDown: Bool = true) {
        self.title = title
        self.cards = cards
        self.faceDown = faceDown

        super.init(texture: SKCard.Constants.cardBackTexture, color: .clear, size: SKCard.Constants.defaultSize)

        // Title Label:
        titleLabel.fontSize = 12
        titleLabel.fontColor = .white
        titleLabel.text = "\(title) - \(cards.count) cards"
        titleLabel.position = CGPoint(x: 0, y: frame.minY - 15)
        addChild(titleLabel)

        if !faceDown {
            makeTexture()
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Implementation

extension SKCardPile {

    /// Creates the texture for this card
    func makeTexture() {
        guard let card = cards.last, let imageUrl = card.imageUrl else {
            return
        }

        MtgApiService.shared.loadImage(urlString: imageUrl) { result in
            switch result {
            case .success(let image):
                let frontTexture = SKTexture(image: image)
                DispatchQueue.main.async { [weak self] in
                    self?.texture = frontTexture
                }

            default:
                break
            }
        }
    }

}
