//
//  SKCard+Actions.swift
//  CardGame
//
//  Created by Eric Internicola on 10/20/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import SpriteKit

extension SKCard {

    /// Wiggle animation (e.g. for when you're moving the card)
    func wiggle() {
        let wiggleIn = SKAction.scaleX(to: 1.0, duration: 0.2)
        let wiggleOut = SKAction.scaleX(to: 1.2, duration: 0.2)
        let wiggle = SKAction.sequence([wiggleIn, wiggleOut])
        run(SKAction.repeatForever(wiggle), withKey: ActionConstants.wiggleActionName)
    }

    /// Stops the wigling animation on the card
    func stopWiggle() {
        removeAction(forKey: ActionConstants.wiggleActionName)
    }

    /// Enlarges the card and moves it to the center of the screen for viewing
    func toggleEnlarged() {
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

    /// Visual cue that the card has been picked up
    func pickup() {
        zPosition = CardLevel.moving.rawValue
        removeAction(forKey: ActionConstants.dropActionName)
        run(SKAction.group([
            SKAction.scale(to: 1.3, duration: 0.25),
            SKAction.repeatForever(SKAction.sequence([
                SKAction.rotate(toAngle: 0.1, duration: 0.25),
                SKAction.rotate(toAngle: -0.1, duration: 0.25)
                ]))
            ]), withKey: ActionConstants.pickupActionName)
        wiggle()
    }

    func dropCard(on parent: SKNode) {
        zPosition = CardLevel.board.rawValue
        removeFromParent()
        parent.addChild(self)
        removeAction(forKey: ActionConstants.pickupActionName)
        run(SKAction.rotate(toAngle: 0, duration: 0.25), withKey: ActionConstants.stopActionName)
        run(SKAction.scale(to: 1.0, duration: 0.25), withKey: ActionConstants.dropActionName)
        stopWiggle()
    }


}

// MARK: - Implementation

private extension SKCard {

    struct ActionConstants {
        static let wiggleActionName = "wiggle"
        static let pickupActionName = "pickup"
        static let dropActionName = "drop"
        static let stopActionName = "stop"
    }

}
