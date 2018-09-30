//
//  Game.swift
//  CardGameV2
//
//  Created by Eric Internicola on 9/29/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import Foundation
import MTGSDKSwift
import GameplayKit

class Game {

    /// The PlayerBoard objects in the game
    var boards: [PlayerBoard]

    /// The game type (Modern by default)
    var format: String = "Modern"

    private var playsFirstIndex = 0

    var turn = 0

    init(boards: [PlayerBoard]) {
        self.boards = boards
        
    }
}
