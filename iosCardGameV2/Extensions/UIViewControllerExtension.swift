//
//  UIViewControllerExtension.swift
//  CardGame
//
//  Created by Eric Internicola on 10/20/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import SpriteKit
import UIKit

extension UIViewController {

    /// Handles the logic of the pinch gesture and brokers it between your caller (ViewController) and the Scene.
    ///
    /// - Parameters:
    ///   - pinch: The pinch gesture that we're responding to.
    ///   - lastScale: The last scale measurement (from the gesture) for comparison's sake (we only want to scale by a delta).
    ///   - scene: The scene that we're scaling.
    /// - Returns: The new `lastScale` value that you should pass into the next call to this function.
    func pinchHandler(_ pinch: UIPinchGestureRecognizer, lastScale: CGFloat?, scene: SKScene) -> CGFloat? {
        let scale = pinch.scale
        switch pinch.state {
        case .changed:
            if let lastScale = lastScale {
                let delta = lastScale - scale
                scene.scale(by: delta)
            }
            return scale

        case .began:
            return scale

        case .ended, .cancelled:
            return nil

        default:
            break
        }
        return lastScale
    }


    /// Handles the logic of the pan gesture and brokers it between your caller (ViewController) and the Scene.
    ///
    /// - Parameters:
    ///   - pan: The pan gesture that we're responding to.
    ///   - lastPanPoint: The last pan point (from the gesture) for comparison's sake (we only want to pan by the delta).
    ///   - scene: The scen that we're panning around in.
    /// - Returns: The new `lastPanPoint` value that you should pass into the next call to this function.
    func panHandler(_ pan: UIPanGestureRecognizer, lastPanPoint: CGPoint?, scene: SKScene) -> CGPoint? {
        guard let panView = pan.view else {
            return lastPanPoint
        }
        let translation = pan.translation(in: panView)

        switch pan.state {
        case .changed:
            if let lastPanPoint = lastPanPoint {
                let delta = CGPoint(x: translation.x - lastPanPoint.x,
                                    y: translation.y - lastPanPoint.y)
                scene.pan(by: delta)
            }
            return translation

        case .began:
            return translation

        case .ended, .cancelled:
            return nil

        default:
            break
        }
        return lastPanPoint
    }

}

