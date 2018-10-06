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

    struct Constants {
        static let width: CGFloat = 100
        static let height: CGFloat = 140
    }

    var frontTexture: SKTexture?
    let backTexture: SKTexture
    var damage = 0
    var damageLabel: SKLabelNode?
    var faceUp = true
    var enlarged = false
    var savedPosition = CGPoint.zero
    var tapped = false
    var card: Card

    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    init(card: Card) {
        self.card = card
        backTexture = SKTexture(imageNamed: "mtg_back")

        super.init(texture: backTexture, color: .clear, size: CGSize(width: 100, height: 140))

        makeTexture()
        damageLabel = makeDamageLabel()
    }

    func tap() {
        tapped = true
        run(SKAction.rotate(toAngle: 90.radians.cgFloat, duration: 0.3))
    }

    func untap() {
        tapped = false
        run(SKAction.rotate(toAngle: -90.radians.cgFloat, duration: 0.3))
    }

    func makeTexture() {
        guard let imageUrl = card.imageUrl else {
            return
        }

        MtgApiService.shared.loadImage(urlString: imageUrl) { result in

            switch result {
            case .success(let image):
                self.frontTexture = SKTexture(image: image)
                DispatchQueue.main.async {
                    self.texture = self.frontTexture
                }

            default:
                break
            }
        }
    }

    func enlarge() {
        if enlarged {
            let slide = SKAction.move(to: savedPosition, duration:0.3)
            let scaleDown = SKAction.scale(to: 1.0, duration:0.3)
            run(SKAction.group([slide, scaleDown])) {
                self.enlarged = false
                self.zPosition = CardLevel.board.rawValue
            }
        } else {
            enlarged = true
            savedPosition = position

            zPosition = CardLevel.enlarged.rawValue

            if let parent = parent {
                removeAllActions()
                let newPosition = CGPoint(x: parent.frame.midX, y: parent.frame.midY)
                let slide = SKAction.move(to: newPosition, duration:0.3)
                let scaleUp = SKAction.scale(to: 4.0, duration:0.3)
                let rotation = SKAction.rotate(toAngle: 0, duration: 0.3)
                run(SKAction.group([slide, scaleUp, rotation]))
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
