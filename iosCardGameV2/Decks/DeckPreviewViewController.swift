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
        lastScale = pinchHandler(pinch, lastScale: lastScale, scene: scene)
    }

    @objc
    func handlePan(_ pan: UIPanGestureRecognizer) {
        lastPanPoint = panHandler(pan, lastPanPoint: lastPanPoint, scene: scene)
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
