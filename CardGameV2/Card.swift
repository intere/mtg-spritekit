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

enum CardType :Int {
    case wolf,
    bear,
    dragon,
    back

    static var types: [CardType] {
        return [.wolf, .bear, .dragon, .back]
    }
}

class Card : SKSpriteNode {
    let cardType: CardType
    var frontTexture: SKTexture?
    let frontUrlString: String
    let backTexture: SKTexture
    var damage = 0
    let damageLabel :SKLabelNode
    var faceUp = true
    var enlarged = false
    var savedPosition = CGPoint.zero

    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    init(cardType: CardType) {
        self.cardType = cardType
        backTexture = SKTexture(imageNamed: "mtg_back")

        switch cardType {
        case .wolf:
            frontUrlString = "https://static.tappedout.net/mtg-cards-2/dragons-maze/armored-wolf-rider/armored-wolf-rider-cropped.jpg"
        case .bear:
            frontUrlString = "https://static.tappedout.net/mtg-cards-2/portal-three-kingdoms/forest-bear/forest-bear.jpg"
        case .dragon:
            frontUrlString = "https://static.tappedout.net/mtg-cards-2/innistrad/balefire-dragon/balefire-dragon-cropped.jpg"

        case .back:
            frontUrlString = ""
            frontTexture = backTexture
        }

        damageLabel = SKLabelNode(fontNamed: "OpenSans-Bold")
        damageLabel.name = "damageLabel"
        damageLabel.fontSize = 12
        damageLabel.fontColor = SKColor(red: 0.47, green: 0.0, blue: 0.0, alpha: 1.0)
        damageLabel.text = "0"
        damageLabel.position = CGPoint(x: 25, y: 40)

        super.init(texture: backTexture, color: .clear, size: CGSize(width: 100, height: 140))
        addChild(damageLabel)

        makeTexture()
    }

    func makeTexture() {
        guard !frontUrlString.isEmpty else {
            return
        }

        CardManager.shared.loadImage(urlString: frontUrlString) { (image, error) in
            guard let image = image else {
                return
            }
            self.frontTexture = SKTexture(image: image)
            DispatchQueue.main.async {
                self.texture = self.frontTexture
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
                let scaleUp = SKAction.scale(to: 5.0, duration:0.3)
                let rotation = SKAction.rotate(toAngle: 0, duration: 0.3)
                run(SKAction.group([slide, scaleUp, rotation]))
            }
        }
    }
}
