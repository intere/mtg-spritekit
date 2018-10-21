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


    override func viewDidLoad() {
        super.viewDidLoad()
        guard let deck = deck else {
            return
        }


        let skView = self.view as! SKView
        let scene = GameScene(size: skView.frame.size)
        scene.playerBoard = PlayerBoard(player: Player(name: "User", deck: deck))

        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)

        Notification.GameSceneEvent.gameLoaded.addObserver(self, selector: #selector(gameLoaded(_:)))
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }

    class func loadFromStoryboard() -> GameViewController {
        return UIStoryboard(name: "Gameplay", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
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
