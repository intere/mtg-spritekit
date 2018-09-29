//
//  GameViewController.swift
//  CardGameMTG
//
//  Created by Eric Internicola on 9/28/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var skView: SKView {
        return view as! SKView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = GameScene(size: CGSize(width: view.frame.width / 1.5, height: view.frame.height / 1.5))
        let skView = self.view as! SKView

        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let circle = SKShapeNode(circleOfRadius: 50)
            circle.fillColor = .red
            circle.position = skView.scene?.convertPoint(fromView: touch.location(in: skView)) ?? .zero
            skView.scene?.addChild(circle)
            circle.run(SKAction.fadeOut(withDuration: 1)) {
                circle.removeFromParent()
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let circle = SKShapeNode(circleOfRadius: 25)
            circle.fillColor = .blue
            circle.position = skView.scene?.convertPoint(fromView: touch.location(in: skView)) ?? .zero
            skView.scene?.addChild(circle)
            circle.run(SKAction.fadeOut(withDuration: 0.5)) {
                circle.removeFromParent()
            }
        }
    }

}
