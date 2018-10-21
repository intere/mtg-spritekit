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

    override func viewDidLoad() {
        super.viewDidLoad()

        buildScene()

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(pan:)))
        view.addGestureRecognizer(panGesture)
    }

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

    @objc
    func handlePan(pan: UIPanGestureRecognizer) {
        guard let panView = pan.view else {
            return
        }
        let translation = pan.translation(in: panView)

        switch pan.state {
        case .changed:
            print("Translation: \(translation)")
            if let lastPanPoint = lastPanPoint {
                let delta = CGPoint(x: translation.x - lastPanPoint.x,
                                    y: translation.y - lastPanPoint.y)
                print("Delta: \(delta)")
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

//        if pan.state == .changed {
//            let translation = pan.translation(in: pan.view!)
//
//            node!.position = SCNVector3(x:node!.position.x + Float(translation.x), y:node!.position.y, z:node!.position.z)
//            pan.setTranslation(CGPoint.zero, in: pan.view!)
//        }
    }

}
