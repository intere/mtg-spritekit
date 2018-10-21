//
//  Notifications.swift
//  CardGame
//
//  Created by Eric Internicola on 10/20/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import Foundation

// MARK: - GameSceneEvent Notification

extension Notification {

    enum GameSceneEvent: String, Notifiable, CustomStringConvertible {
        case gameLoaded = "gameLoaded"

        static var notificationBase: String {
            return "com.cardgame.game.scene"
        }

        var description: String {
            return rawValue
        }
    }
}

// MARK: - UserActions Notification

extension Notification {

    enum UserAction: String, Notifiable, CustomStringConvertible {
        case mulliganHand = "mulligan.hand"
        case keepHand = "keep.hand"

        static var notificationBase: String {
            return "com.cardgame.user.action"
        }

        var description: String {
            return rawValue
        }
    }
}

// MARK: - DeckEvent Notifications

extension Notification {

    enum DeckEvent: String, Notifiable, CustomStringConvertible {
        case newDeckSaved = "new.deck.saved"
        case selectDeck = "select.deck"

        static var notificationBase: String {
            return "com.cardgame.deck.event"
        }

        var description: String {
            return rawValue
        }
    }
}
