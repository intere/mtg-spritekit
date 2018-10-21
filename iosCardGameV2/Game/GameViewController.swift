//
//  GameViewController.swift
//  CardGame
//
//  Created by Eric Internicola on 9/27/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    var deck: Deck?
    var lastPanPoint: CGPoint?
    var lastScale: CGFloat?
    var scene: GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let deck = deck else {
            return
        }


        let skView = self.view as! SKView
        scene = GameScene(size: skView.frame.size)
        scene.playerBoard = PlayerBoard(player: Player(name: "User", deck: deck))

        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)

        Notification.GameSceneEvent.gameLoaded.addObserver(self, selector: #selector(gameLoaded(_:)))

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        [panGesture, pinchGesture].forEach { view.addGestureRecognizer($0) }
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }

    class func loadFromStoryboard() -> GameViewController {
        return UIStoryboard(name: "Gameplay", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
    }
  
}

// MARK: - Gestures

extension GameViewController {

    @objc
    func handlePan(_ gesture: UIPanGestureRecognizer) {
        lastPanPoint = panHandler(gesture, lastPanPoint: lastPanPoint, scene: scene)
    }

    @objc
    func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        lastScale = self.pinchHandler(gesture, lastScale: lastScale, scene: scene)
    }

}

// MARK: - Notifications

extension GameViewController {

    @objc
    func gameLoaded(_ notification: NSNotification) {
        let alert = UIAlertController(title: "Your hand", message: "Do you want to take a mulligan?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "No, keep", style: .default, handler: { _ in
            print("Keeping")
            Notification.UserAction.keepHand.notify()
        }))
        alert.addAction(UIAlertAction(title: "Yes, mulligan", style: .default, handler: { _ in
            print("Taking a mulligan")
            Notification.UserAction.mulliganHand.notify()
        }))

        present(alert, animated: true)
    }

}
