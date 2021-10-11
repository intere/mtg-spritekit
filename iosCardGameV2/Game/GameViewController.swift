//
//  GameViewController.swift
//  CardGame
//
//  Created by Eric Internicola on 9/27/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import Cartography
import SpriteKit
import UIKit

class GameViewController: UIViewController {

    var game: Game!
    var lastPanPoint: CGPoint?
    var lastScale: CGFloat?
    var scene: GameScene!

    let topHudView = UIView()
    let bottomHudView = UIView()
    var topHudHeightConstraint: NSLayoutConstraint!
    var bottomHudHeighConstraint: NSLayoutConstraint!

    lazy var panPrinter = {
        return Debouncer(delay: 0.1) { [weak self] in
            guard let self = self, let lastPanPoint = self.lastPanPoint else { return }
            Logger.debug("Pan Point: \(lastPanPoint)")
        }
    }()
    lazy var scalePrinter = {
        return Debouncer(delay: 0.1) { [weak self] in
            guard let self = self, let lastScale = self.lastScale else { return }
            Logger.debug("Scale: \(lastScale)")
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()

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
        panPrinter.call()
    }

    @objc
    func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        lastScale = self.pinchHandler(gesture, lastScale: lastScale, scene: scene)
        scalePrinter.call()
    }

}

// MARK: - Notifications

extension GameViewController {

    @objc
    func gameLoaded(_ notification: NSNotification) {
        let alert = UIAlertController(title: "Your hand", message: "Do you want to keep?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "No, mulligan", style: .default, handler: { _ in
            Logger.info("Taking a mulligan")
            Notification.UserAction.mulliganHand.notify()
        }))
        alert.addAction(UIAlertAction(title: "Yes, keep", style: .default, handler: { _ in
            Logger.info("Keeping")
            Notification.UserAction.keepHand.notify()
        }))

        present(alert, animated: true)
    }

}

// MARK: - Implementation

extension GameViewController {

    func configureView() {
        let skView = self.view as! SKView
        scene = GameScene(size: skView.frame.size)
        scene.playerBoard = game.boards[0]

        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)

        [topHudView, bottomHudView].forEach { view in
            view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            skView.addSubview(view)
        }

        constrain(skView, topHudView, bottomHudView) { view, topHudView, bottomHudView in
            topHudView.left == view.left
            topHudView.top == view.top
            topHudView.right == view.right
            topHudHeightConstraint = topHudView.height == 0

            bottomHudView.left == view.left
            bottomHudView.right == view.right
            bottomHudView.bottom == view.bottom
            bottomHudHeighConstraint = bottomHudView.height == 0
        }
    }

}
