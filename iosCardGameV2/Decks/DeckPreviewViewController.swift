//
//  DeckPreviewViewController.swift
//  CardGame
//
//  Created by Eric Internicola on 10/20/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import SpriteKit
import UIKit

class DeckPreviewViewController: UIViewController {

    @IBOutlet weak var skView: SKView!
    var scene: DeckScene!
    var deck: Deck?
    var lastPanPoint: CGPoint?
    var lastScale: CGFloat?

    override func viewDidLoad() {
        super.viewDidLoad()

        buildScene()

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        [panGesture, pinchGesture].forEach { view.addGestureRecognizer($0) }
    }

    class func loadFromStoryboard() -> DeckPreviewViewController {
        return UIStoryboard(name: "DeckPreview", bundle: nil).instantiateInitialViewController() as! DeckPreviewViewController
    }

}

// MARK: - Gestures

extension DeckPreviewViewController {

    @objc
    func handlePinch(_ pinch: UIPinchGestureRecognizer) {
        let scale = pinch.scale
        switch pinch.state {
        case .changed:
            if let lastScale = lastScale {
                let delta = lastScale - scale
                scene.scale(by: delta)
            }
            lastScale = scale

        case .began:
            lastScale = scale

        case .ended, .cancelled:
            lastScale = nil

        default:
            break
        }
    }

    @objc
    func handlePan(_ pan: UIPanGestureRecognizer) {
        guard let panView = pan.view else {
            return
        }
        let translation = pan.translation(in: panView)

        switch pan.state {
        case .changed:
            if let lastPanPoint = lastPanPoint {
                let delta = CGPoint(x: translation.x - lastPanPoint.x,
                                    y: translation.y - lastPanPoint.y)
                scene.pan(by: delta)
            }
            lastPanPoint = translation

        case .began:
            lastPanPoint = translation

        case .ended, .cancelled:
            lastPanPoint = nil

        default:
            break
        }
    }

}

// MARK: - Implementation

extension DeckPreviewViewController {

    func buildScene() {
        guard let deck = deck else {
            return assertionFailure("No Deck")
        }

        scene = DeckScene(size: skView.frame.size)
        scene.deck = deck
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .resizeFill

        skView.presentScene(scene)
    }

}
