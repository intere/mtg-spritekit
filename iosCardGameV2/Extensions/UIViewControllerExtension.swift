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

    struct SceneConstants {
        static let minimumZoomLevel = 0.15
    }

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


    func panHandler(_ pan: UIPanGestureRecognizer, lastPanPoint: CGPoint?,
                   scene: SKScene) -> CGPoint? {
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

