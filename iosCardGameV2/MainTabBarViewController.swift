//
//  MainTabBarViewController.swift
//  CardGame
//
//  Created by Eric Internicola on 10/21/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Notification.DeckEvent.playDeck.addObserver(self, selector: #selector(playDeck(_:)))
    }

}

// MARK: - Notifications

extension MainTabBarViewController {

    @objc
    func playDeck(_ notification: NSNotification) {
        guard let deck = notification.object as? Deck else {
            return
        }

        let gamePlayVC = GameViewController.loadFromStoryboard()
        gamePlayVC.deck = deck

        selectedIndex = 1
        (children[1] as? UINavigationController)?.setViewControllers([gamePlayVC], animated: true)
    }

}
