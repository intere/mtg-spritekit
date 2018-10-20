//
//  UIAlertControllerExtensions.swift
//  CardGame
//
//  Created by Eric Internicola on 10/20/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import UIKit

extension UIAlertController {

    typealias EmptyAlertCallback = () -> Void

    /// Builds you a "yes/no" alert.
    ///
    /// - Parameters:
    ///   - title: The title text.
    ///   - message: The message text.
    ///   - yesCallback: calls back when the user picks "yes"
    ///   - noCallback: calls back when the user picks "no"
    /// - Returns: the alert that was created.
    static func yesNoAlert(title: String, message: String, yesCallback: EmptyAlertCallback? = nil, noCallback: EmptyAlertCallback? = nil) -> UIAlertController {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            yesCallback?()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
            noCallback?()
        }))
        return alert
    }

    /// Creates you an alert with an "OK" button only and lets you get a callback for when
    /// the user presses that button.
    ///
    /// - Parameters:
    ///   - title: The title text.
    ///   - message: The message text.
    ///   - callback: An optional callback for when the user hits the okay button.
    /// - Returns: The alert that was created
    static func okayAlert(title: String, message: String, callback: EmptyAlertCallback? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            callback?()
        }))
        return alert
    }



}
