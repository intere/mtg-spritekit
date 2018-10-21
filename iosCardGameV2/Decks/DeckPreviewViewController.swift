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
    var deck: Deck?

    override func viewDidLoad() {
        super.viewDidLoad()

        buildScene()
    }

    func buildScene() {
        guard let deck = deck else {
            return assertionFailure("No Deck")
        }

        let scene = DeckScene(size: skView.frame.size)
        scene.deck = deck
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .resizeFill

        skView.presentScene(scene)
    }

}
