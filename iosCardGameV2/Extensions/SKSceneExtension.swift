//
//  SKSceneExtension.swift
//  CardGame
//
//  Created by Eric Internicola on 10/21/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import SpriteKit

extension SKScene {

    /// Adds the amount of scale change that you provide to the scene.
    /// The concept behind this is to be used by a pinch gesture.
    ///
    /// - Parameter delta: The amount of scale change to add to the current scale.
    func scale(by delta: CGFloat) {
        guard let camera = camera else {
            return assertionFailure("no camera")
        }
        let scale = camera.xScale + delta
        guard scale > 0.15 else {
            return
        }
        camera.setScale(scale)
    }

    /// Pans around in the scene (by moving the camera).
    ///
    /// - Parameter delta: The change in location from the current location
    func pan(by delta: CGPoint) {
        guard let camera = camera else {
            return assertionFailure("no camera")
        }
        camera.position = camera.position.panMove(by: delta)
    }
}
