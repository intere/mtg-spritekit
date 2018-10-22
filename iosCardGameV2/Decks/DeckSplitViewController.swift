//
//  DeckSplitViewController.swift
//  CardGame
//
//  Created by Eric Internicola on 10/22/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import UIKit

class DeckSplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        preferredDisplayMode = .allVisible
    }

}

// MARK: - UISplitViewControllerDelegate

extension DeckSplitViewController: UISplitViewControllerDelegate {

    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        return true
    }

}
