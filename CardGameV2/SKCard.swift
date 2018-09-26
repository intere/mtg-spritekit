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

class SKCard: SKSpriteNode {

    struct Constants {
        static let width: CGFloat = 100
        static let height: CGFloat = 140
    }

    var frontTexture: SKTexture?
    let backTexture: SKTexture
    var damage = 0
    let damageLabel :SKLabelNode
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

        MtgApiService.shared.loadImage(urlString: imageUrl) { (image, error) in
            guard let image = image else {
                return print("No image for url: \(imageUrl)")
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
                let scaleUp = SKAction.scale(to: 4.0, duration:0.3)
                let rotation = SKAction.rotate(toAngle: 0, duration: 0.3)
                run(SKAction.group([slide, scaleUp, rotation]))
            }
        }
    }
}
