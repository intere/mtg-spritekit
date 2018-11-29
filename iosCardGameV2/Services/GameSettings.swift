//
//  GameSettings.swift
//  CardGame
//
//  Created by Eric Internicola on 11/29/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import Foundation

class GameSettings {
    static let shared = GameSettings()

    var player1Name: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "player1Name")
        }
        get {
            return UserDefaults.standard.string(forKey: "player1Name")
        }
    }

    var player1Deck: URL? {
        set {
            UserDefaults.standard.set(newValue, forKey: "player1Deck")
        }
        get {
            return UserDefaults.standard.url(forKey: "player1Deck")
        }
    }

    var player2Name: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "player2Name")
        }
        get {
            return UserDefaults.standard.string(forKey: "player2Name")
        }
    }

    var player2Deck: URL? {
        set {
            UserDefaults.standard.set(newValue, forKey: "player2Deck")
        }
        get {
            return UserDefaults.standard.url(forKey: "player2Deck")
        }
    }
}
